import Foundation
import SwiftUI
import Firebase


import SwiftUI

struct AddView: View {
    @State private var isShowingSolarPanels = false
    @State private var isShowingElectricCars = false
    @State private var isShowingElectricStoves = false
    @State private var isShowingOtherView = false
    
    var body: some View {
        ZStack {
            Color(hex: "9aaee0")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("Do you own and use:")
                        .font(.custom("Avenir", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "1B463C"))
                    Rectangle()
                        .fill(Color(hex: "59DB84"))
                        .frame(height: 550)
                        .cornerRadius(14.0)
                        .shadow(radius: 3, x: 0, y: 3)
                        .padding(.horizontal, 20)
                        .overlay(
                            
                            
                            VStack(alignment: .center) {
                                Spacer().frame(height: 30)
                                
                                Button(action: {
                                    isShowingSolarPanels = true
                                }) {
                                    Text("Solar Panels")
                                        .font(.custom("Avenir", size: 30))
                                        .foregroundColor(Color(hex: "1B463C"))
                                        .fontWeight(.black)
                                        .padding(.leading, 5)
                                    Spacer().frame(width: 10)
                                    Image("solar")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(14.0)
                                        .frame(width: UIScreen.main.bounds.width / 5, height: 135)
                                }
                                .sheet(isPresented: $isShowingSolarPanels) {
                                    SolarPanelView()
                                }
                                
                                Spacer().frame(height: 15)
                                
                                Button(action: {
                                    isShowingElectricCars = true
                                }) {
                                    Text("Electric Cars")
                                        .font(.custom("Avenir", size: 30))
                                        .foregroundColor(Color(hex: "1B463C"))
                                        .fontWeight(.black)
                                        .padding(.leading, 5)
                                    Spacer().frame(width: 10)
                                    Image("car")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(14.0)
                                        .frame(width: UIScreen.main.bounds.width / 5, height: 135)
                                }
                                .sheet(isPresented: $isShowingElectricCars) {
                                    ElectricCarView()
                                }
                                
                                Spacer().frame(height: 15)
                                
                                Button(action: {
                                    isShowingElectricStoves = true
                                }) {
                                    Text("Electric Stoves")
                                        .font(.custom("Avenir", size: 30))
                                        .foregroundColor(Color(hex: "1B463C"))
                                        .fontWeight(.black)
                                        .padding(.leading, 5)
                                    Spacer().frame(width: 10)
                                    Image("stove")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(14.0)
                                        .frame(width: UIScreen.main.bounds.width / 5, height: 135)
                                }
                                .sheet(isPresented: $isShowingElectricStoves) {
                                    ElectricStoveView()
                                }
                                
                                Spacer().frame(height: 15)
                                
                                Button(action: {
                                    isShowingOtherView = true
                                }) {
                                    Text("Other Activity")
                                        .font(.custom("Avenir", size: 30))
                                        .foregroundColor(Color(hex: "1B463C"))
                                        .fontWeight(.black)
                                        .padding(.leading, 5)
                                        
                                }
                                .sheet(isPresented: $isShowingOtherView) {
                                    OtherSustainableView()
                                }
                                
                            }
                        )
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
