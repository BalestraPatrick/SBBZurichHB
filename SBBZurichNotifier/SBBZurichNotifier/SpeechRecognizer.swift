//
//  SpeechRecognizer.swift
//  SBBZurichNotifier
//
//  Created by Patrick Balestra on 9/17/16.
//  Copyright © 2016 Patrick Balestra. All rights reserved.
//

import AVFoundation
import Speech

class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate {
    
    internal let textEvent = Event<(String?, Bool)>()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override init() {
        super.init()
        
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {
            case .authorized:
                print("Now authorized")
            case .denied:
                print("User denied access to speech recognition")
            case .restricted:
                print("Speech recognition restricted on this device")
            case .notDetermined:
                print("Speech recognition not yet authorized")
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            
            var isFinal = false
            
            if result != nil {
                isFinal = (result?.isFinal)!
                self.textEvent.raise(data: (result?.bestTranscription.formattedString, isFinal))
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.textEvent.raise(data: (result?.bestTranscription.formattedString, isFinal))
                
                self.recognitionRequest = nil
                self.recognitionTask = nil                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
}
