//
//  ViewController.swift
//  Music
//
//  Created by Mac15 on 2023/5/18.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    let player = AVPlayer()
    var musics = [URL]()
    var count = 0
    var action = 1
    @IBOutlet weak var songLength: UILabel!
    @IBOutlet weak var songProgressSlider: UISlider!
    @IBOutlet weak var songVolumeSlider: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        songVolumeSlider.value = player.volume
        
        musics.append(Bundle.main.url(forResource: "Avid", withExtension: "mp3")!)
        musics.append(Bundle.main.url(forResource: "Promise", withExtension: "mp3")!)
        musics.append(Bundle.main.url(forResource: "You", withExtension: "mp3")!)
        
        let music = Bundle.main.url(forResource: "Avid", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: music)
        player.replaceCurrentItem(with: playerItem)
//        player.play()
        
        let duration = playerItem.asset.duration
        let seconds = CMTimeGetSeconds(duration)
        songLength.text = formatConversion(time:0)
        songProgressSlider.minimumValue = 0
        songProgressSlider.maximumValue = Float(seconds)
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: {(CMTime) in
            let currentTime = CMTimeGetSeconds(self.player.currentTime())
            self.songProgressSlider.value = Float(currentTime)
            self.songLength.text = self.formatConversion(time: currentTime)
        })
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidreachEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    @objc func playerItemDidreachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    @IBAction func previous(_ sender: UIButton) {
        count -= 1
        if count <= 0 {
            count = 0
        }
        let playerItem = AVPlayerItem(url: musics[count])
        player.replaceCurrentItem(with: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidreachEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        player.play()
    }
    @IBAction func next(_ sender: UIButton) {
        count += 1
        if count >= musics.count {
            count = 0
        }
        let playerItem = AVPlayerItem(url: musics[count])
        player.replaceCurrentItem(with: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidreachEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        player.play()
    }
    @IBAction func play(_ sender: UIButton) {
        if(action == 0){
            playButton.setTitle("Pause", for: .normal)
            player.play()
            action = 1
            
        } else {
            playButton.setTitle("Play", for: .normal)
            player.pause()
            action = 0
        }
    }
    
    @IBAction func musicVolume(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction func changeCurrentTime(_ sender: UISlider) {
        let seconds = Int64(songProgressSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: targetTime)
    }
    func formatConversion(time: Float64) -> String{
        let songLength = Int(time)
        let minutes = Int(songLength / 60)
        let seconds = Int(songLength % 60)
        
        var time = ""
        if minutes < 10 {
            time = "0\(minutes):"
        }else{
            time = "\(minutes):"
        }
        
        if seconds < 10 {
            time +=  "0\(seconds)"
        } else {
            time +=  "\(seconds)"
        }
        return time
    }
}

