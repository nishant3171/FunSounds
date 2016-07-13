//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Nishant Punia on 12/07/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordingViewController: UIViewController,AVAudioRecorderDelegate {
    
//  Mark: IBOutlets
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stopRecording.enabled = false
    }

    @IBAction func recordVoice(sender: UIButton) {
        recordingLabel.text = "Recording...."
        recordingButton.enabled = false
        stopRecording.enabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "RecordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.text = "Tap to Record!"
        stopRecording.enabled = false
        recordingButton.enabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Error in recording the audio file.")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            
            let playRecordingVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudio = sender as! NSURL
            playRecordingVC.audioRecordingUrl = recordedAudio
            
        }
    }
}

