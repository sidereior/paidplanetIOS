import SwiftUI
import Firebase

struct ProfileView: View {
    @StateObject private var userManager = UserManager()
    @State private var isShowingResetPasswordAlert = false
    @State private var isShowingFeedbackView = false
    @State private var showWelcomeFrameView = false
    @State private var isShowingDeleteView = false

    var body: some View {
        VStack {
            HStack {
                Text(greeting)
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: "7D5E35"))
                    .font(.title)
                    .padding()
                    .background(Color(hex: "D1AD7D"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
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
                Text("Change Password")
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
                    title: Text("Change Password"),
                    message: Text("Are you sure you want to change your password? An email will be sent to you shortly."),
                    primaryButton: .default(Text("Reset"), action: resetPassword),
                    secondaryButton: .cancel()
                )
            }

            Button(action: {
                isShowingFeedbackView = true
            }) {
                Text("Leave Feedback")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color(hex: "00653B"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 10)
            }
            .sheet(isPresented: $isShowingFeedbackView) {
                FeedbackView(isPresented: $isShowingFeedbackView)
            }
               
            Button(action: {
                        showWelcomeFrameView = true
            }) {
                Text("Replay Tutorial")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color(hex: "00653B"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 10)
                    }
                    .sheet(isPresented: $showWelcomeFrameView) {
                        WelcomeFrameView()
                    }
            
           Button(action: {
                isShowingDeleteView = true
            }) {
                Text("Delete your account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color(hex: "00653B"))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 10)
            }
            .sheet(isPresented: $isShowingDeleteView) {
                DeleteView(isPresented: $isShowingDeleteView)
            }
            
            
            Button(action: logout) {
                Text("Logout")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "ff6363"))
                    .padding()
                    .background(Color(hex: "00653B"))
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

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if (6..<12).contains(hour) {
            return "Good Morning"
        } else if (12..<18).contains(hour) {
            return "Good Afternoon"
        } else {
            return "Good Evening"
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

struct FeedbackView: View {
    @Binding  var isPresented: Bool
    @State  var feedbackText: String = ""
    var firestoreService = FirestoreService2()

    var body: some View {
        VStack {
            
             HStack {
                        Spacer()
                        Button("Cancel") {
                            isPresented = false;
                        }
                        .font(.custom("Avenir", size: 20).bold())
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(hex: "C3E8AC"))
                        .cornerRadius(14)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
          
            Text("We value your feedback. ")
                .font(.custom("Avenir", size: 20))
                              .fontWeight(.black)
                              .foregroundColor(Color(hex: "00653B"))
                              .padding(.horizontal, 35)
                              .padding(.top, 50)

                
            Text("Please share your thoughts or experiences with us:")
                .font(.custom("Avenir", size: 20))
                              .fontWeight(.black)
                              .foregroundColor(Color(hex: "7D5E35"))
                              .padding(.horizontal, 35)
                              .padding(.top, 5)
            
            TextField("Submit your feedback here", text: $feedbackText)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .background(Color(hex: "00653B"))
                        .cornerRadius(14.0)
                        .padding(.horizontal, 25)
                        .font(.custom("Avenir", size: 16).bold())
                        .foregroundColor(Color(hex: "F2E8CF"))
                        .accentColor(.black)
                        .multilineTextAlignment(.center)
                
          
            Button("Submit Feedback") {
                submitFeedback()
            }
            .font(.headline)
            .foregroundColor(Color(hex: "72cff7"))
            .padding()
            .background(Color(hex: "00653B"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.bottom, 10)
            
           


            Spacer()
        }
        .padding()
        .background(Color(hex: "F2E8CF"))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    private func submitFeedback() {
        firestoreService.submitFeedback(feedbackText: feedbackText) { result in
            switch result {
            case .success:
                print("Feedback submitted successfully")
            case .failure(let error):
                print("Error submitting feedback: \(error.localizedDescription)")
            }
            isPresented = false
        }
    }
}



class UserManager: ObservableObject {
    @Published var user: User?

    func fetchUser() {
        user = Auth.auth().currentUser
    }
}
class FirestoreService2 {
    private let db = Firestore.firestore()

    // Add other methods as needed

    func submitFeedback(feedbackText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let feedbackData: [String: Any] = [
            "feedbackText": feedbackText,
            "timestamp": FieldValue.serverTimestamp(),
            "userEmail": Auth.auth().currentUser?.email ?? "Unknown User"
        ]

        db.collection("feedback").addDocument(data: feedbackData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func submitDelete(feedbackText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let feedbackData: [String: Any] = [
            "feedbackText": feedbackText,
            "timestamp": FieldValue.serverTimestamp(),
            "userEmail": Auth.auth().currentUser?.email ?? "Unknown User"
        ]

        db.collection("todelete").addDocument(data: feedbackData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}


struct DeleteView: View {
    @Binding  var isPresented: Bool
    @State  var feedbackText: String = ""
    var firestoreService = FirestoreService2()

    var body: some View {
        VStack {
            
             HStack {
                        Spacer()
                        Button("Cancel") {
                            isPresented = false;
                        }
                        .font(.custom("Avenir", size: 20).bold())
                        .foregroundColor(.red)
                        .padding()
                        .background(Color(hex: "C3E8AC"))
                        .cornerRadius(14)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
          
            Text("We are sorry to see you go ☹️. ")
                .font(.custom("Avenir", size: 20))
                              .fontWeight(.black)
                              .foregroundColor(Color(hex: "00653B"))
                              .padding(.horizontal, 35)
                              .padding(.top, 50)

                
            Text("Please share why you are leaving PaidPlanet. We value your feedback.")
                .font(.custom("Avenir", size: 20))
                              .fontWeight(.black)
                              .foregroundColor(Color(hex: "7D5E35"))
                              .padding(.horizontal, 35)
                              .padding(.top, 5)
            
            TextField("Submit your feedback here", text: $feedbackText)
                        .padding(.vertical, 10)
                        .autocapitalization(.none)
                        .background(Color(hex: "00653B"))
                        .cornerRadius(14.0)
                        .padding(.horizontal, 25)
                        .font(.custom("Avenir", size: 16).bold())
                        .foregroundColor(Color(hex: "F2E8CF"))
                        .accentColor(.black)
                        .multilineTextAlignment(.center)
                
          
            Button("Yes, I'm sure I want to delete my account. I understand this action is irreversible and all data pertaining to my account will be deleted in ~1 hour.") {
                submitDelete()
            }
            .font(.headline)
            .foregroundColor(.red)
            .padding()
            .background(Color(hex: "00653B"))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            .padding(.bottom, 10)

            Spacer()
        }
        .padding()
        .background(Color(hex: "F2E8CF"))
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    private func submitDelete() {
        firestoreService.submitDelete(feedbackText: feedbackText) { result in
            switch result {
            case .success:
                print("Feedback submitted successfully")
            case .failure(let error):
                print("Error submitting feedback: \(error.localizedDescription)")
            }
            isPresented = false
        }
    }
}

