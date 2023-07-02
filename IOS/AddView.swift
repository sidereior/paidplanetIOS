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
                    .frame(height: 275)
                    .cornerRadius(14.0)
                    .shadow(radius: 3, x: 0, y: 3)
                    .padding(.horizontal, 20)
                    .overlay(
                        VStack(alignment: .center) { // Updated alignment to center
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Do you own:")
                                    .font(.custom("Avenir", size: 25))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(hex: "1B463C"))
                            }
                            
                        
                            Spacer()
                                .frame(height: 30)
                            
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Solar Panels")
                                    .font(.custom("Avenir", size: 30))
                                    .foregroundColor(Color(hex: "1B463C"))
                                    .fontWeight(.black)
                                    .padding(.leading, 5)
                            }
                            
                            Image("solar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(14.0)
                                .frame(width: UIScreen.main.bounds.width / 5, height: 135)
                            
                            
                            Spacer()
                                .frame(height: 30)
                            
                            
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Electric Cars")
                                    .font(.custom("Avenir", size: 30))
                                    .foregroundColor(Color(hex: "1B463C"))
                                    .fontWeight(.black)
                                    .padding(.leading, 5)
                            }
                            
                            Image("car")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(14.0)
                                .frame(width: UIScreen.main.bounds.width / 5, height: 135)
                            
                            
                            Spacer()
                                .frame(height: 30)
                            
                            Button(action: {
                                // Handle button tap
                            }) {
                                Text("Electric Stoves")
                                    .font(.custom("Avenir", size: 30))
                                    .foregroundColor(Color(hex: "1B463C"))
                                    .fontWeight(.black)
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
