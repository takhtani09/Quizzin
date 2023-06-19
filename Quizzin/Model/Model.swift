//
//  Model.swift
//  Quizzin
//
//  Created by IPS-108 on 14/06/23.
//

import Foundation

struct QuestionBank {
    let question: String
    let options: [String]
    let answer: String
}

struct LeaderBoard {
    let username: String
    let score: Int
}
