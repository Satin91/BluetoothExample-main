//
//  MainScreenView.swift
//  BluetoothExample
//
//  Created by Артур on 26.02.22.
//

import UIKit


class MainScreenView: UIView {
    
    //MARK: Properties
    var tableView: UITableView!
    var imageView: UIImageView!
    
    //MARK: Init
    func setup() {
        
        setupTableView()
        setupImageView()
    }
    
    
    //MARK: Private funcs
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        self.addSubview(tableView)
        tableView.addConstraints(topPadding: 140 ,to: self)
        registerScanCell()
    }
    
    private func setupImageView() {
        imageView = UIImageView(image: UIImage(named: "BluetoothExample"))
        self.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 140)
        imageView.backgroundColor = .background
    }
    
    private func registerScanCell() {
        self.tableView.register(ScanTableViewCell.self, forCellReuseIdentifier: "scanCell")
    }
    
}
