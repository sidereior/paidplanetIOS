import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import CITTopTabBar

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
            title: "Cashbacks",
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
        .background(Color(hex: "C9EAD4"))
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.all)
    }
}

struct HomeTab: View {
    @State private var userName: String = ""
    @State private var showSolarPanelView = false
    @State private var showElectricCarView = false
    @State private var showElectricStoveView = false
    @State private var transactions: [Transaction] = []

    private func fetchTransactions() {
        let db = Firestore.firestore()
        db.collection("transactions")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                transactions = documents.compactMap { document in
                    do {
                        return try document.data(as: Transaction.self)
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
    
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
    
    private func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
      
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let userName = document.data()?["name"] as? String {
                    self.userName = userName
                }
            } else {
                print("User document does not exist")
            }
        }
    }
    
    var body: some View {

        if showSolarPanelView {
                    SolarPanelView()
                }
                
                if showElectricCarView {
                    ElectricCarView()
                }
                
                if showElectricStoveView {
                    ElectricStoveView()
                }
        
        ZStack {
            Color(hex: "C9EAD4")
                .ignoresSafeArea()
           
            ScrollView
            {
                
                VStack {
                    
                    ZStack {
                        Color(hex: "C9EAD4")
                        VStack {
                            Text(greeting + ", \(userName)")
                                .font(.custom("Avenir", size: 25) .bold())
                                .font(.title)
                                .foregroundColor(Color(hex: "1B463C"))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 15)
                            
                            Spacer()
                                .frame(height: 3)
                            
                            Text(Date(), style: .date)
                                .font(.custom("Avenir", size: 20))
                                .font(.title)
                                .foregroundColor(Color(hex: "1B463C"))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 15)
                            
                            Spacer()
                                .frame(height: 30)
                            
                            Text("Do you own and use:")
                                .font(.custom("Avenir", size: 20))
                                .font(.title)
                                .foregroundColor(Color(hex: "1B463C"))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 15)
                            
                            VStack(alignment: .center) {
                                HStack {
                                    Button(action: {
                                        showSolarPanelView.toggle()
                                    }) {
                                        Text("Solar Panels")
                                            .font(.custom("Avenir", size: 15))
                                            .foregroundColor(Color(hex: "1B463C"))
                                            .fontWeight(.black)
                                            .padding(.leading, 5)
                                    }
                                    .frame(height: 35)
                                    .padding(.horizontal, 7)
                                    .background(Color(hex: "59DB84"))
                                    .cornerRadius(14.0)
                                    .shadow(radius: 3, x: 0, y: 3)
                                    .sheet(isPresented: $showSolarPanelView) {
                                        SolarPanelView()
                                    }
                                    
                                    Button(action: {
                                        showElectricCarView.toggle()
                                    }) {
                                        Text("Electric Cars")
                                            .font(.custom("Avenir", size: 15))
                                            .foregroundColor(Color(hex: "1B463C"))
                                            .fontWeight(.black)
                                            .padding(.leading, 5)
                                    }
                                    .frame(height: 35)
                                    .padding(.horizontal, 7)
                                    .background(Color(hex: "59DB84"))
                                    .cornerRadius(14.0)
                                    .shadow(radius: 3, x: 0, y: 3)
                                    .sheet(isPresented: $showElectricCarView) {
                                        ElectricCarView()
                                    }
                                    
                                    
                                    Button(action: {
                                        showElectricStoveView.toggle()
                                    }) {
                                        Text("Electric Stoves")
                                            .font(.custom("Avenir", size: 15))
                                            .foregroundColor(Color(hex: "1B463C"))
                                            .fontWeight(.black)
                                            .padding(.leading, 5)
                                    }
                                    .padding(.horizontal, 7)
                                    .frame(height: 35)
                                    .background(Color(hex: "59DB84"))
                                    .cornerRadius(14.0)
                                    .shadow(radius: 3, x: 0, y: 3)
                                    .sheet(isPresented: $showElectricStoveView) {
                                        ElectricStoveView()
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                                                        .padding(.top, -10)
                            Group{
                                Spacer()
                                    .frame(height: 15)
                            }

                            Group {
                                //recent transaction view
                                Rectangle()
                                    .fill(Color(hex: "1B463C"))
                                    .frame(height: 265)
                                    .cornerRadius(14.0)
                                    .padding(.horizontal)
                                    .shadow(radius: 3, x: 0, y: 3)
                                    .overlay(
                                        VStack() {
                                            Text("Recent Cashbacks")
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

                                            VStack {
                                                List(transactions) { transaction in
                                                    VStack(alignment: .leading) {

                                                        Text("Transaction Date: \(transaction.transactionDate)")
                                                            .font(.subheadline)

                                                        Text("Progress: \(transaction.progress)")
                                                            .font(.subheadline)
                                                    }
                                                    .listRowBackground(Color(hex: "1B463C"))
                                                }
                                                .listStyle(PlainListStyle())
                                            }
                                            .padding(.horizontal, 35)
                                            .padding(.top, -20)
            
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color.white)
                                                .frame(height: 35)
                                                .overlay(
                                                    VStack(alignment: .leading) {
                                                        Text("View All Cashbacks")
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
                                    .frame(height: 30)
                                
                                Rectangle()
                                    .fill(Color(hex: "67C587"))
                                    .frame(height: 210)
                                    .cornerRadius(14.0)
                                    .shadow(radius: 3, x: 0, y: 3)
                                    .padding(.horizontal, 15)
                                    .overlay(
                                        VStack(spacing: 10) {
                                            Text("Our Sponsors:")
                                                .font(.custom("Avenir", size: 25))
                                                .fontWeight(.black)
                                                .foregroundColor(Color(hex: "1B463C"))
                                            
                                            HStack(spacing: 10) {
                                                
                                                Image("tesla-motors")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(14.0)
                                                    .frame(width: UIScreen.main.bounds.width / 3 - 30, height: 135)
                                                
                                                Image("oneshot")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(14.0)
                                                    .frame(width: UIScreen.main.bounds.width / 3 - 30, height: 135)
                                                Image("GM")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .cornerRadius(14.0)
                                                    .frame(width: UIScreen.main.bounds.width / 3 - 30, height: 135)
                                                
                                            }
                                        }
                                            .padding(.horizontal, 15)
                                    )
                    
                                Spacer()
                                    .frame(height: 30)
                                
                                Rectangle()
                                    .fill(Color(hex: "67C587"))
                                    .frame(height: 85)
                                    .cornerRadius(14.0)
                                    .shadow(radius: 3, x: 0, y: 3)
                                    .padding(.horizontal, 15)
                                    .overlay(
                                        VStack() {
                                            Button(action: {
                                                // Handle button tap
                                            }) {
                                                Text("Need Help with PaidPlanet?")
                                                    .font(.custom("Avenir", size: 25))
                                                    .fontWeight(.black)
                                                    .foregroundColor(Color(hex: "1B463C"))
                                                    .frame(alignment: .center)
                                            }
                                            
                                            Button(action: {
                                                // Handle button tap
                                            }) {
                                                Text("Learn more here.")
                                                    .font(.custom("Avenir", size: 20))
                                                    .foregroundColor(Color(hex: "1B463C"))
                                                    .padding(.leading, 10)
                                            }
                                        }
                                    )
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            fetchUserName()
            fetchTransactions()
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
