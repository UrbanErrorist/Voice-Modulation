//
//  RecordSoundsViewController.swift
//  Pitch Perfact
//
//  Created by Rishabh Goswami 
//  Copyright ©  Rishabh Goswami. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioPlayerDelegate ,AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var session: AVAudioSession!
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: Record Button Action
    
    @IBAction func Record(_ sender: Any) {
        stopButton.isEnabled = true
        recordButton.isEnabled = false
        recordLabel.text = "Recording ..."
        
        audioSetup()
        }
    
     // MARK: Stop Button Action
    
    @IBAction func stop(_ sender: Any) {
        recordButton.isEnabled = true
        recordLabel.text = "Tap To Record"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK:  Setting Up The Audio
    
    func audioSetup(){
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    
   
    // MARK:  After Finishing The Recording <Inside the Delegate Class>
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "play", sender: audioRecorder.url)
            
        }
        else{
            print("Error is here")
        }
    }
    
    
    // MARK:  Performing Data Transfer Between ViewControllers via Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "play"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            
        let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }
    
     // MARK:  ViewWillAppear()
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        stopButton.isEnabled = false
    }

    // MARK:  ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopButton.isEnabled = false
        
    }
}

