//
//  ButtonView.swift
//  ElevatorButton
//
//  Created by Samuel Siburian on 08/12/20.
//

import SwiftUI

struct ButtonView: View {
    @EnvironmentObject var bleManager: BLEManager
    @State var floorName:Int
    @State var floorNameDisplay: String
    
    var body: some View {
        Button(action: {
            // Only do action when "floor" button state is not chosen
            if !bleManager.elevatorChosenFloor[floorName] {
                bleManager.setFloor(floor: floorName)
            }
        }, label: {
            if bleManager.elevatorChosenFloor[floorName] {
                Text(floorNameDisplay)
                    .font(.system(size: 50))
                    .padding()
                    .frame(width: 115.0, height: 104.0)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.45), radius: 5, x: 0, y: 4)
            } else {
                Text(floorNameDisplay)
                    .font(.system(size: 50))
                    .padding()
                    .frame(width: 115.0, height: 104.0)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                    .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.35), radius: 5, x: 0, y: 4)
            }
            
        })
    }
}

//struct ButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ButtonView(floorName: 2, floorNameDisplay: "2")
//        }
//    }
//}

