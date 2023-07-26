import SwiftUI
import Firebase

struct ProfileView: View {
    @StateObject private var userManager = UserManager()//TODO: THIS IS HOW WE CAN GET THE EMAIL, STORE THIS IN TRANSACTIONS
    @State private var isShowingResetPasswordAlert = false

    var body: some View {
        VStack {
            var greeting: String {
                let hour = Calendar.current.component(.hour, from: Date())

                if (6..<12).contains(hour) {
                    return "Good Morning"
                } else if (12..<18).contains(hour) {
                    return "Good Afternoon"
                } else {
                    return "Good Evening"
                }
            }

            Text(greeting + ", \(userManager.user?.displayName ?? "")")
                .font(.custom("Avenir", size: 25).bold())
                .font(.title)
                .foregroundColor(Color(hex: "1B463C"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .padding(.top, 25)

            Text("Email: \(userManager.user?.email ?? "")")
                .font(.custom("Avenir", size: 25))
                .font(.title)
                .foregroundColor(Color(hex: "1B463C"))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .padding(.top, 25)

            Button(action: {
                isShowingResetPasswordAlert = true
            }) {
                Text("Reset Password")
                    .font(.custom("Avenir", size: 25))
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.top, 25)
            }
            .alert(isPresented: $isShowingResetPasswordAlert) {
                Alert(
                    title: Text("Reset Password"),
                    message: Text("Are you sure you want to reset your password?"),
                    primaryButton: .default(Text("Reset"), action: resetPassword),
                    secondaryButton: .cancel()
                )
            }

            Button(action: logout) {
                Text("Logout")
                    .font(.custom("Avenir", size: 25))
                    .font(.title)
                    .foregroundColor(.red)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.top, 25)
            }

            Spacer()
        }
        .navigationBarTitle("Profile")
        .onAppear {
            userManager.fetchUser()
        }
    }

    func resetPassword() {
        if let email = userManager.user?.email {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print("Error resetting password: \(error.localizedDescription)")
                } else {
                    print("Password reset email sent successfully")
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            clearStoredCredentials()
            exit(0)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func clearStoredCredentials() {
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        UserDefaults.standard.removeObject(forKey: "savedPassword")
    }

}

class UserManager: ObservableObject {
    @Published var user: User?

    func fetchUser() {
        user = Auth.auth().currentUser
    }
}
