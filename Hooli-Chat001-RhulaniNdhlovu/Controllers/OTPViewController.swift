//
//  OTPViewController.swift
//  Hooli-Chat001-RhulaniNdhlovu
//
//  Created by Rhulani Ndhlovu on 2020/12/03.
//  Copyright © 2020 Rhulani Ndhlovu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OTPViewController: UIViewController {

    //Variables
    var id : String?
    var phone : String?
    var users = [String]()
    
    //OUTlets
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var otpLabel: UILabel!
    
    
    ///TODO:- make user checking more efficient
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        //Brings up permanent keyboard
        self.otpTextField.becomeFirstResponder()
        
        //removes textfield cursor
        otpTextField.tintColor = .clear
        
        //Check for user
        let ref = Database.database().reference().child("users")
        ref.observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            self.users.append(snapshot.key)
        }, withCancel: nil)
    }
    
    
    //MARK:- OTP TextField UI Setup
    @IBAction func otp(_ sender: UITextField) {
        print("change")
        var last = ""
        if let text = sender.text {
            let count = text.count
                if count > 0{
                    let label : UILabel = self.view.viewWithTag(count) as! UILabel
                    last = String(text.suffix(1))
                    label.text = last
                    if count < 6 {
                    for i in count+1...6{
                        let label : UILabel = self.view.viewWithTag(i) as! UILabel
                        label.text = "﹣"
                    }
                    }
                }else{
                    let label : UILabel = self.view.viewWithTag(1) as! UILabel
                    label.text = "﹣"
            }
        }
        
        //MARK:- Initiate Sign in as soon as textfield full
        if sender.text?.count == 6{
            otpTextField.isEnabled = false
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: id!, verificationCode: otpTextField.text!)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil{
                    
                    self.ErrorAlert(title: "Error", message: "\(error!.localizedDescription)")
                    print(error?.localizedDescription ?? "Phone Authentication error")
                    self.otpTextField.isEnabled = true
                    self.otpTextField.text = nil
                    self.resetLabels()
                    self.otpTextField.becomeFirstResponder()
                }
                else{
                    UserDefaults.standard.setValue(true, forKey: "login")
                    if let uid = result?.user.uid{
                    let existingUser = self.checkExistingUser(uid)
                    print("existing user",existingUser)
                    existingUser ? self.goToViewController() : self.segue()
                    }
                }
            }
        }
    }
    
    
    //MARK:- Segue for New Users
    func segue(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SetupProfileViewController") as SetupProfileViewController
        vc.phone = self.phone
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Segue for existing Users
    func goToViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tabbar")
        self.present(controller, animated: true, completion: nil)
        }
    
    //function name is enough desxription
    func checkExistingUser(_ uid : String) -> Bool{
        if users.contains(uid) {
             return true
        }
        return false
    }
    
    //Reset TextField after wrong OTP or networking error
    func resetLabels(){
        for i in 1...6{
            let label : UILabel = self.view.viewWithTag(i) as! UILabel
            label.text = "﹣"
        }
    }
    
        //MARK:- Segue for going back to login
    func goToLoginController(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
    }
    
            //MARK:- Error Alert
    func ErrorAlert(title:String,message:String){
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Re-enter pin", style: .cancel, handler: nil)
        
        let action = UIAlertAction(title: "Change number", style: .default) { (UIAlertAction) in
            self.goToLoginController()
        }
        
        
        Alert.addAction(cancelAction)
        Alert.addAction(action)
        
        self.present(Alert, animated: true)
    }
}
