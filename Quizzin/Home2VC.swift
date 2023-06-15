//
//  Home2VC.swift
//  Quizzin
//
//  Created by IPS-108 on 15/06/23.
//

import UIKit

class Home2VC: UIViewController {

    @IBOutlet weak var lblName: UITextField!
    let userDefaults = UserDefaults.standard
    let key = "userData"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnStart(_ sender: CustomButton) {
        if let username = lblName.text, !username.isEmpty {
            // Retrieve the existing user data from UserDefaults
            var userData = userDefaults.array(forKey: key) as? [[String: Any]] ?? []
            
            // Check if the username already exists in the user data
            if userData.contains(where: { $0["username"] as? String == username }) {
                print("User is already registered with the username: \(username)")
            } else {
                // Create a new dictionary with the username and an initial score of 0
                let newUser: [String: Any] = ["username": username, "score": 0]
                
                // Add the new user to the user data
                userData.append(newUser)
                
                // Save the updated user data back to UserDefaults
                userDefaults.set(userData, forKey: key)
                
                print("Username and score saved successfully: \(username), \(newUser["score"] ?? 0)")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalPresentationStyle = .overCurrentContext
                self.present(navigationController, animated: false, completion: nil)
            }
        } else {
            // Handle the case when the username is empty
            print("Please enter a valid username.")
        }
    }
}
