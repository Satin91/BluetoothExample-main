//
//  Constraints.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import Foundation
import UIKit

extension UIView {

    func addConstraints(leftPadding: CGFloat? = 0, rightPadding: CGFloat? = 0, topPadding: CGFloat? = 0, bottomPadding: CGFloat? = 0, to: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: leftPadding!),
            trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: rightPadding!),
            topAnchor.constraint(equalTo: to.topAnchor, constant: topPadding!),
            bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: bottomPadding!),
        ])
    }
}
