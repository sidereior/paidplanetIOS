import Foundation
import SwiftUI
import Firebase

//todo: make the settings button functional with a logout button



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
        ZStack{
            
        Color(hex: "C9EAD4")
            .ignoresSafeArea()
        
        VStack{
            HStack{
                Text("PaidPlanet")
                    .font(.custom("Avenir", size: 38))
                    .fontWeight(.black)
                    .kerning(0.5)
                    .foregroundColor(Color(hex: "1B463C"))//make this a darker green
                    .padding(.leading, 15)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "person.circle")
                    .font(.title)
                    .padding(.trailing, 15)
                    .foregroundColor(Color(hex: "1b463C")) //make this a darker green
            }
            
            Text(greeting)
                .font(.custom("Avenir", size: 25))
                .font(.title)
                //.fontWeight(.bold)
                .padding(.leading, 15)
            
                .foregroundColor(Color(hex: "1B463C"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Text(Date(), style: .date)
                .font(.custom("Avenir", size: 20))
                .font(.title)
                .padding(.leading, 15)
                .foregroundColor(Color(hex: "1B463C"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer()
                .frame(height: 50)
            
            Rectangle()
                .fill(Color(hex: "1B463C"))
                .frame(width: 360, height: 330)
                .cornerRadius(14.0)
                
            
            Spacer()
            /*p
            
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
             */
            }
        }
    }
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }

}
