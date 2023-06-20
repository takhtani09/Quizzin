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
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.username = txtName.text!
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    
}
