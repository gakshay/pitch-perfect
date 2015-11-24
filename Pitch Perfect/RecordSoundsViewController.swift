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
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        stopButton.hidden = true
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        
        stopButton.hidden = false
        
        
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
        audioRecorder.record()
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
        recordingInProgress.hidden = true
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print("Error in stop recording function")
        }
    }
}

