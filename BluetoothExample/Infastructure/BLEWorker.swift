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
    private var workerQueue = DispatchQueue(label: "worlerQueue")
    
    //Работает ли проверка
    private var isWorkerRunning: Bool = true
    
    
    weak var delegate: BLEWorkerDelegate!
    
    init(outputQueue: BLEQueueOutput) {
        self.outputQueue = outputQueue
    }
    
    //MARK: Action funcs
    
    //Подключает внешнюю очередь
    public func connect(queue: BLEQueueOutput) {
        //set output queue
        self.outputQueue = queue
    }
    
    //Отправляет данные на утройство
    public func push(data: Data) {
        
    }
    
    //var currentMessage: Message<NSObject>?
    
    //Отключает внешнюю очередь
    public func disconnectQueue() {
        self.outputQueue = nil
    }
    
    //Запускает цикл для проверки на присутствие сообщений
    public func start() {
        workerQueue.async { [weak self] in
            guard let self = self else { return }
            
            while self.isWorkerRunning {
                if let message = self.outputQueue?.pull() {
                    let data = message.getData()
                    //send message
                    //Остановка потока
                    self.delegate.send(data: data)
                    
                    //Ждем когда придет сообщение
                    let result = message.start()
                    switch result {
                    case .success(let message):
                        print(message)
                    case .failure(let error):
                        print("Error 'Out of time' \(error)")
                    }
                }
                Thread.sleep(forTimeInterval: 0.04)
            }
        }
    }
    
    //Останавливает поиск сообщений
    func stop() {
        isWorkerRunning = false
    }
}

