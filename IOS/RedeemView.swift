import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func addPayment(enteredWord: String, totalCO2AmountDollars: Double, transactionDates: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        let paymentData: [String: Any] = [
            "enteredWord": enteredWord,
            "totalCO2AmountDollars": totalCO2AmountDollars,
            "transactionDates": transactionDates
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
    @State private var alltransactionUTC: [String] = []
    @State private var isShowingSocialView = false
    private let firestoreService = FirestoreService()

    private func fetchPayment() {
        let db = Firestore.firestore()
        db.collection("transactions")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("PAYMENT Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var totalCO2: Double = 0.0
                for document in documents {
                    do {
                        let transaction = try document.data(as: Transaction.self)
                        guard transaction.email == Auth.auth().currentUser?.email, transaction.progress == "Completed" else {
                            continue
                        }

                        totalCO2 += transaction.dollarAmount
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let dateString = dateFormatter.string(from: transaction.transactionDate)
                        alltransactionUTC.append(dateString)
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                    }
                }
                totalCO2AmountDollars = totalCO2
            }
    }

    @Environment(\.presentationMode) var presentationMode
    @State private var enteredWord = ""
    @State private var option1Selected = false
    @State private var option2Selected = false

    var body: some View {
        ZStack {
            Color(hex: "F2E8CF").ignoresSafeArea()
            ScrollView {
                VStack {
                    // Cancel Button
                    HStack {
                        Spacer()
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.custom("Avenir", size: 20).bold())
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(hex: "C3E8AC"))
                        .cornerRadius(14)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }

                    // Payment Info Text
                    Text("You are ready to get paid! Here are your options for your payment of $ \(totalCO2AmountDollars, specifier: "%.2f")")
                        .font(.custom("Avenir", size: 25))
                        .fontWeight(.black)
                        .foregroundColor(Color(hex: "00653B"))
                        .padding(.horizontal, 35)
                        .padding(.top, 15)

                    // Payment Options
                    OptionView(optionSelected: $option1Selected, otherOption: $option2Selected, text: "Venmo")
                    OptionView(optionSelected: $option2Selected, otherOption: $option1Selected, text: "Zelle")

                    // Username TextField
                    TextField("Enter your Venmo or Zelle username", text: $enteredWord)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .background(Color(hex: "00653B"))
                        .cornerRadius(14.0)
                        .padding(.horizontal, 25)
                        .font(.custom("Avenir", size: 16).bold())
                        .foregroundColor(Color(hex: "F2E8CF"))
                        .accentColor(.black)

                    // Submit Payment Button
                    Button(action: submitPayment) {
                        Text("Submit Payment")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color(hex: "C3E8AC"))
                            .cornerRadius(14)
                    }
                    .sheet(isPresented: $isShowingSocialView) {
                        RedeemView2()
                    }
                }
            }
            .onAppear(perform: fetchPayment)
        }
    }

    private func submitPayment() {
        firestoreService.addPayment(enteredWord: enteredWord, totalCO2AmountDollars: totalCO2AmountDollars, transactionDates: alltransactionUTC) { result in
            switch result {
            case .success:
                print("Payment added to Firestore")
            case .failure(let error):
                print("Error adding payment: \(error.localizedDescription)")
            }
        }
        isShowingSocialView = true
    }
}

struct OptionView: View {
    @Binding var optionSelected: Bool
    @Binding var otherOption: Bool
    var text: String

    var body: some View {
        HStack {
            Image(systemName: optionSelected ? "largecircle.fill.circle" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Color(hex: "00653B"))
                .onTapGesture {
                    optionSelected.toggle()
                    otherOption = false
                }

            Text(text)
                .fontWeight(.black)
                .font(.custom("Avenir", size: 20))
                .foregroundColor(Color(hex: "00653B"))
                .onTapGesture {
                    optionSelected.toggle()
                    otherOption = false
                }
        }
    }
}



struct RedeemView2: View {
    
    @State private var totalCO2AmountDollars: Double = 0.0
    private func fetchTransactions() {
        let db = Firestore.firestore()

        // Get the current user's email
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("Error: User is not logged in or email not available")
            return
        }

        db.collection("transactions")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                var totalCO2: Double = 0.0
                var filteredTransactions: [Transaction] = []

                for document in documents {
                    do {
                        let transaction = try document.data(as: Transaction.self)

                        // Check if the transaction's email matches the current user's email
                        if transaction.email == userEmail {
                            if transaction.progress == "Completed" {
                                totalCO2 += transaction.amountCO
                            }
                            filteredTransactions.append(transaction)
                        }
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                    }
                }

                //self.transactions = filteredTransactions
                self.totalCO2AmountDollars = totalCO2
            }
    }
   
    @Environment(\.presentationMode) var presentationMode
    @State private var enteredWord = ""
    @State private var isShareSheetPresented = false
    @State private var option1Selected = false
    @State private var option2Selected = false

    private let firestoreService = FirestoreService()
    
    var body: some View {
        ZStack {
            Color(hex: "F2E8CF")
                .ignoresSafeArea()
                        
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
                    
                   Text("Share on socials that you just got Paid through PaidPlanet for a chance to win our monthly 25$ Amazon Gift Card giveaway!")
                           .font(.custom("Avenir", size: 25))
                                   .fontWeight(.black)
                                   .foregroundColor(Color(hex: "00653B"))
                                   .padding(.horizontal, 35)
                                   .padding(.top, 15)
                    
                    Button(action: {
                        self.isShareSheetPresented.toggle()
                    }) {
                        Text("Share")
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color(hex: "C3E8AC"))
                            .cornerRadius(14)
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                    .sheet(isPresented: $isShareSheetPresented){
                        ShareSheet(activityItems: ["I just got paid for being sustainable using #PaidPlanet Join now at paidplanet.com"])
                    }
                }
            }
            /*
            .onAppear {
            fetchPayment()
            }
             */
        }
    }
    

    struct ShareSheet: UIViewControllerRepresentable {
        let activityItems: [Any]

        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            return controller
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        }
    }

    
}
