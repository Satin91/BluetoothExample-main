//
//  DeviceViewCoordinator.swift
//  BluetoothExample
//
//  Created by Артур on 25.02.22.
//

import UIKit


class DeviceViewCoordinator {
    private let dependencies: MainViewCoordinatorDependencies
    private weak var navigationController: UINavigationController?
    
    init(dependencies: MainViewCoordinatorDependencies, navigationController: UINavigationController, device: Device) {
        self.dependencies = dependencies
        self.navigationController = navigationController
        
        let vc = dependencies.makeDeviceViewController(device: device)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
