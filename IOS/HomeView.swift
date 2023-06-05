import Foundation
import SwiftUI
import Firebase

//todo: make the settings button functional with a logout button

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "C9EAD4"))
                .frame(height: 1)
            
            TabView {
                HomeTab()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                AddTab()
                    .tabItem {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                            Text("Add")
                                .foregroundColor(.white)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "1B463C"))
                            .frame(height: 60)
                            .padding(.horizontal)
                    )
                
                ProfileTab()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                
            }
            .accentColor(Color(hex: "1B463C"))
        }
        .background(Color(hex: "C9EAD4"))
        .ignoresSafeArea(edges: .bottom)
    }
}

struct HomeTab: View {
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
                    Color(hex: "C9EAD4")
                    VStack {
                        HStack {
                            Text("PaidPlanet")
                                .font(.custom("Avenir", size: 38))
                                .fontWeight(.black)
                                .kerning(0.5)
                                .foregroundColor(Color(hex: "1B463C"))
                                .padding(.leading, 12)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "person.circle")
                                .font(.title)
                                .padding(.trailing, 15)
                                .foregroundColor(Color(hex: "1B463C"))
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
                        
                        Rectangle()
                            .fill(Color(hex: "1B463C"))
                            .frame(width: 360, height: 330)
                            .cornerRadius(14.0)
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text("Recent Transactions")
                                        .font(.custom("Avenir", size: 35))
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding(.top, 5)
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(height: 2)
                                        .padding(.horizontal, 15)
                                    
                                    
                               
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        TransactionBox(date: "5/27/23", status: "Completed", amount: "approx. $50.23")
                                        TransactionBox(date: "5/20/23", status: "Complete", amount: "approx. $35.23")
                                        TransactionBox(date: "5/26/23", status: "Pending", amount: "approx. $30.34")
                                    }
                                    .padding(.horizontal, 15)
                                    .padding(.top, 5)
                                    Spacer(minLength: 0)
                                }
                            )
                        
                        Spacer(minLength: 0)
                    }
                }
                
                // Divider
                Color.white
                    .frame(height: 1)
            }
        }
    }
}

struct TransactionBox: View {
    var date: String
    var status: String
    var amount: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(date)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(status)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(amount)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
        }
    }
}

struct AddTab: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Add Tab")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct ProfileTab: View {
    var body: some View {
        Text("Profile Tab")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
