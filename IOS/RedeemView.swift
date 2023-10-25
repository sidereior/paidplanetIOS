import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()

    func addPayment(enteredWord: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let paymentData: [String: Any] = [
            "enteredWord": enteredWord
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
    
       @State private var isShowingSocialView = false
    private func fetchPayment() {
        let db = Firestore.firestore()
        db.collection("transactions")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("PAYMENT Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
             var totalCO2: Double = 0.0
               var transactions = documents.compactMap { document in
                    do {
                        let transaction = try document.data(as: Transaction.self)
                        if(transaction.progress == "Completed")
                        {
                            totalCO2 += transaction.dollarAmount
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
                    
                    Text("You are ready to get paid! Here are your options for your payment of $ \(totalCO2AmountDollars)")
                        .font(.custom("Avenir", size: 25))
                        .fontWeight(.black)
                        .foregroundColor(Color(hex: "00653B"))
                        .padding(.horizontal, 35)
                        .padding(.top, 15)
                    
                    HStack {
                        Image(systemName: option1Selected ? "largecircle.fill.circle" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "00653B"))
                            .onTapGesture {
                                option1Selected.toggle()
                                option2Selected = false
                            }
                        
                        Text("Venmo")
                            .fontWeight(.black)
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(Color(hex: "00653B"))
                            .onTapGesture {
                                option1Selected.toggle()
                                option2Selected = false
                            }
                    }
                    
                    HStack {
                        Image(systemName: option2Selected ? "largecircle.fill.circle" : "circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "00653B"))
                            .onTapGesture {
                                option2Selected.toggle()
                                option1Selected = false
                            }
                        
                        Text("Zelle")
                            .fontWeight(.black)
                            .font(.custom("Avenir", size: 20))
                            .foregroundColor(Color(hex: "00653B"))
                            .onTapGesture {
                                option2Selected.toggle()
                                option1Selected = false
                            }
                    }
                    
                    
                    TextField("Enter your Venmo or Zelle username", text: $enteredWord)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .background(Color(hex: "00653B"))
                        .cornerRadius(14.0)
                        .padding(.horizontal, 25)
                        .font(.custom("Avenir", size: 16).bold())
                        .foregroundColor(Color(hex: "F2E8CF"))
                        .accentColor(.black)
                    Button(action: {
                        firestoreService.addPayment(enteredWord: enteredWord) { result in
                            switch result {
                            case .success:
                                print("Payment added to Firestore")
                            case .failure(let error):
                                print("Error adding payment: \(error.localizedDescription)")
                            }
                        }
                        isShowingSocialView = true
                        
                    }) {
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
        }
    }
}


struct RedeemView2: View {
    
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
