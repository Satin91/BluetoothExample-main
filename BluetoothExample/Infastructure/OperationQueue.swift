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
        removeFinishedObject()
        check()
    }
    
    func start(operation: BLESyncOperation) {
        queue.addOperation(operation)
    }
    
    func removeFinishedObject() {
        for (index,value) in cancellableOperations.enumerated() {
            if value.writed == true {
                self.cancellableOperations.remove(at: index)
            }
        }
    }
    
    private func check() {
        
      //  self.item = DispatchWorkItem(block: {
            
            switch self.operationModel.type {
            case .UI:
                let operation = BLESyncOperation(operationModel: self.operationModel)
                self.cancellableOperations.append(operation)
            case .preset:
                let operation = BLESyncOperation(operationModel: self.operationModel)
                self.notCancellableOperations.append(operation)
            }
        
            for (index,value) in self.cancellableOperations.enumerated() {
                    self.start(operation: value)
                    value.writed = true
        }
        
        
        print(cancellableOperations.count)
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



class BLEQueue: OperationQueue {
    
    
    
    var workItem: DispatchWorkItem!
    
    var isBlock: Bool = false
    
    var bleOper = BLEOper()
    
    func start(block: @escaping ()->Void ) {
        
        let model = OperationModel(type: .UI , block: block)

        if isSuspended == false {
            bleOper.load(queue: self, operationModel: model)
        }
        

        isSuspended = true
    }
    
    
    func addBLEOperation(operation: OperationModel) {
        
    }
    
    func resume() {
        self.isSuspended = false
    }
    
    
    override init() {
        super.init()
        
        self.maxConcurrentOperationCount = 1
    }
}

