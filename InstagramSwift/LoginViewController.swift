//
//  ViewController.swift
//  InstagramSwift
//
//  Created by Max Lettenberger on 6/9/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    //var signupActive = true

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!


    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func LogIn(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("Error in form", message: "Please enter a username and password")
        } else {
            login()
        }
    }


    @IBAction func signUp(sender: AnyObject) {

       signUpFunc()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func login() {

        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        var errorMessage = "Please try again later"

            PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (user, error) -> Void in
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if user != nil {
                    println("user logged in")
                    self.performSegueWithIdentifier("ToMainApp", sender: self)
                } else {
                    if let errorString = error!.userInfo?["error"] as? String {
                        errorMessage = errorString
                    }
                    self.displayAlert("Failed Login", message: errorMessage)
                }
            })

    }

    func signUpFunc(){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        var errorMessage = "Please try again later"

        var user = PFUser()
        user.username = username.text
        user.password = password.text

        user.signUpInBackgroundWithBlock({ (success, error) -> Void in

            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()

            if error == nil {
                println("successful signup/login")
                self.performSegueWithIdentifier("ToMainApp", sender: self)
            } else {
                if let errorString = error!.userInfo?["error"] as? String {
                    errorMessage = errorString
                }
                self.displayAlert("Failed SignUp", message: errorMessage)
            }
        })
    }
}

