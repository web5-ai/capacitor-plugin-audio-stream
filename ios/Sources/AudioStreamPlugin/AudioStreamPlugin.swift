import Capacitor

@objc(AudioStreamPlugin)
public class AudioStreamPlugin: CAPPlugin {
    private var audioStream: AudioStream!

    override public func load() {
        super.load()
        audioStream = AudioStream()
        audioStream.setPlugin(plugin: self)
    }

    @objc func start(_ call: CAPPluginCall) {
        do {
            try audioStream.startRecording()
            call.resolve()
        } catch {
            call.reject("Failed to start recording", error)
        }
    }

    @objc func stop(_ call: CAPPluginCall) {
        audioStream.stopRecording()
        call.resolve()
    }
}
