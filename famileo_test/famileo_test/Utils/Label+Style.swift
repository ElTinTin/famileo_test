//
//  Label+Style.swift
//  famileo_test
//
//  Created by Quentin Deschamps on 22/08/2023.
//

import Foundation
import UIKit

extension UILabel {
    func grayTagged() {
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = .lightGray.withAlphaComponent(0.1)
    }
    
    func colorTagged() {
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.backgroundColor = .orange.withAlphaComponent(0.1)
    }
}
