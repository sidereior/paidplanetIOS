//
//  ContentView.swift
//  IOS
//
//  Created by Alexander Nanda on 5/9/23.
//

import SwiftUI
import AuthenticationServices


struct LoginPage: View {
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            Color(hex: "67C587")
                .ignoresSafeArea()

            VStack(spacing: 20){
                HStack{
                    Text(("Welcome to"))
                        .font(.custom("Avenir", size: 32))
                        .fontWeight(.black)
                        .foregroundColor(Color (hex: "D9D9D9"))
                        .overlay(
                            Text(("Welcome to"))
                                .font(.custom("Avenir", size: 32))
                                .fontWeight(.black)
                                .foregroundColor(.black)
                                .offset(x:1,y:1))
                    Text(("PaidPlanet"))
                        .font(.custom("Avenir-Oblique", size: 32))
                        .fontWeight(.black)
                        .foregroundColor(Color(hex: "1B463C"))
                }
                
                

                TextField("username", text: $username)
                    .padding()
                    .background(Color(hex: "D9D9D9"))
                    .cornerRadius(5.0)
                    .padding(.horizontal, 20)

                SecureField("password", text: $password)
                    .padding()
                    .background(Color(hex: "D9D9D9"))
                    .cornerRadius(5.0)
                    .padding(.horizontal, 20)

                Button(action: {
                    // Perform login action
                }, label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                })
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
