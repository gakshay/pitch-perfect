//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by gakshay on 10/27/15.
//  Copyright © 2015 gakshay. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordingInProgress.text = "Tap to Record"
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "Recording in progress..."
        
        stopButton.hidden = false
        pauseButton.hidden = false
        
        prepareAudioRecorder()
        audioRecorder.record()
    }
    
    func prepareAudioRecorder() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            print("Unable to set category for AVAudioSession")
        }
        
        
        // initialize and prepare the audiorecorder
        audioRecorder = try? AVAudioRecorder.init(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio.init(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    

    @IBAction func stopRecording(sender: UIButton) {
        print("stop recording")
        //recordingInProgress.hidden = true
        recordingInProgress.text = "Recorded"
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print("Error in stop recording function")
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        print("pause recording")
        audioRecorder.pause()

        recordingInProgress.text = "Recording paused.."
        pauseButton.hidden = true
        resumeButton.hidden = false
        
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        print("resume recording")
        recordingInProgress.text = "Recording resumed.."
        audioRecorder.record()
        resumeButton.hidden = true
        pauseButton.hidden = false
    }
    
    
}

