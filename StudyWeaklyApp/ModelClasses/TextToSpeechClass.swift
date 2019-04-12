//
//  TextToSpeechClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 9/20/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


enum Language: String {
    case english = "en-US"
    case arabic = "ar-SA"
}
class TextToSpeechClass: NSObject{
    
   let speechSynthesizer = AVSpeechSynthesizer()
//    class var shareTextToSpeechClass: TextToSpeechClass {
//        struct Static {
//            static let instance = TextToSpeechClass()
//        }
//        return Static.instance
//    }
    
    
    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }
    func startSpeechMethod(getWord:String){
        let Language:String = "en-US"
       // prepareAudioSession()
        let speechUtterance = AVSpeechUtterance(string: getWord)
        speechUtterance.rate = 0.5
        speechUtterance.pitchMultiplier = 0.15
        //speechUtterance.volume = 0.99
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }
    
    private func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
        } catch {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
   func pauseSpeechMethod(){
        
      speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
    }

    
  func stopSpeechMethod(){
    
    speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
    }

}
    extension TextToSpeechClass: AVSpeechSynthesizerDelegate {
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
            print("Speaker class started")
      
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
            print("Speaker class finished")
        }
        
        func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
            
             print("Speaker class range ==")
            
        }
        
    
}
