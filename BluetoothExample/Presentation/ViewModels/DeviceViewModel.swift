//
//  DeviceViewModel.swift
//  BluetoothExample
//
//  Created by Артур on 25.02.22.
//

import Foundation


protocol DeviceViewDependencies {
    func makeBleCommandsUseCase() -> BleCommandsUseCase
}

protocol DeviceViewModel: AnyObject {
    var device: Device { get set }
    
    func viewDidLoad()
    func sendCommand(data: Int)
    func disconnect()
}

class DeviceViewModelImpl: DeviceViewModel {
 
    var device: Device
    let dependencies: DeviceViewDependencies
    private var bleCommandsUseCase: BleCommandsUseCase!
    
    init(dependencies: DeviceViewDependencies, device: Device) {
        self.dependencies = dependencies
        self.device = device
        self.bleCommandsUseCase = dependencies.makeBleCommandsUseCase()
    }
    
    func viewDidLoad() {
        bleCommandsUseCase.connectPeripheral()
    }
    
    func sendCommand(data: Int) {
        bleCommandsUseCase.sendCommand(data: data)
    }
    
    func disconnect() {
        bleCommandsUseCase.disconnect()
    }
  
    
}
