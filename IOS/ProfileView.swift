import SwiftUI
import Firebase

struct ProfileView: View {
    @StateObject private var userManager = UserManager()
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
            HStack{
            Text(greeting)
                         .fontWeight(.black)
                         .foregroundColor(Color(hex: "7D5E35"))
                    }
                        .font(.title)
                        .padding()
                        .background(Color(hex: "D1AD7D"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 10)

            
            Text("Email: \(userManager.user?.email ?? "")")
                .font(.headline)
             .fontWeight(.bold)
                .foregroundColor(Color(hex: "C3E8AC"))
                        .padding()
                        .background(Color(hex: "00653B"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(10)
           
            Button(action: {
                isShowingResetPasswordAlert = true
            }) {
                Text("Reset Password")
                    .foregroundColor(Color(hex: "72cff7"))
                    .font(.title)
                    .fontWeight(.bold)
                        .padding()
                        .background(Color(hex: "00653B"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 10)
                                }
            .alert(isPresented: $isShowingResetPasswordAlert) {
                Alert(
                    title: Text("Reset Password"),
                    message: Text("Are you sure you want to reset your password? An email will be sent to you shortly."),
                    primaryButton: .default(Text("Reset"), action: resetPassword),
                    secondaryButton: .cancel()
                )
            }

            Button(action: logout) {
                Text("Logout").font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "ff6363"))
                        .padding()
                        .background(Color(hex: "00653b"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .padding(.bottom, 10)
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
