//
//  SelcalModel.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/5/24.
//

import Foundation

class SelcalModel {
    
    private let acceptedLetters = "ABCDEFGHJKLMPQRS"
    
    func verifyInput(_ input: String) -> Bool {
        let letters = Array(input)
        
        // Check if all letters are in the accepted set
        guard Set(letters).isSubset(of: Set(acceptedLetters)) else {
            return false
        }
        
        // Check if all letters are unique
        guard Set(letters).count == letters.count else {
            return false
        }
        
        // Check if pairs are alphabetically sequential
        for i in stride(from: 0, to: letters.count, by: 2) {
            guard i + 1 < letters.count else { continue }
            if letters[i] > letters[i + 1] {
                return false
            }
        }
        
        return true
    }
    
    func formatText(_ text: String) -> String {
        let uppercaseText = text.uppercased().filter { $0.isLetter }
        var formattedText = ""
        for (index, character) in uppercaseText.enumerated() {
            if index % 2 == 0 && index != 0 {
                formattedText += "-"
            }
            formattedText += String(character)
        }
        return formattedText
    }
    
    func playPairs(_ input: String) {
        // Implementation for playing pairs of tones
    }
}
