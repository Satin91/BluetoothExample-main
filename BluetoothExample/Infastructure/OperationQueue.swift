//
//  OperationQueue.swift
//  BluetoothExample
//
//  Created by Артур on 1.03.22.
//

import Foundation




extension Operation {
    convenience init(qos: QualityOfService) {
        self.init()
        self.qualityOfService = qos
    }
}



struct BLEOperationStruct {
    var type: OperationType
    var isCuncellable: Bool
    var name: String
    var operation: Operation
    init(type: OperationType, block: @escaping () -> Void) {
        
        self.type = type
        self.operation = BlockOperation(block: block)
        
        switch type {
        case .UI:
            self.isCuncellable = true
            self.name = "UI"
            self.operation.qualityOfService = .userInteractive
        case .preset:
            self.isCuncellable = false
            self.name = "preset"
            self.operation.qualityOfService = .userInitiated
        }
    }
    
}

enum OperationType {
    case UI
    case preset
}



class BLEOperation: Operation {
    
    var _isFinished: Bool = false
    
    override var isFinished: Bool {
           set {
               willChangeValue(forKey: "isFinished")
               _isFinished = newValue
               didChangeValue(forKey: "isFinished")
           }
           
           get {
               return _isFinished
           }
       }

       var _isExecuting: Bool = false
       
       override var isExecuting: Bool {
           set {
               willChangeValue(forKey: "isExecuting")
               _isExecuting = newValue
               didChangeValue(forKey: "isExecuting")
           }
           
           get {
               return _isExecuting
           }
       }
       
       func execute() {
           block?()
       }
    
    var block: (()-> Void)?
       
    init(block: (() -> Void)?) {
        self.block = block
    }
    
       override func start() {
           execute()
           isExecuting = true
           isExecuting = false
           isFinished = true
           
       }
}

class BLEQueue: OperationQueue {
    
    
    var operationsArray = [BLEOperation]()
    
    let operationQueue = OperationQueue()
    
    func start(operation: BLEOperation) {
        print("Число операций ДО удаления\(self.operationsArray.count)")
        print(self.operations)
        //self.operationQueue.addOperation {
            if !self.operationsArray.isEmpty {
                for index in 0...self.operationsArray.count - 1 {
                    print("INDEX \(index)")
                    guard let name = self.operationsArray[index].name else { return }
                    if name == operation.name {
                        self.operationsArray.remove(at: index)
                        print("Число операций ПОСЛЕ удаления\(self.operationsArray.count)")
                    }
                }
            }
     //   }
        
        
     //   self.operationQueue.addOperation {
            if self.isSuspended == false {
                self.operationsArray.append(operation)
                self.addOperation(self.operationsArray.first!)
                self.block()
            } else {
                self.operationsArray.append(operation)
            }
      //  }
      
        
      
        
    }
    
    func block() {
        self.isSuspended = true
    }
    
    func unBlock() {
        self.isSuspended = false
    }
    
    override init() {
        super.init()
        self.operationQueue.maxConcurrentOperationCount = 1
        self.maxConcurrentOperationCount = 1
    }
}


class OperationObserver: NSObject {
    init(operation: BLEOperation) {
        super.init()
        operation.addObserver(self, forKeyPath: "finished", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else {
            return
        }
        
        switch key {
        case "finished":
            print("done")
        default:
            print("doing")
        }
    }
}
