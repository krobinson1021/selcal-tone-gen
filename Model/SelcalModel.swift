//
//  SelcalModel.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/5/24.
//

import Foundation
import AVFoundation

class SelcalModel {
    private var audioEngine: AVAudioEngine?
    private var audioFiles: [String: AVAudioFile] = [:]
    
    func verifyInput(_ input: String) -> Bool {
        return input.count == 4
    }
    
    func formatText(_ text: String) -> String {
        let uppercaseText = text.uppercased().filter { $0.isLetter }
        let limitedText = String(uppercaseText.prefix(4)) // Limit to 4 characters
        var formattedText = ""
        for (index, character) in limitedText.enumerated() {
            if index % 2 == 0 && index != 0 {
                formattedText += "-"
            }
            formattedText += String(character)
        }
        return formattedText
    }
    
    func playPairs(_ text: String) {
        let pairs = splitIntoPairs(text)
        let initialDelay = 0.3
        
        for (index, pair) in pairs.enumerated() {
            let delay = initialDelay + (Double(index) * 0.4)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.playPair(pair)
            }
        }
    }
    
    private func splitIntoPairs(_ text: String) -> [[String]] {
        let characters = Array(text.replacingOccurrences(of: "-", with: ""))
        var pairs: [[String]] = []
        
        for i in stride(from: 0, to: min(characters.count, 4), by: 2) {  // Limit to 4 characters
            let first = String(characters[i])
            let second = i + 1 < characters.count ? String(characters[i + 1]) : nil
            pairs.append([first, second].compactMap { $0 })
        }
        
        return pairs
    }
    
    private func playPair(_ pair: [String]) {
        audioEngine?.stop()
        audioEngine = AVAudioEngine()
        
        var playerNodes: [AVAudioPlayerNode] = []
        
        for letter in pair {
            guard let playerNode = createAudioPlayerNode(for: letter) else {
                print("Failed to create player node for \(letter)")
                return
            }
            audioEngine?.attach(playerNode)
            guard let format = playerNode.outputFormat(forBus: 0) as AVAudioFormat? else {
                print("Error getting output format for \(letter)")
                return
            }
            audioEngine?.connect(playerNode, to: audioEngine!.mainMixerNode, format: format)
            playerNodes.append(playerNode)
        }
        
        do {
            try audioEngine?.start()
            for playerNode in playerNodes {
                playerNode.play()
            }
        } catch {
            print("Could not start audio engine: \(error)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.audioEngine?.stop()
        }
    }
    
    private func createAudioPlayerNode(for letter: String) -> AVAudioPlayerNode? {
        if let audioFile = audioFiles[letter] {
            return schedulePlayerNode(with: audioFile)
        }
        
        guard let url = Bundle.main.url(forResource: letter, withExtension: "mp3") else {
            print("Could not find file: \(letter).mp3")
            return nil
        }
        
        do {
            let audioFile = try AVAudioFile(forReading: url)
            audioFiles[letter] = audioFile
            return schedulePlayerNode(with: audioFile)
        } catch {
            print("Could not create audio file for \(letter): \(error)")
            return nil
        }
    }
    
    private func schedulePlayerNode(with audioFile: AVAudioFile) -> AVAudioPlayerNode {
        let playerNode = AVAudioPlayerNode()
        playerNode.scheduleFile(audioFile, at: nil) {
            print("Finished playing \(audioFile.url.lastPathComponent)")
        }
        return playerNode
    }
}
