import AVFoundation
import Capacitor

class AudioStream: NSObject {
    private let sampleRate: Double = 44100
    private let channelCount: AVAudioChannelCount = 1
    private let audioFormat: AVAudioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)!
    
    private var audioRecorder: AVAudioRecorder?
    private var isRecording = false
    private var bridge: CAPBridge?

    func setBridge(bridge: CAPBridge) {
        self.bridge = bridge
    }

    func startRecording() throws {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: sampleRate,
            AVNumberOfChannelsKey: channelCount,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsNonInterleaved: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false
        ]
        
        let url = URL(fileURLWithPath: NSTemporaryDirectory() + "audioRecording.wav")
        try? FileManager.default.removeItem(at: url) // Remove the existing file if exists
        
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.prepareToRecord()
        
        if let recorder = audioRecorder, recorder.record() {
            isRecording = true
        } else {
            throw NSError(domain: "AudioStream", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to start recording"])
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func isRecording() -> Bool {
        return isRecording
    }
}

extension AudioStream: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecordingToURL(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag else { return }
        if let data = try? Data(contentsOf: recorder.url) {
            let base64Encoded = data.base64EncodedString()
            bridge?.triggerWindowJSEvent(eventName: "audioData", data: ["data": base64Encoded])
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        bridge?.triggerWindowJSEvent(eventName: "audioError", data: ["error": "ENCODE_ERROR", "message": error?.localizedDescription ?? "Unknown error"])
    }
}
