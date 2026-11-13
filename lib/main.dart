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

    // Caminho da imagem que você quer mostrar no widget
    String imagemCaminho =
        'https://github.com/wellifabio/senai2026/blob/main/ds/turmas/2DES_A/4%C2%BA%20Semestre/03-ppdm2/aula07/icone.png?raw=true';

    try {
      await HomeWidget.saveWidgetData<String>('chave_imagem', imagemCaminho);
      await HomeWidget.saveWidgetData<String>('chave_texto', 'Ideia');

      await HomeWidget.updateWidget(qualifiedAndroidName: androidWidgetName);
      await HomeWidget.requestPinWidget(
        qualifiedAndroidName: androidWidgetName,
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
