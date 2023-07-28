import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionsView: View {
    @State private var transactions: [Transaction] = []

    var body: some View {
        VStack {
            List(transactions) { transaction in
                VStack(alignment: .leading) {
                    Text("\(transaction.firstName) \(transaction.lastName)")
                        .font(.headline)

                    Text("Transaction Date: \(transaction.transactionDate)")
                        .font(.subheadline)

                    Text("Progress: \(transaction.progress)")
                        .font(.subheadline)
                }
                .listRowBackground(Color(hex: "1B463C"))
            }
            .listStyle(PlainListStyle())
        }
        .background(Color(hex: "9aaee0").ignoresSafeArea())
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
