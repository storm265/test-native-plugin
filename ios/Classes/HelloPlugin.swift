import Flutter
import UIKit
import AVFoundation


public class HelloPlugin: NSObject, FlutterPlugin {
    
    var videoRecorder = CameraRecorder()
    
    
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "hello", binaryMessenger: registrar.messenger())
    let instance = HelloPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
      
    
      
  }
   

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
      
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
        
    case "startRecording":
        videoRecorder.startRecording(result: result)

        
    case "stopRecording":
        videoRecorder.stopRecording(result: result)
     
    default:
      result(FlutterMethodNotImplemented)
    }
  }

}
class CameraRecorder: NSObject {
    private var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var outputURL: URL?
    private var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    override init() {
        super.init()
    }
    
    func startRecording(result: @escaping FlutterResult) {
        // Register background task to keep the app alive in the background
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            // If the background task expires, stop recording or handle any cleanup
            self.stopRecording(result: result)
        })
        
        // Setup session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        // Get back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: .back),
              let input = try? AVCaptureDeviceInput(device: backCamera),
              let captureSession = captureSession else {
            result(FlutterError(code: "CAMERA_ERROR", message: "Cannot access back camera", details: nil))
            return
        }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Setup video output
        videoOutput = AVCaptureMovieFileOutput()
        if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }
        
        // Start session
        captureSession.startRunning()
        
        // Start recording
        let tempDir = NSTemporaryDirectory()
        let filePath = tempDir + UUID().uuidString + ".mp4"
        outputURL = URL(fileURLWithPath: filePath)
        
        if let outputURL = outputURL {
            videoOutput?.startRecording(to: outputURL, recordingDelegate: self)
            result(nil)  // success
        } else {
            result(FlutterError(code: "RECORD_ERROR", message: "Failed to start recording", details: nil))
        }
    }
    
    func stopRecording(result: @escaping FlutterResult) {
        guard let videoOutput = videoOutput, videoOutput.isRecording else {
            result(FlutterError(code: "NOT_RECORDING", message: "Recording not started", details: nil))
            return
        }
        
        videoOutput.stopRecording()
        
        // End the background task when recording stops
        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskIdentifier.invalid
        }
        
        if let outputURL = outputURL {
            result(outputURL.absoluteString)
        } else {
            result(nil)
        }
    }
}


extension CameraRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
        } else {
            print("Recording saved to: \(outputFileURL)")
        }
    }
}
