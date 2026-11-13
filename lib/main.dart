import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Função para atualizar o widget com uma imagem de fundo e um texto 'Ideia'
  Future<void> atualizarWidgetExterno(BuildContext context) async {
    const String androidWidgetName =
        'com.example.flutter_home_widget.MeuHomeWidget';

    try {
      final imagem = await rootBundle.load('assets/icone.png');
      await HomeWidget.saveFile(
        'chave_imagem',
        imagem.buffer.asUint8List(),
        extension: 'png',
      );
      await HomeWidget.saveWidgetData<String>('chave_texto', 'Ideia');

      await HomeWidget.updateWidget(qualifiedAndroidName: androidWidgetName);
      if (await HomeWidget.isRequestPinWidgetSupported() != true) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Seu launcher não permite adicionar widgets automaticamente. '
              'Adicione o widget Ideia pelo menu de widgets da tela inicial.',
            ),
          ),
        );
        return;
      }

      await HomeWidget.requestPinWidget(
        qualifiedAndroidName: androidWidgetName,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirme a adição do widget na tela inicial.'),
        ),
      );
    } on PlatformException catch (exception) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível criar o widget: ${exception.message ?? exception.code}',
          ),
        ),
      );
    } on Exception catch (exception) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível preparar o widget: $exception'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Home Widget')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Image(image: AssetImage('assets/icone.png')),
              ElevatedButton(
                onPressed: () => atualizarWidgetExterno(context),
                child: const Text('Criar o Widget'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
