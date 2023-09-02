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
    
    @State private var totalCO2AmountDollars: Double = 0.0
    
    
    private func fetchTransactions() {
        let db = Firestore.firestore()
        db.collection("transactions")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var totalCO2: Double = 0.0
                
               var transactions = documents.compactMap { document in
                    do {
                        let transaction = try document.data(as: Transaction.self)
                        if(transaction.progress == "Completed")
                        {
                            totalCO2 += transaction.amountCO
                        }
                        return transaction
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                        return nil
                    }
                }
                totalCO2AmountDollars = totalCO2
            }
    }
    
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
                    
                    Text("You are ready to get paid! Here are your options for your payment of $ \(totalCO2AmountDollars)")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color(hex: "00653B"))
                        .cornerRadius(14.0)
                        .padding(.horizontal, 25)
                        .font(.custom("Avenir", size: 20).bold())
                        .foregroundColor(Color(hex: "F2E8CF"))
                        .accentColor(.black)
                    
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
