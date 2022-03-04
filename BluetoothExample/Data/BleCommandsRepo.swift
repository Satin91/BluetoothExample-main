//
//  BleCommandsRepo.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import Foundation

protocol BleCommandsImplDependencies {
    func makeBleClient() -> BleClient
}

protocol BleCommandsRepo {
    func getDevicesList() -> [Device]
    func sendCommand(data: UInt8)
    func connectPeripheral()
    func disconnect()
    func startScan()
    func stopScan()
}

class BleCommandsRepoImpl: BleCommandsRepo {
   
    
    
    //MARK: Properties
    private let bleClient: BleClient
    let dependencies: BleCommandsImplDependencies
    
   
    
    init(dependencies: BleCommandsImplDependencies) {
        self.dependencies = dependencies
        self.bleClient = dependencies.makeBleClient()
    }
    
    
    //MARK: Delegate funcs
    func getDevicesList() -> [Device] {
        let result = bleClient.findedPeripherals.map { peripheral in
            return Device(name: peripheral.name!, id: peripheral.identifier)
        }
        return result
    }
    
    func connectPeripheral() {
        bleClient.connectPeripheral()
    }
    
    func disconnect() {
        bleClient.disconnect()
    }
    
    func sendCommand(data: UInt8) {
        bleClient.writeData(data: data)
    }
    
    func startScan() {
        bleClient.startScan()
    }
    
    func stopScan() {
        bleClient.stopScan()
    }
    

}

