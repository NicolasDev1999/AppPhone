package com.example.test_project
import android.os.Bundle
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.call_phone"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "callPhone") {
                val number = call.argument<String>("number") ?: ""
                val intent = Intent(Intent.ACTION_CALL, Uri.parse("tel:$number"))
                startActivity(intent)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}




