//
//  MainViewModel.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import Foundation



struct MainViewActions {
    let deviceSelect: (_ device: Device) -> Void
}
protocol MainViewModelDependencies: AnyObject {
    func makeBleCommandsUseCase() -> BleCommandsUseCase
}

protocol MainViewModel: AnyObject {
    func getDevicesList() -> [Device]
    func selectDevice(indexPath: IndexPath)
}


class MainViewModelImpl: MainViewModel {

    let dependencies: MainViewModelDependencies
    var bleCommandUseCase: BleCommandsUseCase!
    let actions: MainViewActions
    
    init(dependencies: MainViewModelDependencies, actions: MainViewActions) {
        self.dependencies = dependencies
        self.actions = actions
        self.bleCommandUseCase = dependencies.makeBleCommandsUseCase()
        self.bleCommandUseCase.startScan()
    }
    
    func getDevicesList() -> [Device] {
        return bleCommandUseCase.getDevicesList()
    }
    
    func selectDevice(indexPath: IndexPath) {
        guard let device = getDevicesList().first else { return }
        actions.deviceSelect(device)
    }
    
    
}
