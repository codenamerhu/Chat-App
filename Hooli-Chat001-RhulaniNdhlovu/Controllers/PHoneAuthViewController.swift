//
//  PHoneAuthViewController.swift
//  Hooli-Chat001-RhulaniNdhlovu
//
//  Created by Rhulani Ndhlovu on 2020/12/03.
//  Copyright © 2020 Rhulani Ndhlovu. All rights reserved.
//


import UIKit
import FirebaseAuth

class PhoneAuthViewController: UIViewController{

    
    //MARK:- Outlets
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var bgview: UIView!
    
    //MARK:- Variables
    var countryName : String = "South Africa"
    var countryCode : String = "27"
    var phoneNumber : String?
    
    override func viewDidLoad() {
        

        initialUISetup()
        phoneTextField.becomeFirstResponder()
        super.viewDidLoad()
 


        // Do any additional setup after loading the view.
    }
    
    func initialUISetup(){
        //Large Title Setup
        self.title = "Confirm your 10 digit number"
        
        //Background setup
        bgview.layer.borderColor = UIColor.init(r: 193, g: 193, b: 193).cgColor
        bgview.layer.borderWidth = 0.5
        
        //PhoneTextField UI Setup
        addIndent(phoneTextField)
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 0, width: 0.5,height: 42)
        border.backgroundColor=UIColor.init(r: 193, g: 193, b: 193).cgColor
        phoneTextField.layer.addSublayer(border)
        //Done Button
        doneButton.isEnabled = false
    }
    
    
    

    @IBAction func change(_ sender: UITextField) {
        //MARK:- Adding space after 5 digits ( visual purposes only )
               print("test")
               if let text = sender.text{
                   if text.count > 0 && text.count % 6 == 0 && text.last! != " " {
                           sender.text!.insert(" ", at:text.index(text.startIndex, offsetBy: text.count-1) )
                        }
                       self.title = "+" + self.countryCode + " " + self.phoneTextField.text!
                        
                        if text.count == 11{
                            doneButton.isEnabled = true
                            phoneNumber = self.title?.replacingOccurrences(of: " ", with: "")
                        }else{
                            doneButton.isEnabled = false
                        }
                   }
    }

    
    
    @IBAction func doneClicked(_ sender: Any) {
        //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        //phoneTextField.text
        phoneNumber = phoneTextField.text
        AuthAlert(title: "\(phoneNumber!)", message: "Please Confirm your number")
        //processFurther()
    }
    
    func processFurther(){
        print("process")
        print(phoneTextField.text)
        print(phoneNumber)
        if let number = self.phoneNumber {
            print(number)
        PhoneAuthProvider.provider().verifyPhoneNumber("+27\(number)", uiDelegate: nil) { (id, error) in
                   if error != nil{
                    self.ErrorAlert(title: "Error", message: "\(error!.localizedDescription): error verifying number, please make sure its your 10 digit SA number")
                    print(error?.localizedDescription ?? "error verifying number")
                   }
                   else{
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "OTPViewController") as OTPViewController
                    vc.id = id
                    vc.phone = number
                    self.navigationController?.pushViewController(vc, animated: true)
                   }
               }
        }
    }
    
    func AuthAlert(title:String,message:String){
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .default) { (UIAlertAction) in
            self.processFurther()
        }
        let cancelAction = UIAlertAction(title: "Edit", style: .cancel, handler: nil)
        
        Alert.addAction(cancelAction)
        Alert.addAction(action)
        
        self.present(Alert, animated: true)
    }
    
    func ErrorAlert(title:String,message:String){
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Edit", style: .cancel, handler: nil)
        
        Alert.addAction(cancelAction)
        
        self.present(Alert, animated: true)
    }
}


///TODO:- Replace TableView by a single button

//MARK:- PhoneAuthVC TableView Delegate methods
extension PhoneAuthViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "countrycell")
            cell?.textLabel?.text = self.countryName
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "countries") as countriesViewController
        vc.mainViewController = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42.8
    }
}

