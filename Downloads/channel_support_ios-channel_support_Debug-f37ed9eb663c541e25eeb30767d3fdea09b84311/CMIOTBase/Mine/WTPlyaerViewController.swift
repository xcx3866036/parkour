//
//  WTPlyaerViewController.swift
//  VideoPlayerDemo
//
//  Created by 廖文韬 on 2018/8/3.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import AVKit

class WTPlyaerViewController: UIViewController {
    var videoUrl:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "AVPlayerViewController"
        let player = AVPlayer(url: NSURL(string: (CHVideoUrl + videoUrl))! as URL)
        player.play()
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        //添加view播放的模式
        playerViewController.view.frame = view.frame
        self.addChildViewController(playerViewController)
        self.view.addSubview(playerViewController.view)
    }
}
