package com.joy.space_texting

import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.widget.Toast
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
class MainActivity: FlutterFragmentActivity(){

    private val CHANNEL = "com.example/overlay_permission"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "requestOverlayPermission") {
                requestOverlayPermission()
                result.success(null)
            }
        }
    }

    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
                startActivityForResult(intent, 123)
            } else {
                Toast.makeText(this, "Overlay permission granted", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
