//
//  WelcomeFrameView.swift
//  IOS
//
//  Created by Alexander Nanda on 7/26/23.
// 

import Foundation
import AuthenticationServices
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct WelcomeFrameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.5) // Adjust the opacity as needed for the green tint
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .font(.custom("Avenir", size: 20))
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(7)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                
                Spacer()
                
                Text(("Welcome to"))
                    .font(.custom("Avenir", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: "D9D9D9"))
                    .overlay(
                        Text(("Welcome to"))
                            .font(.custom("Avenir", size: 32))
                            .fontWeight(.black)
                            .foregroundColor(.black)
                            .offset(x: 1, y: 1)
                    )
                Text(("PaidPlanet"))
                    .font(.custom("Avenir-Oblique", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: "1B463C"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // Change the background color to white or any other color you want for the frame
    }
}
