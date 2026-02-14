package com.example.vratnik_app

import android.content.Context
import android.os.PowerManager
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "vratnik/wakeup"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "wakeUp") {
                wakeUpScreen()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun wakeUpScreen() {

        // 1️⃣ Zapneme window flags
        runOnUiThread {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
            )

        }

        // 2️⃣ Použijeme PowerManager (spoľahlivé riešenie)
        val powerManager =
            getSystemService(Context.POWER_SERVICE) as PowerManager

        val wakeLock = powerManager.newWakeLock(
            PowerManager.FULL_WAKE_LOCK or
                    PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "vratnik:WakeLock"
        )

        wakeLock.acquire(3000) // 3 sekundy stačia
        wakeLock.release()
    }
}
