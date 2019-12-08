package zhy.flutter_ctrip

import android.os.Bundle
import com.zhy.plugin.asr.AsrPlugin

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    registerSelfPlugin()
  }

  // 注册插件
  private fun registerSelfPlugin() {
    AsrPlugin.registerWith(registrarFor("com.zhy.plugin.asr.AsrPlugin"))
  }
}
