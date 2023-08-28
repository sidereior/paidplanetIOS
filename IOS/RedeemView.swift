import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func addPayment(enteredWord: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let paymentData: [String: Any] = [
            "enteredWord": enteredWord
            // You can add more fields if needed
        ]

        db.collection("payments").addDocument(data: paymentData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

    
struct RedeemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var enteredWord = ""
    private let firestoreService = FirestoreService()
    
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
                    HStack{
                        Spacer()
                        
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
                    }
                
                    TextField("Enter a word", text: $enteredWord)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .padding()

                                        Button(action: {
                                           firestoreService.addPayment(enteredWord: enteredWord) { result in
                                                switch result {
                                                case .success:
                                                    print("Payment added to Firestore")
                                                case .failure(let error):
                                                    print("Error adding payment: \(error.localizedDescription)")
                                                }
                                            }
                                        }) {
                                            Text("Submit Payment")
                                                .font(.custom("Avenir", size: 20))
                                                .foregroundColor(.blue)
                                                .fontWeight(.bold)
                                                .padding()
                                                .background(Color(hex: "C3E8AC"))
                                                .cornerRadius(14)
                                        }
                    
                    Text("Share on socials that PaidPlanet just PaidMe! #CookingGreen! #DrivingGreen! #GreenEnergy! #GreenCreditForAll!")
                        .font(.custom("Avenir", size: 25))
                                .fontWeight(.black)
                                .foregroundColor(Color(hex: "00653B"))
                                .padding(.horizontal, 35)
                                .padding(.top, 15)
                    
                }
            }
        }
    }
}
