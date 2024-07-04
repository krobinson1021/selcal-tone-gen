//
//  ViewController.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/4/24.
//

import UIKit

class HomeViewController: UIViewController {

    var selcalButton: UIButton!
    var selcal32Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // Initialize and configure SELCAL button
        selcalButton = UIButton(type: .system)
        configureButton(selcalButton, title: "SELCAL", color: .black)
        selcalButton.addTarget(self, action: #selector(selcalButtonPressed), for: .touchUpInside)
        selcalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selcalButton)
        
        // Initialize and configure SELCAL32 button
        selcal32Button = UIButton(type: .system)
        configureButton(selcal32Button, title: "SELCAL32", color: .systemGray)
        selcal32Button.isEnabled = false // Disable the button
        selcal32Button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selcal32Button)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Center SELCAL button horizontally and vertically
            selcalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selcalButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            // Center SELCAL32 button horizontally and place it below the SELCAL button
            selcal32Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selcal32Button.topAnchor.constraint(equalTo: selcalButton.bottomAnchor, constant: 20)
        ])
    }

    @objc func selcalButtonPressed() {
        let secondVC = SelcalViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    private func configureButton(_ button: UIButton, title: String, color: UIColor) {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = color
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        button.configuration = configuration
    }
}
