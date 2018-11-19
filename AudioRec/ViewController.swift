//
//  ViewController.swift
//  AudioRec
//
//  Created by Hend Khaled on 11/19/18.
//  Copyright © 2018 Hend Khaled. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var numberOfRecords = 0
    
    var player: AVAudioPlayer!

    @IBOutlet weak var buttonLabel: UIButton!
    
    
    @IBAction func record(_ sender: Any) {
        
        //Check if we have an active recorder
        if audioRecorder == nil {
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            print(filename)
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000 , AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            //Start audio recording
            do {
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                buttonLabel.setTitle("Stop Recording", for: .normal)
            } catch {
                displayAlert(title: "Ops!", message: "Recording failed")
            }
        } else {
            //Stopping audio recording
            audioRecorder.stop()
            audioRecorder = nil
            
            buttonLabel.setTitle("Start Recording", for: .normal)
        }
    }
    
    //Play audio after Stopping recording.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("finished")
            print(recorder.url)
            let audioData = NSData(contentsOf: recorder.url)
            if (audioData) != nil {
                // do something useful
                do {
                    player = try AVAudioPlayer(contentsOf: recorder.url)
                    player.prepareToPlay()
                    player.play()
                } catch let error as NSError {
                    print(error.description)
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("ACCEPTED !")
            }
        }
    }

    //Function that gets path to directory
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //Function that displays an alert
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


}

