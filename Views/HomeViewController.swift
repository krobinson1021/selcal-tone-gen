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
    var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        if let logoImage = UIImage(named: "logo") {
            logoImageView.image = logoImage
        }
        view.addSubview(logoImageView)

        // SELCAL
        selcalButton = UIButton(type: .system)
        UIButton.configureButton(selcalButton, title: "SELCAL", color: .black)
        selcalButton.addTarget(self, action: #selector(selcalButtonPressed), for: .touchUpInside)
        view.addSubview(selcalButton)
        
        // SELCAL32
        selcal32Button = UIButton(type: .system)
        UIButton.configureButton(selcal32Button, title: "SELCAL32", color: .systemGray)
        selcal32Button.isEnabled = false // Disable the button
        view.addSubview(selcal32Button)
        
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Center the logo image view horizontally
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            // Center SELCAL button horizontally and place it below the logo
            selcalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selcalButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),

            // Center SELCAL32 button horizontally and place it below the SELCAL button
            selcal32Button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selcal32Button.topAnchor.constraint(equalTo: selcalButton.bottomAnchor, constant: 20)
        ])
    }

    @objc func selcalButtonPressed() {
        let secondVC = SelcalViewController()
        navigationController?.pushViewController(secondVC, animated: true)
    }
}
