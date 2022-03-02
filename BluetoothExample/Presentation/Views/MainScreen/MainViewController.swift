//
//  ViewController.swift
//  BluetoothExample
//
//  Created by Артур on 23.02.22.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController {
    
    var viewModel: MainViewModel!
    var mainScreenView = MainScreenView()
    
    // MARK: Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainScreenView)
        mainScreenView.frame = self.view.bounds
        mainScreenView.setup()
        setupTableView()
        reload()
    }
    
    func reload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("Reload Data")
            self.mainScreenView.tableView.reloadData()
        }
      
    }
    //MARK: Action funcs

    private func setupTableView() {
        mainScreenView.tableView.delegate = self
        mainScreenView.tableView.dataSource = self
    }
}


