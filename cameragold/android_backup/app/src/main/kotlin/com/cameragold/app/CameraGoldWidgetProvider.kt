package com.cameragold.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.app.PendingIntent
import android.net.Uri
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.AppWidgetTarget
import com.bumptech.glide.request.transition.Transition
import android.graphics.Bitmap
import org.json.JSONObject
import android.content.SharedPreferences

/**
 * Camera Gold Widget Provider for Android
 * Displays latest photo from user's pinned group
 */
class CameraGoldWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val WIDGET_CLICK_ACTION = "com.cameragold.app.WIDGET_CLICK"
        private const val REFRESH_ACTION = "com.cameragold.app.REFRESH_WIDGET"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)
        
        when (intent?.action) {
            WIDGET_CLICK_ACTION -> {
                // Handle widget tap
                val photoId = intent.getStringExtra("photoId")
                val groupId = intent.getStringExtra("groupId")
                openApp(context, photoId, groupId)
            }
            REFRESH_ACTION -> {
                // Handle refresh button tap
                refreshWidget(context)
            }
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.camera_gold_widget)
        
        // Get widget data from SharedPreferences
        val widgetData = getWidgetData(context)
        
        if (widgetData != null) {
            // Update widget with photo data
            views.setTextViewText(R.id.widget_group_name, widgetData.groupName)
            views.setTextViewText(R.id.widget_sender_name, widgetData.senderName)
            views.setTextViewText(R.id.widget_timestamp, formatTimestamp(widgetData.timestamp))
            
            // Load photo with Glide
            if (widgetData.thumbnailUrl.isNotEmpty()) {
                val appWidgetTarget = object : AppWidgetTarget(context, R.id.widget_photo, views, appWidgetId) {
                    override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                        super.onResourceReady(resource, transition)
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                }
                
                Glide.with(context)
                    .asBitmap()
                    .load(widgetData.thumbnailUrl)
                    .centerCrop()
                    .into(appWidgetTarget)
            }
            
            // Set click intent
            val clickIntent = Intent(context, CameraGoldWidgetProvider::class.java).apply {
                action = WIDGET_CLICK_ACTION
                putExtra("photoId", widgetData.photoId)
                putExtra("groupId", widgetData.groupId)
            }
            val clickPendingIntent = PendingIntent.getBroadcast(
                context, 0, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_photo, clickPendingIntent)
            
        } else {
            // Show empty state
            views.setTextViewText(R.id.widget_group_name, "No photos yet")
            views.setTextViewText(R.id.widget_sender_name, "Take a photo to get started")
            views.setTextViewText(R.id.widget_timestamp, "")
            views.setImageViewResource(R.id.widget_photo, R.drawable.ic_camera_placeholder)
        }
        
        // Set refresh button intent
        val refreshIntent = Intent(context, CameraGoldWidgetProvider::class.java).apply {
            action = REFRESH_ACTION
        }
        val refreshPendingIntent = PendingIntent.getBroadcast(
            context, 1, refreshIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_refresh, refreshPendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun getWidgetData(context: Context): WidgetData? {
        val prefs: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val jsonString = prefs.getString("flutter.widget_data", null)
        
        return if (jsonString != null && jsonString.isNotEmpty()) {
            try {
                val json = JSONObject(jsonString)
                WidgetData(
                    groupId = json.getString("groupId"),
                    groupName = json.getString("groupName"),
                    photoId = json.optString("photoId", ""),
                    photoUrl = json.getString("photoUrl"),
                    thumbnailUrl = json.getString("thumbnailUrl"),
                    senderName = json.getString("senderName"),
                    timestamp = json.getLong("timestamp")
                )
            } catch (e: Exception) {
                null
            }
        } else {
            null
        }
    }

    private fun openApp(context: Context?, photoId: String?, groupId: String?) {
        context?.let {
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                if (photoId != null && groupId != null) {
                    data = Uri.parse("cameragold://photo/$photoId?groupId=$groupId")
                }
            }
            context.startActivity(intent)
        }
    }

    private fun refreshWidget(context: Context?) {
        context?.let {
            // Send refresh request to Flutter
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra("refresh_widget", true)
            }
            context.startActivity(intent)
        }
    }

    private fun formatTimestamp(timestamp: Long): String {
        val now = System.currentTimeMillis()
        val diff = now - timestamp
        
        return when {
            diff < 60000 -> "Vừa xong"
            diff < 3600000 -> "${diff / 60000}p trước"
            diff < 86400000 -> "${diff / 3600000}h trước"
            else -> "${diff / 86400000}d trước"
        }
    }

    data class WidgetData(
        val groupId: String,
        val groupName: String,
        val photoId: String,
        val photoUrl: String,
        val thumbnailUrl: String,
        val senderName: String,
        val timestamp: Long
    )
}
