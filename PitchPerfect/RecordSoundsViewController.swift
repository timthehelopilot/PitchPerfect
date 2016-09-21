//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Timothy Barrett on 9/19/16.
//  Copyright © 2016 Timothy Barrett. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stopRecordingButton.isHidden = true
        
    }
    
    func buttonActions(button: Bool) {
        if button {
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.isHidden = false
            recordButton.isEnabled = false
        } else {
            recordingLabel.text = "Tap to Record"
            stopRecordingButton.isHidden = true
            recordButton.isEnabled = true
            
        }
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        buttonActions(button: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "recordingVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        buttonActions(button: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC = segue.destination as!
            PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}

