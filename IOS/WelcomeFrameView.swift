//
//  WelcomeFrameView.swift
//  IOS
//
//  Created by Alexander Nanda on 7/26/23.
//

import Foundation
import AuthenticationServices
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct WelcomeFrameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.5) // Adjust the opacity as needed for the green tint
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .font(.custom("Avenir", size: 20))
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(7)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                
                Text(("Welcome to"))
                    .font(.custom("Avenir", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: "D9D9D9"))
                    .overlay(
                        Text(("Welcome to"))
                            .font(.custom("Avenir", size: 32))
                            .fontWeight(.black)
                            .foregroundColor(.black)
                            .offset(x: 1, y: 1)
                    )
                Text(("PaidPlanet"))
                    .font(.custom("Avenir-Oblique", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: "1B463C"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white) // Change the background color to white or any other color you want for the frame
    }
    
    func electricCars(currentCarMPG: Int, currentDriveEst: Int, carbonCreditPrice: Int, fee: Double) -> (currentEmissionsEstimate: Double, carbonCreditPayout: Double) {
        let gallonsGasConsumed = Double(currentDriveEst) / Double(currentCarMPG)
        
        // CO2 emissions per gallon of gasoline (grams)
        let co2Gallon = 8887.0
        
        let currentEmissionsEstimate = gallonsGasConsumed * co2Gallon
        
        // Convert emissions estimate to metric tonnes (grams to kilograms to metric tonnes)
        let currentEmissionsInMetricTonnes = currentEmissionsEstimate / 1_000_000.0
        
        // Calculate carbon credit payout
        let carbonCreditPayout = currentEmissionsInMetricTonnes * Double(carbonCreditPrice) * (1 - fee)
        
        return (currentEmissionsEstimate, carbonCreditPayout)
    }

    func newSolarPanels(currentEnergyBill: Int, state: String, roofSizeEstimate: Double, carbonCreditPrice: Double, fee: Double) -> (currentEmissionsEstimate: Double, carbonCreditPayout: Double) {
        let currentEnergyBillInKWh = Double(currentEnergyBill) / 1000.0
        
        // Average solar panel watts per hour
        let solarPanelWattsPerHour = 325.0
        
        // Average peak sun hours based on state
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
        
        // Electricity emissions in lbs/MWh based on state
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
        
        // Calculate the number of solar panels
        let numSolarPanels = Int(roofSizeEstimate / 1.7032224)
        
        // Calculate monthly MWh produced
        let WhProduced = Double(numSolarPanels) * solarPanelWattsPerHour * Double(peaksunhoursDict[state] ?? 0)
        let monthlyMWhProduced = WhProduced * 30 / 1000000
        
        // Calculate emissions avoided in lbs
        let emissionsAvoidedLbs = monthlyMWhProduced * Double(electricityEmissionDict[state] ?? 0)
        
        // Calculate carbon credit payout
        let carbonCreditPayout = emissionsAvoidedLbs / 2204.62 * carbonCreditPrice * (1 - fee)
        
        let currentEmissionsEstimate = currentEnergyBillInKWh * Double(electricityEmissionDict[state] ?? 0)
        
        return (currentEmissionsEstimate, carbonCreditPayout)
    }

    
    func oldSolarPanels(currentEnergyBill: Int, state: String, numberOfPanels: Int, wattsPerHour: Int, carbonCreditPrice: Double, fee: Double) -> (currentEmissionsEstimate: Double, carbonCreditPayout: Double) {
        let currentEnergyBillInKWh = Double(currentEnergyBill) / 1000.0
        
        // Average peak sun hours based on state
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
        
        // Electricity emissions in lbs/MWh based on state
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
        
        // Calculate Wh produced
        let WhProduced = Double(numberOfPanels * wattsPerHour * (peaksunhoursDict[state] ?? 0))
        
        // Calculate monthly MWh produced
        let monthlyMWhProduced = WhProduced * 30 / 1000000
        
        // Calculate emissions avoided in lbs
        let emissionsAvoidedLbs = monthlyMWhProduced * Double(electricityEmissionDict[state] ?? 0)
        
        // Calculate carbon credit payout
        let carbonCreditPayout = emissionsAvoidedLbs / 2204.62 * carbonCreditPrice * (1 - fee)
        
        let currentEmissionsEstimate = currentEnergyBillInKWh * Double(electricityEmissionDict[state] ?? 0)
        
        return (currentEmissionsEstimate, carbonCreditPayout)
    }

    
    
    
}
