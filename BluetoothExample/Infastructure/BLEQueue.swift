//
//  BLEQueue.swift
//  BluetoothExample
//
//  Created by Артур on 3.03.22.
//

import Foundation
//MARK: Класс отвечает за формирование сообщений на отправку, так же регулирует последовательность
/*
 Сообщение дальше идет в BLEWorker, где запускается метод Start
 */

//Добавляет сообщения в очередь на отправку
protocol BLEQueueInput {
    func add(message: Message<NSObject>)
}

//Запрашивает данные на отправку (data)
protocol BLEQueueOutput {
    func pull() -> [Message<NSObject>]?
    func clear()
}

protocol BLEQueue: BLEQueueInput, BLEQueueOutput {}

//MARK: Находить в себе сообщения, управляет приоритетами, решает что отдать воркеру
class BLEQueueImpl: BLEQueue {
    func clear() {
        print("Clear message")
        self.message = nil
    }
    
    //сделать массивом сообщений
    private var message: [Message<NSObject>]?
    
    
    func add(message: Message<NSObject>) {
        self.message = [message]
    }
    
    //Возвращает сообщение для воркера
    func pull() -> [Message<NSObject>]? {
        guard let message = message else {
            return nil
        }

        return message
    }
    
}
