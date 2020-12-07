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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

