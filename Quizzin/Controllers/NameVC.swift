//
//  NameVC.swift
//  Quizzin
//
//  Created by IPS-108 on 20/06/23.
//

import UIKit
import CoreData

class NameVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the navigation bar
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func btnEnter(_ sender: CustomButton) {
        guard let username = txtName.text, !username.isEmpty else {
            // Display an alert or show an error message indicating that the text field is empty
            showAlert(with: "Empty Field", message: "Please enter your name.")
            return
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.username = username
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: false, completion: nil)
    }
    
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
