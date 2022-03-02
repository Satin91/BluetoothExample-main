//
//  MainViewCoordinator.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import Foundation
import UIKit

protocol MainViewCoordinatorDependencies {
    func makeMainViewCoordinator(navigationController: UINavigationController) -> MainViewCoordinator
    func makeMainViewController(actions: MainViewActions) -> MainViewController
    
    func makeDeviceViewController(device: Device) -> DeviceViewController
}

class MainViewCoordinator {
    
    let navigationController: UINavigationController
    let dependencies: MainViewCoordinatorDependencies
    
    init(dependencies: MainViewCoordinatorDependencies, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MainViewActions { device in
            self.deviceSelect(deivce: device)
        }
        navigationController.pushViewController(dependencies.makeMainViewController(actions: actions), animated: true)
    }
    
    func deviceSelect(deivce: Device) {
        let vc = dependencies.makeDeviceViewController(device: deivce )
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}
