//
//  SelcalViewController.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/4/24.
//

import UIKit
import AVFoundation

class SelcalViewController: UIViewController, UITextFieldDelegate {

    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter aircraft identifier..."
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let playButton: UIButton = {
        let button = UIButton(type: .system)
        UIButton.configureButton(button, title: "PLAY", color: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var audioPlayers: [AVAudioPlayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        textField.delegate = self
        
        view.addSubview(textField)
        view.addSubview(playButton)
        
        setupConstraints()
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Center the text field horizontally
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            textField.widthAnchor.constraint(equalToConstant: 250),
            
            // Position the play button below the text field
            playButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // Format the text to uppercase with hyphens
        let formattedText = formatText(text)
        
        // Update the text field with the formatted text
        textField.text = formattedText
        
        // Move the cursor to the end of the text field
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: formattedText.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    private func formatText(_ text: String) -> String {
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only letters
        let allowedCharacterSet = CharacterSet.letters
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: replacementStringCharacterSet)
    }
    
    @objc private func playButtonPressed() {
        guard let text = textField.text else { return }
        
        // Split the text into pairs of characters
        let pairs = splitIntoPairs(text)
        
        // Play the pairs with a delay between each pair
        playPairs(pairs)
    }
    
    private func splitIntoPairs(_ text: String) -> [[String]] {
        let characters = Array(text.replacingOccurrences(of: "-", with: ""))
        var pairs: [[String]] = []
        
        for i in stride(from: 0, to: characters.count, by: 2) {
            let first = String(characters[i])
            let second = i + 1 < characters.count ? String(characters[i + 1]) : nil
            pairs.append([first, second].compactMap { $0 })
        }
        
        return pairs
    }
    
    private func playPairs(_ pairs: [[String]]) {
        let delay = 0.2
        
        for (index, pair) in pairs.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * Double(index)) {
                self.playPair(pair)
            }
        }
    }
    
    private func playPair(_ pair: [String]) {
        audioPlayers.removeAll()
        
        for letter in pair {
            if let player = createAudioPlayer(for: letter) {
                audioPlayers.append(player)
                player.play()
            }
        }
    }
    
    private func createAudioPlayer(for letter: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: letter, withExtension: "mp3") else {
            print("Could not find file: \(letter).mp3")
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            return player
        } catch {
            print("Could not create audio player for \(letter): \(error)")
            return nil
        }
    }
}
