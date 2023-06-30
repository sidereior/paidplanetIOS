import Foundation
import SwiftUI
import Firebase


//todo: make the settings button functional with a logout button

import Foundation
import CITTopTabBar
import SwiftUI
struct HomeView: View {
    @State var selectedTab: Int = 0
    @State var tabs: [CITTopTab] = [
        .init(
            title: "Home" ,
            icon: .init(systemName: "house.fill"),
            iconColorOverride: Color(hex: "1B463C"),
            selectedIconColorOverride: Color(hex: "67C587")
        ),
        .init(
            title: "Scan" ,
            icon: .init(systemName: "camera.viewfinder"),
            iconColorOverride: Color(hex: "1B463C"),
            selectedIconColorOverride: Color(hex: "67C587")
        ),
        .init(
            title: "Transactions",
            icon: .init(systemName: "archivebox.fill"),
            iconColorOverride: Color(hex: "1B463C"),
            selectedIconColorOverride: Color(hex: "67C587")
        ),
        .init(
            title: "Profile",
            icon: .init(systemName: "person.crop.square.fill"),
            iconColorOverride: Color(hex: "1B463C"),
            selectedIconColorOverride: Color(hex: "67C587")
        )
    ]

    var config: CITTopTabBarView.Configuration {
        var example: CITTopTabBarView.Configuration = .exampleUnderlined
        example.textColor = Color(hex: "1B463C")
        example.backgroundColor = Color.white.opacity(0.0)
        example.underlineColor = Color(hex: "67C587")
        example.selectedTextColor = Color(hex: "67C587")
        example.selectedIconColor = Color(hex: "67C587")
        example.font = Font.custom("Avenir", size: 16).bold()
        example.iconSize = CGSize(width: 30, height: 30)
        example.showUnderline = true
        example.showBorderWhileUnselected = false
        example.selectedInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 0)
        example.underlineHeight = 3
        
        return example
    }


    var body: some View {
        VStack {
            CITTopTabBarView(selectedTab: $selectedTab, tabs: $tabs, config: config)

            TabView(selection: $selectedTab) {
                            HomeTab()
                                .tag(0)

                            AddView()
                                .tag(1)

                            TransactionsView()
                                .tag(2)

                            ProfileView()
                                .tag(3)
                        }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
        }
        .background( Color(hex: "C9EAD4"))
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
    }
}

struct TransactionsView: View {
    var body: some View {
        Text("Transactions View")
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
                        Text(greeting)
                            .font(.custom("Avenir", size: 25) .bold())
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
                        
                        
                        //recent transaction view
                        Rectangle()
                            .fill(Color(hex: "1B463C"))
                            .frame( height: 265)
                            .cornerRadius(14.0)
                            .padding(.horizontal)
                            .overlay(
                                VStack() {
                                    
                                        Text("Recent Transactions")
                                            .font(.custom("Avenir", size: 35))
                                            .font(.title)
                                            .fontWeight(.black)
                                            .foregroundColor(.white)
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                    
                                    
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(height: 2)
                                        .padding(.horizontal, 35)
                                        .padding(.top, -25)
                                
                                    
                                    VStack(alignment: .leading, spacing: 10) {
                                        //change these later to recent transaction view
                                        TransactionBox(date: "5/27/23", status: "Completed", amount: "approx. $50.23")
                                        TransactionBox(date: "5/20/23", status: "Completed", amount: "approx. $35.23")
                                        TransactionBox(date: "5/26/23", status: "Pending", amount: "approx. $30.34")
                                    }
                                    .padding(.horizontal, 35)
                                    .padding(.top, -20)
                                    
                                    
                                    RoundedRectangle(cornerRadius: 14)
                                            .fill(Color.white)
                                            .frame(height: 35)
                                            .overlay(
                                                    VStack(alignment: .leading) {
                                                        Text("View All Transactions")
                                                    .font(.custom("Avenir", size: 23))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color(hex: "1B463C"))
                                                    .padding(.top, 11)
                                                    .padding(.leading, 25)
                                                                                   
                                                    Spacer()
                                                        }
                                                        )
                                            .padding(.horizontal, 35)
                                                            
                                }
                            )
                        
                        Spacer()
                            .frame(height: 15)
                        
                       
                        Rectangle()
                            .fill(Color(hex: "67C587"))
                            .frame(height: 85)
                            .cornerRadius(14.0)
                            .padding(.horizontal, 15)
                            .overlay(
                                VStack(alignment: .center) { // Updated alignment to center
                                    Button(action: {
                                        // Handle button tap
                                    }) {
                                        Text("Need Help with PaidPlanet?")
                                            .font(.custom("Avenir", size: 25))
                                            .fontWeight(.black)
                                            .foregroundColor(Color(hex: "1B463C"))
                                    }
                                    
                                    Button(action: {
                                        // Handle button tap
                                    }) {
                                        Text("Learn more here.")
                                            .font(.custom("Avenir", size: 20))
                                            .foregroundColor(Color(hex: "1B463C"))
                                            .padding(.leading, 5)
                                    }
                                }
                            )

                        

                        Spacer().frame(height: 15)
                        
                         
                        Rectangle()
                            .fill(Color(hex: "67C587"))
                            .frame(height: 210)
                            .cornerRadius(14.0)
                            .padding(.horizontal, 15)
                            .overlay(
                                VStack(spacing: 10) {
                                    Text("Our Sponsors:")
                                        .font(.custom("Avenir", size: 25))
                                        .fontWeight(.black)
                                        .foregroundColor(Color(hex: "1B463C"))
                                    
                                    HStack(spacing: 10) {
                                        Image("VCSSymbol")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(14.0)
                                            .frame(width: UIScreen.main.bounds.width / 3 - 30, height: 135)
                                        Image("GM")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(14.0)
                                            .frame(width: UIScreen.main.bounds.width / 3 - 30, height: 135)
                                        Image("tesla-motors")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .cornerRadius(14.0)
                                            .frame(width: UIScreen.main.bounds.width / 3 - 30, height: 135)
                                            
                                
                                    }
                                }
                                .padding(.horizontal, 15)
                            )

                        

                        Spacer(minLength: 0)
                        
                        
                    }
                }
                // todo fix divider later
                //make it so that the taskbar at the bottom has the add tab standout
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
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(status)
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(amount)
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
        }
    }
}

struct AddView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Add Tab")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .background(Color.white) // Add a background color to make the tab visible
    }
}


struct ProfileView: View {
    var body: some View {
        Text("Profile Tab")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CenterTabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
            
            Text("Add")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "1B463C"))
                .frame(height: 60)
                .padding(.horizontal)
        )
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
