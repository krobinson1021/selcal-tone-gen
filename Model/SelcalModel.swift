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
        let initialDelay = 0.3
        let toneDuration = 1.0
        let silenceDuration = 0.2
        audioEngine = AVAudioEngine()
        
        for (index, pair) in pairs.enumerated() {
            let delay = initialDelay + (toneDuration + silenceDuration) * Double(index)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.playPair(pair)
            }
        }
    }

    private func playPair(_ pair: [String]) {
        guard let audioEngine = audioEngine else { return }

        for player in audioPlayers {
            player.stop()
            audioEngine.detach(player)
        }
        audioPlayers.removeAll()
        
        var playerNodes: [AVAudioPlayerNode] = []
        
        for letter in pair {
            if let audioFile = getAudioFile(for: letter) {
                let playerNode = AVAudioPlayerNode()
                audioEngine.attach(playerNode)
                audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
                playerNodes.append(playerNode)
            }
        }
        
        // Ensure all nodes are connected before starting the engine
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine couldn't start: \(error)")
        }
        
        let startTime = AVAudioTime(hostTime: mach_absolute_time() + 512_000)
        
        for (index, letter) in pair.enumerated() {
            if let audioFile = getAudioFile(for: letter) {
                let playerNode = playerNodes[index]
                playerNode.scheduleFile(audioFile, at: startTime, completionHandler: nil)
            }
        }

        playerNodes.forEach { $0.play() }
        audioPlayers = playerNodes
    }
    
    private func getAudioFile(for letter: String) -> AVAudioFile? {
        if let audioFile = audioFiles[letter] {
            return audioFile
        }
        
        guard let url = Bundle.main.url(forResource: letter, withExtension: "wav") else {
            print("Could not find file: \(letter).wav")
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
