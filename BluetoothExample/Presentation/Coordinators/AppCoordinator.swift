//
//  AppCoordinator.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import Foundation
import UIKit


protocol AppCoordinatorDependencies {
    func makeMainViewCoordinator(navigationController: UINavigationController) -> MainViewCoordinator
}

class AppCoordinator {
    
    let mainWindow: UIWindow
    private let navigationController: UINavigationController
    private let dependencies: AppCoordinatorDependencies
    init(dependencies: AppCoordinatorDependencies, scene: UIWindowScene) {
        self.dependencies = dependencies
        navigationController = UINavigationController()
        mainWindow = UIWindow(windowScene: scene)
        mainWindow.backgroundColor = .background
        mainWindow.windowLevel = .normal
        mainWindow.rootViewController = navigationController
        mainWindow.isHidden = false
        mainWindow.makeKeyAndVisible()
    }
    
 
    func start() {
        let vc = self.dependencies.makeMainViewCoordinator(navigationController: self.navigationController)
        vc.start()
    }
}
