//
//  BLEManager.swift
//  ElevatorButton
//
//  Created by Samuel Siburian on 07/12/20.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    var myCentral: CBCentralManager!
    var myPeripheral: CBPeripheral!
    var myCharacteristic: CBCharacteristic!
    
    var isSwitchedOn = false
    
    let targetServiceUUID = CBUUID(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    let tagetCharacteristic = CBUUID(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    
    @Published var elevatorCurrentFloor: UInt8 = 0
    @Published var elevatorChosenFloor: [Bool] = [false, false, false , false]
    var chosenFloor: UInt8 = 0
    
    override init() {
        super.init()
        
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
            self.startScanning()
        } else {
            isSwitchedOn = false
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        print(RSSI.stringValue)

        // To find range, use this formula -> 10 ^ ((-69 - (RSSI_VALUE))/(10 * 3))
        // Reference: https://dzone.com/articles/formula-to-convert-the-rssi-value-of-the-ble-bluet
        // Device txPower is 3dbm
        if (RSSI.intValue < 80) { // 80 is around 2.3 meters
            self.stopScanning()
            myPeripheral = peripheral
            myPeripheral.delegate = self
            myCentral.connect(myPeripheral, options: nil)
        } else {
            print("Too far from device")
            // TODO: popup
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Device connected")
        myPeripheral.discoverServices([targetServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected, start scanning")
        self.startScanning()
    }
    
    func startScanning() {
        print("Start scanning...")

        if !myCentral.isScanning && self.isSwitchedOn {
            myCentral.scanForPeripherals(withServices: [targetServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }
    
    func stopScanning() {
        print("Stopping scan")
        myCentral.stopScan()
    }
}

extension BLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        if services.count > 0 {
            peripheral.discoverCharacteristics([tagetCharacteristic], for: services[0])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(error ?? "[DiscoverService] No error")
        guard let characteristics = service.characteristics else { return }
        
        if characteristics.count > 0 {
            myCharacteristic = characteristics[0]
            
            if myCharacteristic.properties.contains(.notify) {
                print("\(myCharacteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: myCharacteristic)
            }
            if myCharacteristic.properties.contains(.write) {
                print("\(myCharacteristic.uuid): properties contains .write")
//                self.setFloor(floor: Int(elevatorCurrentFloor))
            }
        }
    }
    
    func setFloor(floor: Int) {
        if myPeripheral.state != .connected {
            print("Can't write to peripheral, not connected")
            return
        }
        
        var rawData = UInt8(floor)
        //        var data = Data(bytesNoCopy: &rawData, count: MemoryLayout.size(ofValue: rawData), deallocator: )
        let data = Data(bytes: &rawData, count: MemoryLayout.size(ofValue: rawData))
        myPeripheral.writeValue(data, for: myCharacteristic, type: .withResponse)
    }
    
    // Callback of NOTIFY characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
            case tagetCharacteristic:
                self.extractNotifyData(from: characteristic)
            default:
              print("Unhandled Characteristic UUID: \(characteristic.uuid)")
          }
    }
    
    // Callback of WRITE characteristic
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(error ?? "[WriteCharacteristic] No error")
    }
    
    // Helper function to extract notify data
    func extractNotifyData(from characteristic: CBCharacteristic) {
        guard let charaData = characteristic.value else {
            print("Error extract notify data!!")
            return
        }
        let data = [UInt8](charaData)
        
        // Sanity check
        if data.capacity > 1 {
            // To make sure only update when the values is changing
            // So view not continuously update
            if data[0] != elevatorCurrentFloor {
                elevatorCurrentFloor = data[0]
                print("Current floor: \(elevatorCurrentFloor)")
            }
            
            if data[1] != chosenFloor {
                chosenFloor = data[1]
//                elevatorChosenFloor = data[1]
                elevatorChosenFloor = Converter.floor(val: chosenFloor, length: 4)
                print("Chosen floor: \(elevatorChosenFloor)")
            }
        }
    }
}
