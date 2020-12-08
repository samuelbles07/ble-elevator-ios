//
//  ContentView.swift
//  ElevatorButton
//
//  Created by Samuel Siburian on 07/12/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    var body: some View {
        VStack (spacing: 10) {
            VStack {
                Text("LANTAI SAAT INI")
                    .fontWeight(.regular)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.all)
                        
                if bleManager.elevatorCurrentFloor == 0 {
                    Text("G")
                        .fontWeight(.bold)
                        .font(.system(size: 80))
                        .foregroundColor(Color.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Text(String(bleManager.elevatorCurrentFloor))
                        .fontWeight(.bold)
                        .font(.system(size: 80))
                        .foregroundColor(Color.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                    

            }
            .padding(.bottom)
            
            VStack {
                Text("LANTAI DIPILIH")
                    .fontWeight(.regular)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.all)
                
                HStack {
                    ButtonView(floorName: 0, floorNameDisplay: "G")
                        .padding(.trailing, 20.0)

                    ButtonView(floorName: 1, floorNameDisplay: "1")
                        .padding(.leading, 20.0)
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                HStack {
                    ButtonView(floorName: 2, floorNameDisplay: "2")
                        .padding(.trailing, 20.0)

                    ButtonView(floorName: 3, floorNameDisplay: "3")
                        .padding(.leading, 20.0)
                }
                .frame(maxWidth: .infinity)
                .padding()
 
            }
            .padding(.top)
            
            Spacer()

            updateStatusDisplay(status: bleManager.appStatus)
                .fontWeight(.medium)
                .foregroundColor(.green)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.leading, .bottom, .trailing])
                
                
//            Spacer()
        }
    }
    
    private func updateStatusDisplay(status: BLEManager.AppStatusType) -> Text {
        var statusText = ""
        switch status {
        case .btOff:
            statusText = "Bluetooth offline, please turn on"
        case .notFound:
            statusText = "Device not found"
        case .found:
            statusText = "Device found, come closer to device"
        case .connected:
            statusText = "Connected to device, choose your destination floor"
        }
        
        return Text(statusText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(BLEManager())
        }
    }
}

