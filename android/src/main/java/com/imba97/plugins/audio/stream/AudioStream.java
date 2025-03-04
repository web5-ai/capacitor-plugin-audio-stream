package com.imba97.plugins.audio.stream;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.util.Base64;
import com.getcapacitor.Bridge;

public class AudioStream {
    private static final String TAG = "AudioStream";
    
    // 音频参数配置
    private static final int SAMPLE_RATE = 16000;
    private final static int WAVE_FRAM_SIZE = 20 * 2 * SAMPLE_RATE / 1000;
    private static final int CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO;
    private static final int AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
    
    // 录音相关对象
    private AudioRecord audioRecord;
    private boolean isRecording = false;
    private int bufferSize;
    private Thread recordingThread;
    
    // Capacitor 桥接
    private Bridge bridge;

    public void setBridge(Bridge bridge) {
        this.bridge = bridge;
    }

    public void startRecording() {
        // 初始化 AudioRecord
        audioRecord = new AudioRecord(
            MediaRecorder.AudioSource.DEFAULT,
            SAMPLE_RATE,
            CHANNEL_CONFIG,
            AUDIO_FORMAT,
            WAVE_FRAM_SIZE * 4
        );

        // 检查初始化状态
        if (audioRecord.getState() != AudioRecord.STATE_INITIALIZED) {
            throw new IllegalStateException("AudioRecord initialization failed");
        }

        // 开始录音
        audioRecord.startRecording();
        isRecording = true;

        // 创建录音线程
        recordingThread = new Thread(() -> {
            byte[] buffer = new byte[WAVE_FRAM_SIZE * 4];

            while (isRecording && !Thread.interrupted()) {
                int bytesRead = audioRecord.read(buffer, 0, buffer.length);

                if (bytesRead > 0) {
                    processAudioData(buffer, bytesRead);
                } else {
                    handleReadError(bytesRead);
                }
            }
        }, "AudioRecorder-Thread");

        recordingThread.start();
    }

    public void stopRecording() {
        if (audioRecord != null) {
            try {
                // 停止标志
                isRecording = false;

                // 停止并释放资源
                audioRecord.stop();
                audioRecord.release();
                audioRecord = null;

                // 等待线程结束
                if (recordingThread != null && recordingThread.isAlive()) {
                    recordingThread.join(500);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } finally {
                recordingThread = null;
            }
        }
    }

    private void processAudioData(byte[] buffer, int bytesRead) {
        try {
            String data = Base64.encodeToString(buffer, 0, bytesRead, Base64.NO_WRAP);
            if (bridge != null) {
                bridge.triggerWindowJSEvent("audioData", "{ \"data\": \"" + data + "\" }");
            }
        } catch (Exception e) {
            if (bridge != null) {
                bridge.triggerWindowJSEvent("audioError", 
                    "{ \"error\": \"DATA_PROCESS_ERROR\", " +
                    "\"message\": \"" + e.getMessage() + "\" }"
                );
            }
        }
    }

    private void handleReadError(int errorCode) {
        String errorMsg;
        switch (errorCode) {
            case AudioRecord.ERROR_INVALID_OPERATION:
                errorMsg = "ERROR_INVALID_OPERATION";
                break;
            case AudioRecord.ERROR_BAD_VALUE:
                errorMsg = "ERROR_BAD_VALUE";
                break;
            case AudioRecord.ERROR_DEAD_OBJECT:
                errorMsg = "ERROR_DEAD_OBJECT";
                break;
            default:
                errorMsg = "UNKNOWN_ERROR";
        }
        
        if (bridge != null) {
            bridge.triggerWindowJSEvent("audioError", "{ \"error\": \"" + errorMsg + "\" }");
        }
    }

    // 获取当前录音状态
    public boolean isRecording() {
        return isRecording;
    }
}
