import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionsView: View {
    @State private var transactions: [Transaction] = []
    @State private var totalCO2Amount: Double = 0.0
    @State private var transactionChanged: Bool = false
    @State private var totalDollarAmount: Double = 0.0
    
    var body: some View {
        ZStack {
            Color(hex: "F2E8CF").edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    
                    VStack(alignment: .leading, spacing: 10){
                        Spacer()
                            .frame(height: 5)
                        
                        HStack{
                            Text("Total Transactions: ")
                             .fontWeight(.black)
                             .foregroundColor(Color(hex: "7D5E35"))
                            
                            Text("\(transactions.count)")
                            .fontWeight(.black)
                            .foregroundColor(Color(hex: "00653B"))
                        }
                            .font(.title)
                       
                        HStack{
                            Text("Total CO2 Offset: ")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "7D5E35"))
                                .fontWeight(.black)
                            
                            Text("\(String(format: "%.2f", totalCO2Amount)) tons of CO2")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "00653B"))
                                .fontWeight(.black)

                        }
                        
                        Hstack{
                            
                            
                            Text("Total $ Earned: \(String(format: "%.2f", totalDollarAmount)) dollars")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "7d5e35"))
                                .fontWeight(.black)
                            Text("\(String(format: "%.2f", totalDollarAmount)) dollars")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "00653b"))
                                .fontWeight(.black)
                            
                        }
                        
                        Spacer()
                            .frame(height: 5)
                    }
                    .padding(.horizontal,15)
                    .background(Color(hex: "AACB96"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 10)
                    
                    ForEach(transactions) { transaction in
                        TransactionCardView(transaction: transaction)
                    }
                        .padding(.horizontal, 15)
                }
            }
        }
        .onAppear {
            fetchTransactions()
        }
    }

        private func fetchTransactions() {
        let db = Firestore.firestore()
        db.collection("transactions")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                var totalCO2: Double = 0.0
                var totalDollars: Double = 0.0

                transactions = documents.compactMap { document in
                    do {
                        
                        let transaction = try document.data(as: Transaction.self)
                        totalCO2 += transaction.amountCO
                        totalDollars += transaction.dollarAmount
                        if(transaction.progress == "Completed")
                        {
                            transactionChanged = true
                        }
                        return transaction
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                        return nil
                    }
                }
                totalDollarAmount = totalDollars
                totalCO2Amount = totalCO2
            }
    }
}

struct TransactionCardView: View {
    var transaction: Transaction

    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
           
            Spacer()
                .frame(height: 5)
       
            HStack{
                Text("\(transaction.transactionType)")
                    .font(.title)
                    .foregroundColor(Color(hex: "D1AD7D"))
                    .fontWeight(.black)
                
                Spacer()
                 
                if(transaction.transactionType.contains("Car"))
                {
                 Image("car")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(14.0)
                    .frame(width: 50, height: 50)
                    .colorInvert()
                }
                else if(transaction.transactionType.contains("Solar"))
                {
                 Image("solar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(14.0)
                    .frame(width: 50, height: 50)
                    .colorInvert()
   
                }
                else if(transaction.transactionType.contains("Stove"))
                {
                  Image("stove")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(14.0)
                    .frame(width: 50, height: 50)
                    .colorInvert()
                }
                   

            }
           
            HStack{
                Text("Progress: ")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "D1AD7D"))
                    .fontWeight(.bold)
               
                if(transaction.progress == "Pending")
                {
                    Text("\(transaction.progress)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }
                else if(transaction.progress == "Completed")
                {
                    Text("\(transaction.progress)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)

                }
                else if (transaction.progress == "Redeemed")
                {
                    Text("\(transaction.progress)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "D1AD7D"))
                }
            }
            
            Text("Transaction Date: \(formattedDate)")
                .font(.subheadline)
                .foregroundColor(Color(hex: "D1AD7D"))
                .fontWeight(.bold)
            
            if(transaction.dollarAmount.isEqual(to: 0.0))
            {
                Text("Dollar Amount: Transaction is still being reviewed.")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "D1AD7D"))
                    .fontWeight(.bold)
            }
            else
            {
                Text("Dollar Amount: \(String(format: "%.2f", transaction.dollarAmount))")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "D1AD7D"))
                    .fontWeight(.bold)
            }
            Spacer()
                .frame(height: 5)
       }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
        .padding(.horizontal, 15)
        .background(Color(hex: "AACB96"))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }

    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: transaction.transactionDate)
    }
}
