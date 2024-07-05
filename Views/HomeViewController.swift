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

        // Logo
        logoImageView = UIImageView(image: UIImage(named: "logo.png"))
       logoImageView.translatesAutoresizingMaskIntoConstraints = false
       logoImageView.contentMode = .scaleAspectFit
       view.addSubview(logoImageView)
        
        // SELCAL
        selcalButton = UIButton(type: .system)
        configureButton(selcalButton, title: "SELCAL", color: .black)
        selcalButton.addTarget(self, action: #selector(selcalButtonPressed), for: .touchUpInside)
        selcalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selcalButton)
        
        // SELCAL32
        selcal32Button = UIButton(type: .system)
        configureButton(selcal32Button, title: "SELCAL32", color: .red)
        selcal32Button.isEnabled = false
        selcal32Button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selcal32Button)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            selcalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selcalButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 60),
            
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
