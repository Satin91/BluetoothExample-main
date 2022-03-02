//
//  BleClient.swift
//  BluetoothExample
//
//  Created by Артур on 25.02.22.
//

import Foundation
import CoreBluetooth
import Combine

struct CBUUIDs{
    
    static let kBLEService_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    static let kBLE_Characteristic_uuid_Tx = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    static let kBLE_Characteristic_uuid_Rx = "6e400003-b5a3-f393-e0a9-e50e24dcca9e"
    
    static let BLEService_UUID = CBUUID(string: kBLEService_UUID)
    static let BLE_Characteristic_uuid_Tx = CBUUID(string: kBLE_Characteristic_uuid_Tx)//(Property = Write without response)
    static let BLE_Characteristic_uuid_Rx = CBUUID(string: kBLE_Characteristic_uuid_Rx)// (Property = Read/Notify)
    
}

protocol BleClient: AnyObject {
    var findedPeripherals: [CBPeripheral] { get set }
    func startScan()
    func stopScan()
    func writeData(data: Int)
    func connectPeripheral()
    func disconnect()
    func getDevicesList(peripheral: CBPeripheral)
}

class BleClientImpl: NSObject, BleClient {
    
    func connectPeripheral() {
        self.connectedPeripheral = findedPeripherals.first
        self.centralManager.connect(self.connectedPeripheral!, options: nil)
        self.connectedPeripheral!.delegate = self
        self.connectedPeripheral!.discoverServices(nil)
    }
    
    func disconnect() {
        guard let peripheral = connectedPeripheral else { return }
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
    
    //MARK: Properties
    let centralManager: CBCentralManager
    let queue = BLEQueue()
    var operation: BLEOper!
    var findedPeripherals: [CBPeripheral] = []
    
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    private var connectedPeripheral: CBPeripheral?
    
    
    init(centralManager: CBCentralManager) {
        self.centralManager = centralManager
        super.init()
        centralManager.delegate = self
    }
    
    func writeData(data: Int) {
        
        var int = UInt8(data)
        let value = Data(bytes: &int, count: MemoryLayout.size(ofValue: int))
        guard let peripheral = connectedPeripheral, let characteristic = txCharacteristic else { return }
        //print("Write data \(value)")
        
        queue.start {
            peripheral.writeValue(value, for: characteristic, type: .withResponse)
        }
        
        
        //print("Name\(name)")
        
    //    self.queue.start(operation: operation)
    }
    
    func getDevicesList(peripheral: CBPeripheral) {
        self.findedPeripherals = [peripheral]
    }
    
    
    
    func startScan() {
        centralManager.scanForPeripherals(withServices: [CBUUIDs.BLEService_UUID] , options: nil)
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
}

extension BleClientImpl: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
        case .poweredOn:
            print("Is Powered On.")
            self.startScan()
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !self.findedPeripherals.contains(peripheral) {
            self.findedPeripherals.append(peripheral)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    
}

extension BleClientImpl: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = self.connectedPeripheral?.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        self.queue.resume()
        print("RESUME")
//        
//        guard characteristic == rxCharacteristic, let characteristicValue = characteristic.value, let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }
//        let characteristicASCIIValue = ASCIIstring
//
        //  print("Value Recieved: \((characteristicASCIIValue as String))")
    }
    
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else { return }
        characteristics.forEach { characteristic in
            if characteristic.uuid == CBUUIDs.BLE_Characteristic_uuid_Rx {
                rxCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
                self.getDevicesList(peripheral: connectedPeripheral!)
            } else if characteristic.uuid == CBUUIDs.BLE_Characteristic_uuid_Tx {
                txCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: txCharacteristic!)
                peripheral.readValue(for: characteristic)
                self.getDevicesList(peripheral: peripheral)
            }
        }
        
    }
}
