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
    
    var audioRecorder: AVAudioRecorder!


    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButtonLabel.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
    }


    @IBAction func recordButton(_ sender: UIButton) {
        tapToRecordLabel.text = "Recording in Progress..."
        stopRecordingButtonLabel.isEnabled = true
        recordingButton.isEnabled = false
        
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
        recordingButton.isEnabled = true
        stopRecordingButtonLabel.isEnabled = false
        tapToRecordLabel.text = "Tap!"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
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
    
    
    
    
}

