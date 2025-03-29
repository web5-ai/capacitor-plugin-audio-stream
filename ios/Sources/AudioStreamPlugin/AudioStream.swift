import AVFoundation
import Capacitor

class AudioStream: NSObject {
    private let sampleRate: Double = 44100
    private let channelCount: AVAudioChannelCount = 1
    private var audioRecorder: AVAudioRecorder?
    private var isRecording = false
    private var plugin: CAPPlugin?

    func setPlugin(plugin: CAPPlugin) {
        self.plugin = plugin
    }

    func startRecording() throws {
        // 配置 AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try audioSession.setActive(true)
        try audioSession.setPreferredSampleRate(sampleRate)

        // 更新录音设置
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
        try? FileManager.default.removeItem(at: url) // 删除已有文件
        
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

        // 停止 AVAudioSession
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    func getRecordingStatus() -> Bool {
        return isRecording
    }
}

extension AudioStream: AVAudioRecorderDelegate {
    // 修改后的代理方法名称
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag else { return }
        if let data = try? Data(contentsOf: recorder.url) {
            let base64Encoded = data.base64EncodedString()
            // 确保在主线程中调用通知
            DispatchQueue.main.async {
                self.plugin?.notifyListeners("audioData", data: ["data": base64Encoded])
            }
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        DispatchQueue.main.async {
            self.plugin?.notifyListeners("audioError", data: [
                "error": "ENCODE_ERROR", 
                "message": error?.localizedDescription ?? "Unknown error"
            ])
        }
    }
}
