import Foundation
import SwiftUI
import Firebase

struct AddView: View {
    @State private var isShowingSolarPanels = false
    @State private var isShowingElectricCars = false
    @State private var isShowingElectricStoves = false
    @State private var isShowingOtherView = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("Do you own and use:")
                        .font(.custom("Avenir", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "00653B"))
                    
                    VStack {
                        Button(action: {
                            isShowingSolarPanels = true
                        }) {
                            HStack{
                                Text("Solar Panels")
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(Color(hex: "C3E8AC"))
                                Spacer()
                                Image("solar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(14.0)
                                    .frame(width: UIScreen.main.bounds.width / 5, height: 100)
                                    .colorMultiply(Color(hex: "00653B"))
                                    .colorInvert()
                            }
                            .padding(.horizontal, 10)

                        }
                        .sheet(isPresented: $isShowingSolarPanels) {
                            SolarPanelView()
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "00653B"))
                            .shadow(radius: 3, x: 0, y: 3)
                    )
                    
                    VStack {
                        Button(action: {
                            isShowingElectricCars = true
                        }) {
                            HStack{
                                Text("Electric Cars")
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(Color(hex: "C3E8AC"))
                                Spacer()
                                Image("car")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(14.0)
                                    .frame(width: UIScreen.main.bounds.width / 5, height: 100)
                                    .colorMultiply(Color(hex: "00653B"))
                                    .colorInvert()
                            }
                            .padding(.horizontal, 10)
                        }
                        .sheet(isPresented: $isShowingElectricCars) {
                            ElectricCarView()
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "00653B"))
                            .shadow(radius: 3, x: 0, y: 3)
                    )
                    
                    VStack {
                        Button(action: {
                            isShowingElectricStoves = true
                        }) {
                            HStack{
                                Text("Electric Stoves")
                                    .font(.title)
                                    .fontWeight(.black)
                                    .foregroundColor(Color(hex: "C3E8AC"))
                                Spacer()
                                Image("stove")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(14.0)
                                    .frame(width: UIScreen.main.bounds.width / 5, height: 100)
                                    .colorMultiply(Color(hex: "00653B"))
                                    .colorInvert()
                            }
                            .padding(.horizontal, 10)
                            }
                        .sheet(isPresented: $isShowingElectricStoves) {
                            ElectricStoveView()
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "00653B"))
                            .shadow(radius: 3, x: 0, y: 3)
                    )
                    
                    VStack {
                        Button(action: {
                            isShowingOtherView = true
                        }) {
                            Text("Other Activity")
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(Color(hex: "C3E8AC"))
                        }
                        .sheet(isPresented: $isShowingOtherView) {
                            OtherSustainableView()
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "00653B"))
                            .shadow(radius: 3, x: 0, y: 3)
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
