//
//  Queue.swift
//  BluetoothExample
//
//  Created by Артур on 3.03.22.
//

import Foundation

protocol BLEWorkerDelegate: AnyObject {
    
    func send(data: Data)
}


//Надор методов для отправки данных. Его делегатом является BLEDevice
class BLEWorker {
    
    //Сторонняя очередь на оптравку сообщений
    private var outputQueue: BLEQueueOutput?
    
    //Внутренняя очередь для отправления сообщений
    private var workerQueue: DispatchQueue = DispatchQueue(label: "workerQueue",attributes: .concurrent)
    //Работает ли проверка
    private var isWorkerRunning: Bool = true
    
    
    weak var delegate: BLEWorkerDelegate!
    
    init(outputQueue: BLEQueueOutput) {
        self.outputQueue = outputQueue
    }
    
    //MARK: Action funcs
    
    //Подключает внешнюю очередь
    public func connect(queue: BLEQueueOutput) {
        self.outputQueue = queue
    }
    
    
    
    var currentMessages: [Message<NSObject>]?
    
   // var semaphore = DispatchSemaphore(value: 1)
    
    //Отключает внешнюю очередь
    public func disconnectQueue() {
        self.outputQueue = nil
    }
    
    var workItem: DispatchWorkItem!
    
    //Запускает цикл для проверки на присутствие сообщений
    public func start() {
        
        workerQueue.async { [weak self] in
            guard let self = self else { return }
            
           
            while self.isWorkerRunning {
                
                guard let messages = self.outputQueue?.pull() else { continue }
                
                AppDelegate.MessageQueue.sync {
                    self.sendValue(messages: messages)
                }
                Thread.sleep(forTimeInterval: 0.01)
            }
        }
    }
    
    var isExecuting: Bool = false
    
    func sendValue(messages: [Message<NSObject>]) {
        
        for message in messages {
            let data = message.getData()
            self.delegate.send(data: data)
            let result = message.start()
            switch result {
            case .success(let message):
                let mes = message as! AnalogWriteMessage
                print("Message received \(mes.analogValue)")
            case .failure(let error):
                print("Error 'Out of time' \(error)")
            }
        }
       
         self.outputQueue?.clear()
        
        return
    }
    
    //Останавливает поиск сообщений
    func stop() {
        isWorkerRunning = false
    }
    func resume() {
        isWorkerRunning = true
        self.start()
    }
    
}

