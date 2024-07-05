//
//  SelcalView.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/5/24.
//

import UIKit

class SelcalView: UIView {

    let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Aircraft Identifier"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 24)
        return tf
    }()
    
    let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        UIButton.configureButton(button, title: "VERIFY", color: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        UIButton.configureButton(button, title: "PLAY", color: .systemGray)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    let verificationStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        UIButton.configureButton(button, title: "Back", color: .black)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        UIButton.configureButton(button, title: "Reset", color: .red)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(instructionLabel)
        addSubview(textField)
        addSubview(verifyButton)
        addSubview(playButton)
        addSubview(verificationStatusLabel)
        addSubview(backButton)
        addSubview(resetButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Center the instruction label horizontally and position it at the top
            instructionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            instructionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            
            // Center the text field horizontally and position it below the instruction label
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            // Position the verify button below the text field
            verifyButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            verifyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Position the verification status label next to the verify button
            verificationStatusLabel.centerYAnchor.constraint(equalTo: verifyButton.centerYAnchor),
            verificationStatusLabel.leadingAnchor.constraint(equalTo: verifyButton.trailingAnchor, constant: 10),
            
            // Position the play button below the verify button
            playButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Position the back button at the bottom left
            backButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Position the reset button next to the back button
            resetButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            resetButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
