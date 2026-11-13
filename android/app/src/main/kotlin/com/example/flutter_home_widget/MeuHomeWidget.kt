package com.example.flutter_home_widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class MeuHomeWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val texto = widgetData.getString("chave_texto", null) ?: "Ideia"
        val caminhoImagem = widgetData.getString("chave_imagem", null)
        val imagem = caminhoImagem?.let { BitmapFactory.decodeFile(it) }

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.meu_home_widget).apply {
                setTextViewText(R.id.widget_texto, texto)
                if (imagem != null) {
                    setImageViewBitmap(R.id.widget_imagem, imagem)
                    setViewVisibility(R.id.widget_imagem, View.VISIBLE)
                } else {
                    setViewVisibility(R.id.widget_imagem, View.GONE)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
