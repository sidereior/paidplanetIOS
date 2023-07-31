import Foundation
import SwiftUI
import Firebase


struct RedeemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(hex: "1B463C")
                .ignoresSafeArea()
            
            VStack {
                Text("This is the Redeem View")
                    .font(.custom("Avenir", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dismiss")
                        .font(.custom("Avenir", size: 20))
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(14)
                }
            }
        }
    }
}
