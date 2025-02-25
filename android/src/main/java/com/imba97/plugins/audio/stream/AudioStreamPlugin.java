package com.imba97.plugins.audio.stream;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.annotation.Permission;

@CapacitorPlugin(
    name = "AudioStream",
    permissions = {
        @Permission(
            alias = "microphone",
            strings = { android.Manifest.permission.RECORD_AUDIO }
        )
    }
)
public class AudioStreamPlugin extends Plugin {

    private AudioStream audioStream;

    @Override
    public void load() {
        super.load();
        audioStream = new AudioStream();
        audioStream.setBridge(this.bridge); // 需要给 AudioStream 添加 setBridge 方法
    }

    @PluginMethod
    public void start(PluginCall call) {
        try {
            audioStream.startRecording();
            call.resolve();
        } catch (Exception e) {
            call.reject("Failed to start recording", e);
        }
    }

    @PluginMethod
    public void stop(PluginCall call) {
        try {
            audioStream.stopRecording();
            call.resolve();
        } catch (Exception e) {
            call.reject("Failed to stop recording", e);
        }
    }
}
