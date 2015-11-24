//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by gakshay on 10/29/15.
//  Copyright © 2015 gakshay. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "wav"){
//            let filePathUrl = NSURL.fileURLWithPath(filePath)
//            audioPlayer = try? AVAudioPlayer(contentsOfURL: filePathUrl)
//            audioPlayer.enableRate = true
//        }else{
//            print("The file is not present")
//        }
        
        audioPlayer = try? AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: recievedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    @IBAction func slowPlayAudio(sender: UIButton){
        playAudio(0.5)
    }

    @IBAction func fastPlayAudio(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudio(rate: Float) {
        resetPlayback()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func resetPlayback() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    func playAudioWithVariablePitch(pitch: Float) {
        resetPlayback()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            print("Couldn't start the Audio Engine")
        }
        
        audioPlayerNode.play()
        
    }
    
}
