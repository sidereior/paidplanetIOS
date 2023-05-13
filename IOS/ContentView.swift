//
//  ContentView.swift
//  IOS
//
//  Created by Alexander Nanda on 5/9/23.
//

import SwiftUI
import AuthenticationServices
import Firebase


struct LoginPage: View {
    
    @State private var email = ""
    @State private var password = ""
    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
                
        }
    }

    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
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
                }.padding(.top, 250)
                
                
                
                

                TextField("email", text: $email)
                    .padding(.horizontal, 15)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .background(Color(hex: "D9D9D9"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 25)
                    .font(.custom("Avenir", size: 20))

                SecureField("password", text: $password)
                    .padding(.horizontal, 15)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .background(Color(hex: "D9D9D9"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 25)
                    .font(.custom("Avenir", size: 20))

                Spacer()
                
                Button(action: {
                    loginUser()
                }, label: {
                    Text("login")
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color (hex: "D9D9D9"))
                        .frame(width: 220, height: 60)
                        .background(Color(hex: "1B463C"))
                        .cornerRadius(14.0)
                        .padding(.bottom, 50)
                })
                Button(action: {
                    registerUser()
                }, label: {
                    Text(("New to PaidPlanet? Sign up here"))
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.black)
                        .foregroundColor(Color (hex: "D9D9D9"))
                        .overlay(
                            Text(("New to PaidPlanet? Sign up here"))
                                .font(.custom("Avenir", size: 20))
                                .fontWeight(.black)
                                .foregroundColor(.black)
                                .offset(x:1,y:1))
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color (hex: "D9D9D9"))
                        .cornerRadius(14.0)
                        .padding(.bottom, 50)
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
