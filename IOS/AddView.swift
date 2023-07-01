//
//  AddView.swift
//  IOS
//
//  Created by Alexander Nanda on 7/1/23.
//

import Foundation
import SwiftUI
import Firebase



struct AddView: View {
    var body: some View {
        ZStack {
            Color(hex: "C9EAD4")
                .ignoresSafeArea()
            
            VStack{
                Rectangle()
                    .fill(Color(hex: "67C587"))
                    .frame(height: 85)
                    .cornerRadius(14.0)
                    .shadow(radius: 3, x: 0, y: 3)
                    .padding(.horizontal, 15)
                    .overlay(
                        VStack(alignment: .center) { // Updated alignment to center
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Have you recently")
                                    .font(.custom("Avenir", size: 25))
                                    .fontWeight(.black)
                                    .foregroundColor(Color(hex: "1B463C"))
                            }
                            
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Solar Panels ICON")
                                    .font(.custom("Avenir", size: 20))
                                    .foregroundColor(Color(hex: "1B463C"))
                                    .padding(.leading, 5)
                            }
                            
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Electric Cars ICON")
                                    .font(.custom("Avenir", size: 20))
                                    .foregroundColor(Color(hex: "1B463C"))
                                    .padding(.leading, 5)
                            }
                            
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Electric Stoves ICON")
                                    .font(.custom("Avenir", size: 20))
                                    .foregroundColor(Color(hex: "1B463C"))
                                    .padding(.leading, 5)
                            }
                        }
                    )
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
