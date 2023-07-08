//
//  ElectricStoveView.swift
//  IOS
//
//  Created by Alexander Nanda on 7/2/23.
//

import Foundation
import SwiftUI
import Firebase


struct ElectricStoveView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.custom("Avenir", size: 20))
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                .padding(.top, 20)
                .padding(.trailing, 20)
            }
            
            Spacer()
            
            Text("Electric stove View")
            
            Spacer()
        }
    }
}



struct ElectricStoveView_Previews: PreviewProvider {
    static var previews: some View {
       ElectricStoveView()
    }
}
