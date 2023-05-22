//
//  Card.swift
//  Flashzilla
//
//  Created by Aleksey Nosik on 12.05.2023.
//

import Foundation

struct Card: Codable, Identifiable {
    var id = UUID()
    let promt: String                       // подсказка
    let answer: String                      // ответ
    
    static let example = Card(promt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
