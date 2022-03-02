//
//  Device.swift
//  BluetoothExample
//
//  Created by Артур on 25.02.22.
//

import Foundation



class Device {
    let name: String?
    let id: UUID
    
    init(name: String?, id: UUID) {
        self.name = name
        self.id   = id
    }
}
