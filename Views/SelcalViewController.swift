//
//  SelcalViewController.swift
//  SELCALToneGen
//
//  Created by Katie Robinson on 7/4/24.
//

import UIKit

class SelcalViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.text = "This is the second page"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

