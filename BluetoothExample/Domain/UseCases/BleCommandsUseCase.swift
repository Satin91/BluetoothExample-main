//
//  BleCommandsUseCase.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import Foundation



final class BleCommandsUseCase {
    
    private let bleCommands: BleCommandsRepo
    
    init(bleCommands: BleCommandsRepo) {
        self.bleCommands = bleCommands
        
    }
    
    func startScan() {
        bleCommands.startScan()
    }
    
    func getDevicesList() -> [Device] {
        return bleCommands.getDevicesList()
    }
    
    func connectPeripheral() {
        bleCommands.connectPeripheral()
    }
    
    func disconnect() {
        bleCommands.disconnect()
    }
    
    func sendCommand(data: Int) {
        self.bleCommands.sendCommand(data: data)
    }
    
}
