//
//  apiCall.swift
//  Quizzin
//
//  Created by IPS-108 on 14/06/23.
//

import Foundation

class ApiCall {
    func api(completion: @escaping ([QuestionBank]) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/takhtani09/mcqQuestions/main/questions.json") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: [])

                if let questionBankArray = jsonArray as? [[String: Any]] {
                    var questionBank: [QuestionBank] = []

                    for item in questionBankArray {
                        if let question = item["question"] as? String,
                           let options = item["options"] as? [String],
                           let answer = item["answer"] as? String {
                            let bank = QuestionBank(question: question, options: options, answer: answer)
                            questionBank.append(bank)
                        }
                    }
                    //print(questionBank)
                    completion(questionBank)
                } else {
                    print("Invalid JSON format")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
}
