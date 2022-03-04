//
//  Message.swift
//  BluetoothExample
//
//  Created by Артур on 3.03.22.
//

import Foundation


protocol TransportObject {
    
    //Конвертирует сообщения в данные
    func getData() -> Data
    
    //Отправляет сигнал по прибытию сообщении
    func finish(with data: Data)
    
}


//Нужно собрать массив байт
class Message<T: NSObject>: TransportObject {
    
    
    private var semaphore = DispatchSemaphore(value: 0)
    
    enum LoadError: Error {
        case outOfTime
    }
    
    var completion: ((T) -> Void)?
   
    //В этом метаде идет отправка результата передачи сигнала, если сработал finish - сигнал передан
    func start() -> Result<Message,Error> {
        let state = semaphore.wait(timeout: .now() + 2 )
        switch state {
        case .success:
            return .success(self)
        case .timedOut:
            return .failure(LoadError.outOfTime)
        }
    }
    
    func getData() -> Data {
        
        return Data()
    }
    
    func finish(with data: Data) {
        self.semaphore.signal()
    }
}

class AnalogWriteMessage: Message<NSObject>{
    
    var analogValue: UInt8
    
    init(value: UInt8) {
        self.analogValue = value
    }
    
//    override func finish(with data: Data) {
//
//    }
//
    override func getData() -> Data {
        let value = Data(bytes: &analogValue, count: MemoryLayout.size(ofValue: analogValue))
        return value
    }
    
}
