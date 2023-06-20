//
//  CompleteVC.swift
//  Quizzin
//
//  Created by IPS-108 on 14/06/23.
//

import UIKit
import AVFoundation
import CoreData

class CompleteVC: UIViewController {
    
    var score = Int() // The score achieved by the user in the quiz
    var usernmae = String()
    var greeting = String() // The greeting message based on the score
    let party = ConfettiView() // A view that displays confetti animation
    var playerCheerSound: AVAudioPlayer! // Audio player for the cheer sound effect
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var lblScore: UILabel! // Label to display the score and greeting message
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        

        navigationController?.isNavigationBarHidden = true // Hide the navigation bar
        playCheerSound() // Play the cheer sound effect
        party.startAnimating() // Start the confetti animation
        viewScore() // Update the score label with the score and greeting
        
        
    }
    
    func saveUserData() {
        
        var highScore = score
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: managedObjectContext) as! UserData
        
        if user.score > score{
            highScore = Int(user.score)
        }
        
        user.username = usernmae
        user.score = Int16(highScore)
        
        
        do {
            try managedObjectContext.save()
            print("Data save.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Play the cheer sound effect
    func playCheerSound(){
        let url = Bundle.main.url(forResource: "cheer", withExtension: "mp3")
        playerCheerSound = try! AVAudioPlayer(contentsOf: url!)
        playerCheerSound.play()
    }
    
    // Update the score label with the score and greeting
    func viewScore(){
        if score < 3 {
            greeting = "Better Luck Next Time"
        }
        else if score >= 3 && score < 5 {
            greeting = "Let's Try Again"
        }
        else if score >= 5 && score < 7 {
            greeting = "Well Played"
        }
        else {
            greeting = "Excellent!!"
        }
        lblScore.text = "\(greeting) \n Your Score is \(score)"
    }
    
    
    // Restart the quiz when the restart button is pressed
    @IBAction func btnRestart(_ sender: CustomButton) {
        playerCheerSound.stop() // Stop the cheer sound effect
        if let navigationController = presentingViewController as? UINavigationController,
           let viewController = navigationController.viewControllers.first as? ViewController {
            viewController.resetQuiz() // Reset the quiz in the main view controller
        }
        dismiss(animated: true, completion: nil) // Dismiss the complete view controller
    }

    // Return to the home screen when the home button is pressed
    @IBAction func btnHome(_ sender: CustomButton) {
        saveUserData()
        playerCheerSound.stop() // Stop the cheer sound effect
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil) // Dismiss all view controllers and return to the root view controller (home screen)
        NotificationCenter.default.post(name: NSNotification.Name("ReloadTable"), object: nil)

       
    }
}
