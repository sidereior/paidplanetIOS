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
        ZStack {
            Color(hex: "C9EAD4")
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    Color.clear // Set the color of the background box if needed
                    
                    VStack {
                        HStack {
                            Text("PaidPlanet")
                                .font(.custom("Avenir", size: 38))
                                .fontWeight(.black)
                                .kerning(0.5)
                                .foregroundColor(Color(hex: "1B463C"))
                                .padding(.leading, 15)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "person.circle")
                                .font(.title)
                                .padding(.trailing, 15)
                                .foregroundColor(Color(hex: "1B463C"))
                        }
                        .padding(.top, 20) // Adjust the top padding to create space from the safe area
                    }
                }
                
                Text(greeting)
                    .font(.custom("Avenir", size: 25))
                    .font(.title)
                    .foregroundColor(Color(hex: "1B463C"))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                
                Text(Date(), style: .date)
                    .font(.custom("Avenir", size: 20))
                    .font(.title)
                    .foregroundColor(Color(hex: "1B463C"))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                
                Spacer()
                    .frame(height: 50) // Adjust the height of the spacer
                
                Rectangle()
                    .fill(Color(hex: "1B463C"))
                    .frame(width: 360, height: 330)
                    .cornerRadius(14.0)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                TabView {
                    HomeTab()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    AddTab()
                        .tabItem {
                            Image(systemName: "plus.circle.fill")
                            Text("Add")
                        }
                    
                    ProfileTab()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .accentColor(Color(hex: "1B463C"))
            }
        }
    }
    
    struct HomeTab: View {
        var body: some View {
            // Home tab content
            Text("Home Tab")
        }
    }
    
    struct AddTab: View {
        var body: some View {
            // Add tab content
            Text("Add Tab")
        }
    }
    
    struct ProfileTab: View {
        var body: some View {
            // Profile tab content
            Text("Profile Tab")
        }
    }
    
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
}
