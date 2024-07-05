//
//  SelcalViewController.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/4/24.
//

import UIKit

class SelcalViewController: UIViewController, UITextFieldDelegate {
    
    private let selcalView = SelcalView()
    private let selcalModel = SelcalModel()
    
    override func loadView() {
        view = selcalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selcalView.textField.delegate = self
        
        selcalView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        selcalView.verifyButton.addTarget(self, action: #selector(verifyButtonPressed), for: .touchUpInside)
        selcalView.playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        selcalView.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        selcalView.resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // Limit to 4 letters plus a hyphen
        let limitedText = String(text.filter { $0.isLetter || $0 == "-" }.prefix(5))
        
        // Format the text to uppercase with a hyphen
        let formattedText = selcalModel.formatText(limitedText)
        
        // Update the text field with the formatted text
        textField.text = formattedText
        
        // Move the cursor to the end of the text field
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: formattedText.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
        
        // Disable play button if text changes
        selcalView.playButton.isEnabled = false
        UIButton.configureButton(selcalView.playButton, title: "Play", color: .systemGray)
        
        // Hide verification status label
        selcalView.verificationStatusLabel.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only letters and hyphen
        let allowedCharacterSet = CharacterSet.letters.union(CharacterSet(charactersIn: "-"))
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        let newLength = (textField.text?.count ?? 0) - range.length + string.count
        return allowedCharacterSet.isSuperset(of: replacementStringCharacterSet) && newLength <= 5
    }
    
    @objc private func verifyButtonPressed() {
        let inputText = selcalView.textField.text ?? ""
        let letters = inputText.replacingOccurrences(of: "-", with: "")
        if letters.count == 0 {
            return
        }
        
        let isValid = selcalModel.verifyInput(letters)
        if isValid {
            selcalView.verificationStatusLabel.text = "✅"
            selcalView.verificationStatusLabel.textColor = .green
            selcalView.playButton.isEnabled = true
            UIButton.configureButton(selcalView.playButton, title: "Play", color: .systemGreen)
        } else {
            selcalView.verificationStatusLabel.text = "❌"
            selcalView.verificationStatusLabel.textColor = .systemRed
            selcalView.playButton.isEnabled = false
            UIButton.configureButton(selcalView.playButton, title: "Play", color: .systemGray)
        }
        
        // Logging for debugging
        print("Input Text: \(inputText)")
        print("Formatted Letters: \(letters)")
        print("Is Valid: \(isValid)")
        print("Verification Status Label Frame: \(selcalView.verificationStatusLabel.frame)")
    }
    
    @objc private func playButtonPressed() {
        let inputText = selcalView.textField.text ?? ""
        guard !inputText.isEmpty else {
            displayAlert(title: "Invalid Input", message: "Please enter a valid aircraft identifier.")
            return
        }
        
        // Play the pairs with a delay between each pair
        selcalModel.playPairs(inputText)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func resetButtonPressed() {
        selcalView.textField.text = ""
        selcalView.verificationStatusLabel.text = ""
        selcalView.verificationStatusLabel.textColor = .systemRed
        selcalView.playButton.isEnabled = false
        UIButton.configureButton(selcalView.playButton, title: "Play", color: .systemGray)
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
