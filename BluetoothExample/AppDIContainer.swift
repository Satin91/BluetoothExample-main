//
//  AppDIContainer.swift
//  BluetoothExample
//
//  Created by Артур on 25.02.22.
//

import CoreBluetooth
import UIKit

class AppDIContainer: AppCoordinatorDependencies, MainViewCoordinatorDependencies, MainViewModelDependencies, BleCommandsImplDependencies, DeviceViewDependencies {
    
    lazy var bleClient = BleClientImpl(centralManager: CBCentralManager())
    
    
    //MARK: Make main view
    func makeMainViewCoordinator(navigationController: UINavigationController) -> MainViewCoordinator {
        return MainViewCoordinator(dependencies: self, navigationController: navigationController)
    }
    
    func makeMainViewModel(actions: MainViewActions) -> MainViewModel {
        return MainViewModelImpl(dependencies: self, actions: actions)
    }
    
    func makeMainViewController(actions: MainViewActions) -> MainViewController {
        let vc = MainViewController()
        vc.viewModel = makeMainViewModel(actions: actions)
        return vc
    }
    
    //MARK: Device view
    func makeDeviceScreenCoordinator(navigationController: UINavigationController, device: Device) -> DeviceViewCoordinator {
        return DeviceViewCoordinator(dependencies: self, navigationController: navigationController, device: device)
    }
    
    func makeDeviceViewController(device: Device) -> DeviceViewController {
        let vc = DeviceViewController()
        vc.deviceViewModel = makeDeviceViewModel(device: device)
        return vc
    }
    
    func makeDeviceViewModel(device: Device) -> DeviceViewModel {
        return DeviceViewModelImpl(dependencies: self, device: device)
    }
    
    //MARK: Make ble client
    func makeBleClient() -> BleClient {
        return bleClient
    }
    
    func makeBleCommandsUseCase() -> BleCommandsUseCase {
        return BleCommandsUseCase(bleCommands: BleCommandsRepoImpl(dependencies: self))
    }
    
}
