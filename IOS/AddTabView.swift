import SwiftUI
import Foundation
import Firebase

struct fortnite: View {
    var body: some View {
        VStack {
            Text("AddTab")
                .font(.title)
                .padding()
            
            Button(action: {
                // Code to handle the first button tap
            
            }) {
                Text("Installed Solar Panels")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button(action: {
                // Code to handle the second button tap
               
            }) {
                Text("Bought electric car")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct addView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
