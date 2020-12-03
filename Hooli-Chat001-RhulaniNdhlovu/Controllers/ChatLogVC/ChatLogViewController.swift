//
//  ChatLogViewController.swift
//  Hooli-Chat001-RhulaniNdhlovu
//
//  Created by SBI Admin on 2020/06/18.
//  Copyright © 2020 Rhulani Ndhlovu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import AVFoundation

class ChatLogViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet var textfieldRightConstraint: NSLayoutConstraint!
    @IBOutlet var keyboardBottomAnchot: NSLayoutConstraint!
    @IBOutlet var keyBoardView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var tempView: UIView!
    
    
    
      //MARK:- Variables
    
      //ImageView
      var startingImageFrame : CGRect?
      var backgroundView : UIView?
      var startingImageView : UIImageView?
      
      //VideoPlayer
      var playerLayer : AVPlayerLayer?
      var player : AVPlayer?
    
      //audioPlayer
    /*------------------------------------------
      var recordingSession : AVAudioSession!
      var audioRecorder : AVAudioRecorder!
      var audioPlayer : AVAudioPlayer!
     ------------------------------------------*/
    
      //Timer
      var timer: Timer?
      var duration: CGFloat = 0
      
    
      var messages = [Message]()

      var user : User? {
            didSet{
                setNavBarTitle(user: user!)
                observeMessages()
            }
        }
    
    //TitleBar UI
    let profileImageView = UIImageView()
    

    //MARK:- Activity Indicator
    var activityIndicatorView : UIActivityIndicatorView{
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.translatesAutoresizingMaskIntoConstraints = true
        aiv.hidesWhenStopped = true
        aiv.startAnimating()
        return aiv
    }
    
    private func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


        

    //MARK:- ViewDidLoad + InitialSetup
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        plusButton.isHidden = true
        chatTextField.delegate = self
        chatTextField.addTarget(nil, action:Selector(("firstResponderAction:")), for:.editingDidEndOnExit)
    }
    
    func initialSetup(){
        
        //Title
        self.navigationItem.largeTitleDisplayMode = .never
        
        //keyboard dissmiss mode
        collectionView.keyboardDismissMode = .interactive

        //Button
        self.sendButton.isHidden = true
        
        //TextField
        addIndent(chatTextField)
        chatTextField.delegate = self
        chatTextField.layer.borderColor = UIColor(named: "border")?.cgColor
        chatTextField.layer.borderWidth = 0.5
        chatTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        //Collectionview
        collectionView.alwaysBounceVertical=true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 7, right: 0)
        
        //setup recording ui
        tempView.isHidden = true
        
        //setting up recording session
        // ------------------------------------------------------
        //recordingSession = AVAudioSession.sharedInstance()
        // ------------------------------------------------------
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission{ print("mic permission granted") }
        }
        
        //setting keyboard observer
        NotificationCenter.default.addObserver(self,
              selector: #selector(self.keyboardNotification(notification:)),
              name: UIResponder.keyboardWillChangeFrameNotification,
              object: nil)
        
    }

        //MARK:- Button Action Outlets
        @IBAction func plusClicked(_ sender: Any) {
            self.createPLusActionSheet()
        }
        
        
        @IBAction func cameraClicked(_ sender: Any) {
            self.cameraTapped()
        }
    
    
    @IBAction func sendClicked(_ sender: Any) {
           sendData()
        self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
        }
    
    
        //MARK:- Chat TextField fucntions
        @objc func textFieldDidChange(_ textField: UITextField) {
            if sendButton.isHidden {
                self.textfieldRightConstraint.priority = UILayoutPriority(rawValue: 900)
                self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseOut, x: 50, bool: false)
            }
            if chatTextField.text == ""{
                self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
            }
        }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            sendData()
            self.curveAnimation(button: self.cameraButton, animationOptions: .curveEaseIn, x: 0, bool: true)
            return true
        }

        func animateViewMoving (up:Bool, moveValue :CGFloat){
            let movementDuration:TimeInterval = 0.3
            let movement:CGFloat = ( up ? -moveValue : moveValue)

            UIView.beginAnimations("animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)

            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
        }
    
    @IBAction func chatEditBegin(_ sender: UITextField) {
        print("test")
        
            animateViewMoving(up: true, moveValue: 30)
        
    }
    @IBAction func chatEditEnd(_ sender: UITextField) {
        animateViewMoving(up: false, moveValue: 30)
    }
}



