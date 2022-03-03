//
//  RectangleButton.swift
//  BluetoothExample
//
//  Created by Артур on 27.02.22.
//

import Foundation
import UIKit

class RectangleButton: UIButton {
    
    override init(frame: CGRect) {
        let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        super.init(frame: frame)
        
    }
    enum ButtonType {
        case on
        case off
        case preset
    }
    convenience init(type: ButtonType) {
        self.init()
        setup(type: type)
        
    }
    
    func setup(type: ButtonType) {
        self.layer.cornerCurve  = .continuous
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        switch type {
        case .on:
            self.backgroundColor = .systemBlue
            self.setTitle("On", for: .normal)
        case .off:
            self.setTitle("Off", for: .normal)
            self.backgroundColor = .systemRed
        case .preset:
            self.setTitle("Preset", for: .normal)
            self.backgroundColor = .systemYellow
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
