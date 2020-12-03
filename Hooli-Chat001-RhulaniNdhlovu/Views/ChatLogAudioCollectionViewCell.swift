//
//  ChatLogAudioCollectionViewCell.swift
//  Hooli-Chat001-RhulaniNdhlovu
//
//  Created by Rhulani Ndhlovu on 2020/12/03.
//  Copyright © 2020 Rhulani Ndhlovu. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase

class ChatLogAudioCollectionViewCell: UICollectionViewCell {
    
        
    /// - This cell if for Audio Messages

    //MARK:- Outlets
    @IBOutlet var bubbleLeftAnchor: NSLayoutConstraint!
    @IBOutlet var bubbleRightAnchor: NSLayoutConstraint!
    @IBOutlet var bubbleWidthAnchor: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var chatBubble: UIView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var silder: UISlider!
    
    @IBOutlet var timeLabel: UILabel!
    
    //MARK:- Variables
    var message : Message?
    
    var user : User?
    
   //audioPlayer
   var recordingSession : AVAudioSession!
   var audioRecorder : AVAudioRecorder!
   var audioPlayer : AVAudioPlayer!
    
   var displayLink = CADisplayLink()
    
    // D
    
    
    }

