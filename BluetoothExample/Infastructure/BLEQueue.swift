//
//  BLEQueue.swift
//  BluetoothExample
//
//  Created by Артур on 3.03.22.
//

import Foundation

//Добавляет сообщения в очередь на отправку
protocol BLEQueueInput {
    func add(message: Message<NSObject>)
}

//Запрашивает данные на отправку (data)
protocol BLEQueueOutput {
    func pull() -> Message<NSObject>?
}

protocol BLEQueue: BLEQueueInput, BLEQueueOutput {}

//MARK: Находить в себе сообщения, управляет приоритетами, решает что отдать воркеру
class BLEQueueImpl: BLEQueue {
    
    //сделать массивом сообщений
    private var message: [Message<NSObject>]?
    
    func add(message: Message<NSObject>) {
        self.message?.append(message)
    }
    
    //Возвращает сообщение для воркера
    func pull() -> Message<NSObject>? {
        return self.message?.first
    }
    
}
