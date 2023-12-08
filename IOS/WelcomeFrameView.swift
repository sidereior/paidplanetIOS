import SwiftUI

struct WelcomeFrameView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentCarMPG: Double = 25
    @State private var currentDriveEst: Double = 1000
    @State private var carbonCreditPrice: Double = 20
    @State private var fee: Double = 0.1
    @State private var emissionsEstimate: Double = 0
    @State private var carbonCreditPayout: Double = 0
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Color(hex: "F2E8CF")
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    if selectedTab == 3 {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Exit")
                                .font(.custom("Avenir", size: 20))
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .padding()
                                .background(Color(hex: "C3E8AC"))
                                .cornerRadius(14)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                        .transition(.opacity)
                    }
                }

                TabView(selection: $selectedTab) {
                    Text("Welcome to PaidPlanet, the first app that pays you for being sustainable.")
                        .font(.custom("Avenir", size: 25))
                                .fontWeight(.black)
                                .foregroundColor(Color(hex: "00653B"))
                                .padding(.horizontal, 35)
                                .padding(.top, 15)
                    

                        .tag(0)
                    Text("How We Work")
                        .tag(1)
                    Text("home screen/Payment")
                        .tag(2)
                    calculatorView
                        .tag(3)
                                    }
                .tabViewStyle(.page)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea()
    }

    var calculatorView: some View {
        VStack {
            Slider(value: $currentCarMPG, in: 10...100, step: 1)
                .accentColor(Color(hex: "00653B"))
            Text("Current Car MPG: \(Int(currentCarMPG))")

            Slider(value: $currentDriveEst, in: 100...300000, step: 100)
                .accentColor(Color(hex: "00653B"))
            Text("Current Drive Estimate (miles): \(Int(currentDriveEst))")

            Slider(value: $carbonCreditPrice, in: 0...100, step: 1)
                .accentColor(Color(hex: "00653B"))
            Text("Carbon Credit Price: $\(Int(carbonCreditPrice))")

            Slider(value: $fee, in: 0...1, step: 0.01)
                .accentColor(Color(hex: "00653B"))
            Text("Fee: \(fee, specifier: "%.2f")")

            Button(action: {
                let result = electricCars(currentCarMPG: Int(currentCarMPG),
                                          currentDriveEst: Int(currentDriveEst),
                                          carbonCreditPrice: Int(carbonCreditPrice),
                                          fee: fee)
                emissionsEstimate = result.currentEmissionsEstimate
                carbonCreditPayout = result.carbonCreditPayout
            }) {
                Text("Calculate")
            }
           
            VStack{
                Text("Emissions Estimate: \(emissionsEstimate, specifier: "%.2f") lbs")
                Text("Carbon Credit Payout: \(carbonCreditPayout, specifier: "%.2f") dollars")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }

    func electricCars(currentCarMPG: Int, currentDriveEst: Int, carbonCreditPrice: Int, fee: Double) -> (currentEmissionsEstimate: Double, carbonCreditPayout: Double) {
        let gallonsGasConsumed = Double(currentDriveEst) / Double(currentCarMPG)
        let co2Gallon = 8887.0
        let currentEmissionsEstimate = gallonsGasConsumed * co2Gallon
        let currentEmissionsInMetricTonnes = currentEmissionsEstimate / 1_000_000.0
        let carbonCreditPayout = currentEmissionsInMetricTonnes * Double(carbonCreditPrice) * (1 - fee)
        
        return (currentEmissionsEstimate, carbonCreditPayout)
    }

    func newSolarPanels(currentEnergyBill: Int, state: String, roofSizeEstimate: Double, carbonCreditPrice: Double, fee: Double) -> (currentEmissionsEstimate: Double, carbonCreditPayout: Double) {
        let currentEnergyBillInKWh = Double(currentEnergyBill) / 1000.0
        let solarPanelWattsPerHour = 325.0
        let peaksunhoursDict: [String: Int] = [
            "alabama": 4,
            "alaska": 4,
            "arizona": 7,
            "arkansas": 4,
            "california": 6,
            "colorado": 5,
            "connecticut": 4,
            "delaware": 4,
            "district of columbia": 4,
            "florida": 5,
            "georgia": 5,
            "hawaii": 6,
            "idaho": 5,
            "illinois": 3,
            "indiana": 4,
            "iowa": 4,
            "kansas": 5,
            "kentucky": 5,
            "louisiana": 5,
            "maine": 4,
            "maryland": 4,
            "massachusetts": 4,
            "michigan": 4,
            "minnesota": 5,
            "mississippi": 4,
            "missouri": 5,
            "montana": 5,
            "nebraska": 5,
            "nevada": 6,
            "new hampshire": 4,
            "new jersey": 4,
            "new mexico": 7,
            "new york": 4,
            "north carolina": 5,
            "north dakota": 5,
            "ohio": 4,
            "oklahoma": 5,
            "oregon": 4,
            "pennsylvania": 4,
            "rhode island": 4,
            "south carolina": 5,
            "south dakota": 5,
            "tennessee": 4,
            "texas": 6,
            "utah": 6,
            "vermont": 4,
            "virginia": 4,
            "washington": 4,
            "west virginia": 4,
            "wisconsin": 4,
            "wyoming": 6
        ]
        
        let electricityEmissionDict: [String: Int] = [
            "alabama": 765,
            "alaska": 1186,
            "arizona": 694,
            "arkansas": 1065,
            "california": 503,
            "colorado": 1205,
            "connecticut": 546,
            "delaware": 1259,
            "district of columbia": 1170,
            "florida": 860,
            "georgia": 772,
            "hawaii": 1540,
            "idaho": 336,
            "illinois": 693,
            "indiana": 1646,
            "iowa": 947,
            "kansas": 885,
            "kentucky": 1767,
            "louisiana": 1023,
            "maine": 461,
            "maryland": 693,
            "massachusetts": 947,
            "michigan": 1048,
            "minnesota": 861,
            "mississippi": 833,
            "missouri": 1706,
            "montana": 1127,
            "nebraska": 1233,
            "nevada": 732,
            "new hampshire": 289,
            "new jersey": 530,
            "new mexico": 1075,
            "new york": 499,
            "north carolina": 698,
            "north dakota": 1411,
            "ohio": 1205,
            "oklahoma": 758,
            "oregon": 314,
            "pennsylvania": 729,
            "rhode island": 840,
            "south carolina": 563,
            "south dakota": 320,
            "tennessee": 754,
            "texas": 941,
            "utah": 1536,
            "vermont": 11,
            "virginia": 649,
            "washington": 219,
            "west virginia": 1933,
            "wisconsin": 1246,
            "wyoming": 1858
        ]
        
        let numSolarPanels = Int(roofSizeEstimate / 1.7032224)
        let WhProduced = Double(numSolarPanels) * solarPanelWattsPerHour * Double(peaksunhoursDict[state] ?? 0)
        let monthlyMWhProduced = WhProduced * 30 / 1000000
        let emissionsAvoidedLbs = monthlyMWhProduced * Double(electricityEmissionDict[state] ?? 0)
        let carbonCreditPayout = emissionsAvoidedLbs / 2204.62 * carbonCreditPrice * (1 - fee)
        let currentEmissionsEstimate = currentEnergyBillInKWh * Double(electricityEmissionDict[state] ?? 0)
        return (currentEmissionsEstimate, carbonCreditPayout)
    }

    
    func oldSolarPanels(currentEnergyBill: Int, state: String, numberOfPanels: Int, wattsPerHour: Int, carbonCreditPrice: Double, fee: Double) -> (currentEmissionsEstimate: Double, carbonCreditPayout: Double) {
        let currentEnergyBillInKWh = Double(currentEnergyBill) / 1000.0
        let peaksunhoursDict: [String: Int] = [
            "alabama": 4,
            "alaska": 4,
            "arizona": 7,
            "arkansas": 4,
            "california": 6,
            "colorado": 5,
            "connecticut": 4,
            "delaware": 4,
            "district of columbia": 4,
            "florida": 5,
            "georgia": 5,
            "hawaii": 6,
            "idaho": 5,
            "illinois": 3,
            "indiana": 4,
            "iowa": 4,
            "kansas": 5,
            "kentucky": 5,
            "louisiana": 5,
            "maine": 4,
            "maryland": 4,
            "massachusetts": 4,
            "michigan": 4,
            "minnesota": 5,
            "mississippi": 4,
            "missouri": 5,
            "montana": 5,
            "nebraska": 5,
            "nevada": 6,
            "new hampshire": 4,
            "new jersey": 4,
            "new mexico": 7,
            "new york": 4,
            "north carolina": 5,
            "north dakota": 5,
            "ohio": 4,
            "oklahoma": 5,
            "oregon": 4,
            "pennsylvania": 4,
            "rhode island": 4,
            "south carolina": 5,
            "south dakota": 5,
            "tennessee": 4,
            "texas": 6,
            "utah": 6,
            "vermont": 4,
            "virginia": 4,
            "washington": 4,
            "west virginia": 4,
            "wisconsin": 4,
            "wyoming": 6
        ]
        
        let electricityEmissionDict: [String: Int] = [
            "alabama": 765,
            "alaska": 1186,
            "arizona": 694,
            "arkansas": 1065,
            "california": 503,
            "colorado": 1205,
            "connecticut": 546,
            "delaware": 1259,
            "district of columbia": 1170,
            "florida": 860,
            "georgia": 772,
            "hawaii": 1540,
            "idaho": 336,
            "illinois": 693,
            "indiana": 1646,
            "iowa": 947,
            "kansas": 885,
            "kentucky": 1767,
            "louisiana": 1023,
            "maine": 461,
            "maryland": 693,
            "massachusetts": 947,
            "michigan": 1048,
            "minnesota": 861,
            "mississippi": 833,
            "missouri": 1706,
            "montana": 1127,
            "nebraska": 1233,
            "nevada": 732,
            "new hampshire": 289,
            "new jersey": 530,
            "new mexico": 1075,
            "new york": 499,
            "north carolina": 698,
            "north dakota": 1411,
            "ohio": 1205,
            "oklahoma": 758,
            "oregon": 314,
            "pennsylvania": 729,
            "rhode island": 840,
            "south carolina": 563,
            "south dakota": 320,
            "tennessee": 754,
            "texas": 941,
            "utah": 1536,
            "vermont": 11,
            "virginia": 649,
            "washington": 219,
            "west virginia": 1933,
            "wisconsin": 1246,
            "wyoming": 1858
        ]
        
        let WhProduced = Double(numberOfPanels * wattsPerHour * (peaksunhoursDict[state] ?? 0))
        let monthlyMWhProduced = WhProduced * 30 / 1000000
        let emissionsAvoidedLbs = monthlyMWhProduced * Double(electricityEmissionDict[state] ?? 0)
        let carbonCreditPayout = emissionsAvoidedLbs / 2204.62 * carbonCreditPrice * (1 - fee)
        let currentEmissionsEstimate = currentEnergyBillInKWh * Double(electricityEmissionDict[state] ?? 0)
        return (currentEmissionsEstimate, carbonCreditPayout)
    }
}
