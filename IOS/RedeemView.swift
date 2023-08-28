import Foundation
import SwiftUI
import Firebase


struct RedeemView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(hex: "F2E8CF")
                .ignoresSafeArea()
            
            //first fetch all transactions
            //then display the transactions along with a checkbox next to them.
            //the checkbox should go in and change the transaction's progress property to "Redeemed"
            //below this list there should be a total dollar amount field that is updated
            //as each transaction is marked as redeemed this total dollar amount should be equal to
            //the sum of all of the redeemed transactions
            //below the total amount there should a confirm and get paid button that opens a new sheet
            //this new sheet should be called paymentview
            
            ScrollView{
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color(hex: "C3E8AC"))
                            .cornerRadius(14)
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                    
                    Text("Share on socials that PaidPlanet just PaidMe! #CookingGreen! #DrivingGreen! #GreenEnergy! #GreenCreditForAll!")
                        .font(.custom("Avenir", size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding()
                    
                }
            }
        }
    }
}
