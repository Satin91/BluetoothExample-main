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
    
    var cancellableOperations: [BLEOperation] = []
    var notCancellableOperations: [BLESyncOperation] = []
    var operationModel: OperationModel!
    // var operation: BLESyncOperation
    let serialQueue = DispatchQueue(label: "serialQueue")
    var item : DispatchWorkItem!
    
    func load(queue: BLEQueue, handler: @escaping () -> Void) {
        let operation = BLEOperation(handler: handler)
        operation.state = .ready
        operation.name = "1"
        self.cancellableOperations.append(operation)
       // queue.addOperation(operation)
        //let operation2 = BLEOperation(handler: handler)
        //operation2.state = .executing
        //operation2.name = "2"
    //    queue.addOperation(operation2)
    }
    func start(queue: BLEQueue) {
        
        for i in self.cancellableOperations {
            queue.addOperation(i)
        }
        
        
        
//        for i in queue.operations {
//            let oper = i as! BLEOperation
//            if oper.name == "1" {
//                oper.state = .ready
//            } else {
//                //oper.cancel()
//                //oper.state = .finished
//            }
            
            
        self.cancellableOperations.removeAll()
        
        print(queue.operations.count)
    }
}

class BLEQueue: OperationQueue {
    
    var workItem: DispatchWorkItem!
    
    var serialQueue = DispatchQueue(label: "serialQueue")
    
    var isBlock: Bool = false
    
    var bleOper = BLEOper()
    
    func start(block: @escaping ()->Void ) {
        
        
        bleOper.load(queue: self, handler: block)
        
        if isSuspended == false {
            bleOper.start(queue: self)
        }
        isSuspended = true
    }
    
    func resume() {
        self.isSuspended = false
    }
    
    
    override init() {
        super.init()
        self.maxConcurrentOperationCount = 1
    }
}


class BLEOperation: BLESyncOperation {
   
    
    var handler: (() -> Void)
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
        super.init()
    }
    
    override func main() {
        print(#function)
        syncAdd(handler: handler)
    }
}

class BLESyncOperation: Operation {
    public enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    
    public var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    var writed: Bool = false
    
    func syncAdd(handler: () -> Void) {
        handler()
        cancel()
        //state = .finished
        print(#function)
    }

}

extension BLESyncOperation {
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return super.isExecuting && state == .executing
    }
    
    override var isFinished: Bool {
        return super.isFinished && state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
//    override func start() {
//        print(#function)
//        if isCancelled {
//            state = .finished
//            return
//        }
//        state = .ready
//        main()
//    }
//    override func main() {
//        print(#function)
//        state = .ready
//    }
    
    override func cancel() {
        super.cancel()
        state = .finished
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
