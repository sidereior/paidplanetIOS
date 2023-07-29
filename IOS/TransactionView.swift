import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionsView: View {
    @State private var transactions: [Transaction] = []

    var body: some View {
        ZStack {
            Color(hex: "9aaee0").edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    ForEach(transactions) { transaction in
                        TransactionCardView(transaction: transaction)
                    }
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

                transactions = documents.compactMap { document in
                    do {
                        return try document.data(as: Transaction.self)
                    } catch {
                        print("Error decoding transaction: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
}

struct TransactionCardView: View {
    var transaction: Transaction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(transaction.firstName) \(transaction.lastName)")
                .font(.title)
                .foregroundColor(.white)

            Text("Transaction Date: \(formattedDate)")
                .font(.subheadline)
                .foregroundColor(.white)

            Text("Progress: \(transaction.progress)")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
        .padding(.horizontal, 15)
        .background(Color(hex: "1B463C"))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }

    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: transaction.transactionDate)
    }
}
