//
//  Converter.swift
//  ElevatorButton
//
//  Created by Samuel Siburian on 08/12/20.
//

import Foundation

class Converter {
    static func floor(val value: UInt8, length len: Int) -> [Bool] {
        let data = Converter.toBinary(val: value)
        var tmp = [Bool]()

        for idx in 0..<len {
            if data[idx] == 1 {
                tmp.append(true)
            } else {
                tmp.append(false)
            }
        }

        return tmp
    }

    static func toBinary(val value: UInt8) -> [Int] {
        var byte = value
        var bits = [Int](repeating: .zero, count: 8)
        for i in 0..<8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = 1
            }

            byte >>= 1
        }
        print(bits)
        return bits
    }
}
