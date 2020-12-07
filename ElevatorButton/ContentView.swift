//
//  ContentView.swift
//  ElevatorButton
//
//  Created by Samuel Siburian on 07/12/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        VStack (spacing: 10) {
         
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(String(bleManager.elevatorCurrentFloor))

            Spacer()

            Text("STATUS")
                .font(.headline)
            
            if bleManager.isSwitchedOn {
                Text("Bluetooth is switch on")
                    .foregroundColor(.green)
            }
            else {
                Text("Bluetooth is switch off")
                    .foregroundColor(.red)
            }

            Spacer()

            HStack {
                VStack (spacing: 10) {
                    Button(action: {
                        self.bleManager.startScanning()
                    }) {
                        Text("Start Scanning")
                    }
                    Button(action: {
                        self.bleManager.stopScanning()
                    }) {
                        Text("Stop Scanning")
                    }
                    
                    Button(action: {
                        self.bleManager.setFloor(floor: 2)
                    }) {
                        Text("SSet floor")
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

