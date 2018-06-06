//
//  RecordSoundViewController.swift
//  Pitch-Perfect
//
//  Created by Sean Conrad on 4/22/18.
//  Copyright © 2018 Sean Conrad. All rights reserved.
//

import UIKit
import AVFoundation
// a Class can only inherit from one superclass, but it can conform to as many other protocols as you want
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var startStopRecordingButton: UIButton!
    
    let startRecordImage = UIImage(named: "Record")
    let stopRecordingImage = UIImage(named: "Stop")
    
    let startRecordingString = "Tap to Begin Recording"
    let stopRecordingString = "Tap to Stop Recording"
    
    var observation: NSKeyValueObservation?
    
    var audioRecorder: AVAudioRecorder!
    
    enum recordButtonState: Int {
        case record = 0, stop
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startStopRecordingButton.imageView?.image = startRecordImage
        recordLabel.text = startRecordingString
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startStopButton(_ sender: UIButton){
        if recordButtonState(rawValue: sender.tag)! == .record {
            startAudioRecording()
            sender.tag = 1
        } else {
            stopAudioRecording()
            sender.tag = 0
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 155, height: 155))
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 155, height: 155)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func startAudioRecording() {
        recordLabel.text = stopRecordingString
        startStopRecordingButton.setImage(resizeImage(image: stopRecordingImage!, newWidth: 150), for: .normal)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func showAlert(){
        let ac = UIAlertController(title: "Recording unsuccesful", message: "Please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func stopAudioRecording() {
        recordLabel.text = startRecordingString
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        startStopRecordingButton.setImage(startRecordImage, for: .normal)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
       
        if flag{
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else {
            showAlert()
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

