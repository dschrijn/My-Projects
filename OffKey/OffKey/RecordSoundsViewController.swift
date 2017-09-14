//
//  RecordSoundsViewController.swift
//  OffKey
//
//  Created by David A. Schrijn on 9/8/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Mark: Variables
    
    var audioRecorder: AVAudioRecorder!
    
    // Mark: IBOutlet
    
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButtonLabel: UIButton!
    
    // Mark: App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(isRecording: false)
        
    }
    
    // Mark: Functions
    
    
    func configureUI(isRecording record: Bool) {
        
        
        if record == true {
            tapToRecordLabel.text = "Recording in Progress..."
            recordingButton.isEnabled = false
            stopRecordingButtonLabel.isEnabled = true
        } else if record == false {
            tapToRecordLabel.text = "Tap!"
            recordingButton.isEnabled = true
            stopRecordingButtonLabel.isEnabled = false
        } else {
            tapToRecordLabel.text = "Tap!"
            recordingButton.isEnabled = true
            stopRecordingButtonLabel.isEnabled = false
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Recording done!")
        //Uses the segue to send(sender) the path of the file where it is located.
        if flag {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else {
            print("Segue failed!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // Mark: IBActions
    
    @IBAction func recordButton(_ sender: UIButton) {
        
        configureUI(isRecording: true)
        // Sets directory to save the array
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //Filename is the recording
        let recordingName = "recordedVoice.wav"
        //Line 41 & 42 Combines the path and filename that creates a full path to the file.
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        //Setting up audio session (need to do this to record or playback audio
        let session = AVAudioSession.sharedInstance() //Need shared as all audio sessions apps use this.
        //Sets up for playing and recording audio
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        //Sets AVAudioRecorder
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecordingButton(_ sender: UIButton) {
        
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}

