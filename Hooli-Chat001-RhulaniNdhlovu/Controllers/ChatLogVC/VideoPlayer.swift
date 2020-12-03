//
//  VideoPlayer.swift
//  Hooli-Chat001-RhulaniNdhlovu
//
//  Created by SBI Admin on 2020/06/19.
//  Copyright © 2020 Rhulani Ndhlovu. All rights reserved.
//

import Foundation
import AVFoundation

extension ChatLogViewController {
    //MARK:- Play Video
    func handlePlay(message: Message?){
            if let videoUrl = message?.videoUrl, let url = URL(string: videoUrl){
              player = AVPlayer(url: url)
                playerLayer = AVPlayerLayer(player: player)
              playerLayer!.frame = view.bounds
                  view.layer.addSublayer(playerLayer!)
              player!.play()
                print("playing")
            }
        }
}
