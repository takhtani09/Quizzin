//
//  ViewController.swift
//  Quizzin
//
//  Created by IPS-108 on 13/06/23.
//


import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {
    
    // Audio players for sound effects
    var playerWrongAnswerSound: AVAudioPlayer!
    var playerWarningSound: AVAudioPlayer!
    
    // Array to store the question bank
    var questionBank: [QuestionBank] = []
    
    // Array to store shuffled question indexes
    var questionIndexes: [Int] = []
    
    // Index of the current question
    var currentQuestionIndex = 0
    
    // Player's score
    var score = 0
    
    // Countdown timer variables
    var counter = 31
    var timer: Timer?
    
    // Button colors
    let btnCorrectColor = #colorLiteral(red: 0.2325767686, green: 0.9803921569, blue: 0.1365186495, alpha: 1)
    let bntDefaultColor = #colorLiteral(red: 0.2669798643, green: 0.9214526415, blue: 0.7862983153, alpha: 1)
    
    // Outlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    
    // API call instance
    let apiCall = ApiCall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize the option buttons' labels to fit the content
        resizeButtons()
        
        // Hide the navigation bar
        navigationController?.isNavigationBarHidden = true
        
        // Check internet connectivity
        if NetworkReachabilityManager()?.isReachable ?? false {
            // Make an API call to fetch the question bank
            apiCall.api { [weak self] questionBank in
                self?.questionBank = questionBank
                self?.initializeQuestionIndexes()
            }
        } else {
            showInternetUnavailablePopup()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Invalidate the timer when the view is about to disappear
        timer?.invalidate()
    }
    
    func showInternetUnavailablePopup() {
        let alertController = UIAlertController(title: "Internet Unavailable", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Resize the option buttons' labels to fit the content
    func resizeButtons(){
        option1.titleLabel?.lineBreakMode = .byTruncatingTail
        option1.titleLabel?.adjustsFontSizeToFitWidth = true
        option1.titleLabel?.minimumScaleFactor = 0.3
        
        option2.titleLabel?.lineBreakMode = .byTruncatingTail
        option2.titleLabel?.adjustsFontSizeToFitWidth = true
        option2.titleLabel?.minimumScaleFactor = 0.3
        
        option3.titleLabel?.lineBreakMode = .byTruncatingTail
        option3.titleLabel?.adjustsFontSizeToFitWidth = true
        option3.titleLabel?.minimumScaleFactor = 0.3
        
        option4.titleLabel?.lineBreakMode = .byTruncatingTail
        option4.titleLabel?.adjustsFontSizeToFitWidth = true
        option4.titleLabel?.minimumScaleFactor = 0.3
    }
    
    // Update the countdown timer label and handle timer events
    @objc func updateCounter() {
        if counter > 0 {
            DispatchQueue.main.async {
                self.lblTimer.text = "0:\(self.counter)"
            }
            
            counter -= 1
            
            // Play warning sound when timer reaches 10 seconds or 5 seconds
            if counter == 10 {
                warningSound()
            } else if counter == 5 {
                warningSound()
            }
        }
        else {
            // Timer has reached 0, handle the end of the question
            timer?.invalidate()
            disableAllButtons()
            
            let currentQuestion = questionBank[questionIndexes[currentQuestionIndex - 1]]
            let correctAnswer = currentQuestion.answer
            
            // Highlight the correct answer
            if let correctAnswerIndex = currentQuestion.options.firstIndex(of: correctAnswer) {
                switch correctAnswerIndex {
                case 0:
                    option1.backgroundColor = btnCorrectColor
                case 1:
                    option2.backgroundColor = btnCorrectColor
                case 2:
                    option3.backgroundColor = btnCorrectColor
                case 3:
                    option4.backgroundColor = btnCorrectColor
                default:
                    break
                }
            }
            
            // Show the next question after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.resetButtonColors()
                self.showNextQuestion()
            }
        }
    }
    
    // Play the wrong answer sound effect
    func wrongAnswerSound(){
        let url = Bundle.main.url(forResource: "wrongAnswer", withExtension: "mp3")
        playerWrongAnswerSound = try! AVAudioPlayer(contentsOf: url!)
        playerWrongAnswerSound.play()
    }
    
    // Play the warning sound effect
    func warningSound(){
        let url = Bundle.main.url(forResource: "warningSound", withExtension: "mp3")
        playerWarningSound = try! AVAudioPlayer(contentsOf: url!)
        playerWarningSound.play()
    }
    
    // Initialize the question indexes by shuffling the question bank array
    func initializeQuestionIndexes() {
        questionIndexes = Array(0..<questionBank.count)
        questionIndexes.shuffle()
        showNextQuestion()
    }
    
    // Show the next question in the quiz
    func showNextQuestion() {
        counter = 31
        
        if currentQuestionIndex >= questionBank.count {
            // All questions have been answered, handle quiz completion
            
            timer?.invalidate()
            print("Completed all questions")
            print("Score: \(score)")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CompleteVC") as! CompleteVC
            vc.score = score
            
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalPresentationStyle = .overCurrentContext
            self.present(navigationController, animated: false, completion: nil)
            
            return
        }
        
        let currentQuestion = questionBank[questionIndexes[currentQuestionIndex]]
        
        // Update the UI with the current question's information
        DispatchQueue.main.async {
            self.questionCount.text = "\(self.currentQuestionIndex)/\(self.questionBank.count)"
            self.lblQuestion.text = currentQuestion.question
            self.option1.setTitle(currentQuestion.options[0], for: .normal)
            self.option2.setTitle(currentQuestion.options[1], for: .normal)
            self.option3.setTitle(currentQuestion.options[2], for: .normal)
            self.option4.setTitle(currentQuestion.options[3], for: .normal)
        }
        
        // Reset button colors and enable all buttons
        resetButtonColors()
        enableAllButtons()
        
        currentQuestionIndex += 1
        
        // Update the progress view
        let progress = Float(currentQuestionIndex) / Float(questionBank.count)
        DispatchQueue.main.async {
            self.progressView.progress = progress
        }
        
        // Start the timer for the next question
        timer?.invalidate()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
            self.updateCounter()
        }
    }
    
    // Reset button colors to the default color
    func resetButtonColors() {
        DispatchQueue.main.async {
            self.option1.backgroundColor = self.bntDefaultColor
            self.option2.backgroundColor = self.bntDefaultColor
            self.option3.backgroundColor = self.bntDefaultColor
            self.option4.backgroundColor = self.bntDefaultColor
        }
    }
    
    // Enable all option buttons
    func enableAllButtons() {
        DispatchQueue.main.async {
            self.option1.isEnabled = true
            self.option2.isEnabled = true
            self.option3.isEnabled = true
            self.option4.isEnabled = true
        }
    }
    
    // Handle the selection of an option button
    @IBAction func optionSelected(_ sender: UIButton) {
        disableAllButtons()
        
        let currentQuestion = questionBank[questionIndexes[currentQuestionIndex - 1]]
        let selectedAnswer = currentQuestion.options[sender.tag]
        let correctAnswer = currentQuestion.answer
        
        if selectedAnswer == correctAnswer {
            // Selected answer is correct
            sender.backgroundColor = btnCorrectColor
            score += 1
            print("Score: \(score)")
        }
        else {
            // Selected answer is wrong
            wrongAnswerSound()
            sender.backgroundColor = UIColor.red
            
            // Highlight the correct answer
            if let correctAnswerIndex = currentQuestion.options.firstIndex(of: correctAnswer) {
                switch correctAnswerIndex {
                case 0:
                    option1.backgroundColor = btnCorrectColor
                case 1:
                    option2.backgroundColor = btnCorrectColor
                case 2:
                    option3.backgroundColor = btnCorrectColor
                case 3:
                    option4.backgroundColor = btnCorrectColor
                default:
                    break
                }
            }
        }
        
        // Show the next question after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.resetButtonColors()
            self.showNextQuestion()
        }
    }
    
    // Disable all option buttons
    func disableAllButtons() {
        DispatchQueue.main.async {
            self.option1.isEnabled = false
            self.option2.isEnabled = false
            self.option3.isEnabled = false
            self.option4.isEnabled = false
        }
    }
    
    // Reset the quiz to start over
    func resetQuiz() {
        currentQuestionIndex = 0
        score = 0
        initializeQuestionIndexes()
        //showNextQuestion()
    }
}
