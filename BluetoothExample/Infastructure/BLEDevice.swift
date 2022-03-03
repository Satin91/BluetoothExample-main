//
//  BLEDevice.swift
//  BluetoothExample
//
//  Created by Артур on 3.03.22.
//

import Foundation


class BLEDevice {
    var bleWorkerDelegate: BLEWorkerDelegate!
    let name: String?
    let id: UUID
    
    init(name: String?, id: UUID) {
        self.name = name
        self.id   = id
    }
}
