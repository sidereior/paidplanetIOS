import Foundation
import SwiftUI
import Firebase

struct HomeView: View {
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        if (6..<12).contains(hour) {
            return "Good Morning"
        } else if (12..<18).contains(hour) {
            return "Good Afternoon"
        } else {
            return "Good Evening"
        }
    }
    
    
    var body: some View {
        VStack {
            HStack{
                Text("PaidPlanet")
                    .font(.custom("Avenir", size: 32))
                    .fontWeight(.black)
                    .kerning(0.5)
                    .foregroundColor(Color(hex: "1B463C"))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "gear")
                    .font(.title)
                    .foregroundColor(Color(hex: "1b463C"))
            }
            
            
            Text(greeting)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            
            Button(action: {
                // Action when the button is tapped
            }) {
                Text("Logout")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(hex: "C9EAD4").ignoresSafeArea())
    }
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }

}
