import Foundation
import Capacitor
import AVFoundation

@objc(AudioStreamPlugin)
public class AudioStreamPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AudioStreamPlugin"
    public let jsName = "AudioStream"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "start", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "stop", returnType: CAPPluginReturnPromise)
    ]

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
            call.reject("Failed to start recording: \(error.localizedDescription)")
        }
    }

    @objc func stop(_ call: CAPPluginCall) {
        audioStream.stopRecording()
        call.resolve()
    }
}
