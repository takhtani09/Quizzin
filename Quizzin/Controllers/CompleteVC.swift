//
//  CompleteVC.swift
//  Quizzin
//
//  Created by IPS-108 on 14/06/23.
//

import UIKit
import AVFoundation

class CompleteVC: UIViewController {
    
    var score = Int() // The score achieved by the user in the quiz
    var greeting = String() // The greeting message based on the score
    let party = ConfettiView() // A view that displays confetti animation
    var playerCheerSound: AVAudioPlayer! // Audio player for the cheer sound effect
    
    @IBOutlet weak var lblScore: UILabel! // Label to display the score and greeting message
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true // Hide the navigation bar
        playCheerSound() // Play the cheer sound effect
        party.startAnimating() // Start the confetti animation
        viewScore() // Update the score label with the score and greeting
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
        playerCheerSound.stop() // Stop the cheer sound effect
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil) // Dismiss all view controllers and return to the root view controller (home screen)
    }
}
