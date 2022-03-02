//
//  TableViewExt.swift
//  BluetoothExample
//
//  Created by Артур on 24.02.22.
//

import Foundation
import UIKit


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.getDevicesList().count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanCell", for: indexPath) as! ScanTableViewCell
        
        let object = viewModel.getDevicesList()[indexPath.row]
        
        cell.label.text = object.name == nil ? "N/A" : object.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectDevice(indexPath: indexPath)
    }
}
