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



class BLEOper {
    
    var queue: BLEQueue!
    
    var cancellableOperations: [BLESyncOperation] = []
    var notCancellableOperations: [BLESyncOperation] = []
    var operationModel: OperationModel!
    // var operation: BLESyncOperation
    let serialQueue = DispatchQueue(label: "serialQueue")
    var item : DispatchWorkItem!
    
    func load(queue: BLEQueue, operationModel: OperationModel) {
        self.queue = queue
        self.operationModel = operationModel
    }
    
    func start() {
        print(Thread.current)
        let operation = BLESyncOperation(operationModel: self.operationModel)
        queue.addOperation(operation)
    }
    
    func removeOperations() {
        guard let queue = self.queue else { return }
        for index in 0..<queue.operations.count {
            let value = queue.operations[index]
            if value.name == "UI" {
                print("cancel")
                value.cancel()
            }
        }
    }
}

class BLEQueue: OperationQueue {
    
    var workItem: DispatchWorkItem!
    
    var serialQueue = DispatchQueue(label: "serialQueue")
    
    var isBlock: Bool = false
    
    var bleOper = BLEOper()
    
    func start(block: @escaping ()->Void ) {
        
        
        let model = OperationModel(type: .UI , block: block)
        
        bleOper.load(queue: self, operationModel: model)
        
        bleOper.start()
        
        isSuspended = true
    }
    
    func resume() {
        bleOper.removeOperations()
        self.isSuspended = false
    }
    
    
    override init() {
        super.init()
        self.maxConcurrentOperationCount = 1
    }
}


class BLESyncOperation: Operation {
    
    
    var writed: Bool = false
    
    init(operationModel: OperationModel) {
        super.init()
        switch operationModel.type {
        case .UI:
            name = "UI"
        case .preset:
            name = "Preset"
        }
        self.completionBlock = operationModel.block
    }
}



struct OperationModel {
    var type: OperationType
    var block: (() -> Void)
}
enum OperationType {
    case UI
    case preset
}
