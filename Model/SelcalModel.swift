//
//  SelcalModel.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/5/24.
//

import Foundation
import AVFoundation

class SelcalModel {
    
    private let acceptedLetters = "ABCDEFGHJKLMPQRS"
    private var audioEngine: AVAudioEngine?
    private var audioPlayers: [AVAudioPlayerNode] = []
    private var audioFiles: [String: AVAudioFile] = [:]
    
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
        let letters = input.replacingOccurrences(of: "-", with: "")
        var pairs: [[String]] = []
        
        for i in stride(from: 0, to: letters.count, by: 2) {
            let first = String(letters[letters.index(letters.startIndex, offsetBy: i)])
            let second = i + 1 < letters.count ? String(letters[letters.index(letters.startIndex, offsetBy: i + 1)]) : nil
            pairs.append([first, second].compactMap { $0 })
        }
        
        playPairs(pairs)
    }
    
    private func playPairs(_ pairs: [[String]]) {
        let delay = 0.7
        audioEngine = AVAudioEngine()
        
        for (index, pair) in pairs.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index)) {
                self.playPair(pair)
            }
        }
    }
    
    private func playPair(_ pair: [String]) {
        guard let audioEngine = audioEngine else { return }
        
        audioPlayers.forEach { $0.stop() }
        audioPlayers.removeAll()
        
        for letter in pair {
            if let audioFile = getAudioFile(for: letter) {
                let playerNode = AVAudioPlayerNode()
                audioEngine.attach(playerNode)
                audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
                
                playerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
                audioPlayers.append(playerNode)
            }
        }
        
        do {
            try audioEngine.start()
            audioPlayers.forEach { $0.play() }
        } catch {
            print("Audio Engine couldn't start: \(error)")
        }
    }
    
    private func getAudioFile(for letter: String) -> AVAudioFile? {
        if let audioFile = audioFiles[letter] {
            return audioFile
        }
        
        guard let url = Bundle.main.url(forResource: letter, withExtension: "mp3") else {
            print("Could not find file: \(letter).mp3")
            return nil
        }
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            audioFiles[letter] = audioFile
            return audioFile
        } catch {
            print("Could not create audio file for \(letter): \(error)")
            return nil
        }
    }
}
