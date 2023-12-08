import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct LoginPage: View {
    @State private var email = ""
       @State private var password = ""
       @State private var name = ""
       @State private var userIsLoggedIn = false
       @State private var shake = false
       @State private var confirmEmail = ""
       @State private var confirmPassword = ""
    @State private var isShowingWelcomeSheet = true
       @AppStorage("rememberMe") private var rememberMe = true
    @AppStorage("hasShownWelcomeSheet") private var hasShownWelcomeSheet = false
       @State private var isSignUpMode = false
    
    func loginUser() {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if error != nil {
                    print(error!.localizedDescription)
                    shake = true
                } else {
                    userIsLoggedIn = true
                    shake = false

                    // Save the user's email and password to UserDefaults if "Remember Me" is checked
                    if rememberMe {
                        UserDefaults.standard.set(email, forKey: "savedEmail")
                        UserDefaults.standard.set(password, forKey: "savedPassword")
                    }
                }
            }
        }
    
    func autoLoginUser() {
           // Get the saved email and password from UserDefaults
           let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") ?? ""
           let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") ?? ""

           // Check if both email and password are non-empty
           if !savedEmail.isEmpty && !savedPassword.isEmpty {
               // Attempt to log in the user using saved credentials
               Auth.auth().signIn(withEmail: savedEmail, password: savedPassword) { result, error in
                   if error != nil {
                       print(error!.localizedDescription)
                   } else {
                       userIsLoggedIn = true
                   }
               }
           }
       }
    
    
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let authResult = authResult {
                // Create a dictionary with user data
                let userData: [String: Any] = [
                    "name": name,
                    // Add other fields as needed
                ]
                
                // Initialize the Firestore database
                let db = Firestore.firestore()
                
                if rememberMe {
                            UserDefaults.standard.set(email, forKey: "savedEmail")
                            UserDefaults.standard.set(password, forKey: "savedPassword")
                        }
                
                // Set user data in the Firestore database
                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                    if let error = error {
                        print("Error setting user data: \(error.localizedDescription)")
                    } else {
                        userIsLoggedIn = true
                    }
                }
            }
        }
    }

    var body: some View {
        ZStack{
            if userIsLoggedIn {
                HomeView()
            } else {
                unLogged
                    .onAppear {
                        if rememberMe {
                            
                            
                            autoLoginUser()
                        }
                    }
            }
        }
        .sheet(isPresented: $isShowingWelcomeSheet, onDismiss: {
                    hasShownWelcomeSheet = true
                }) {
                    if !hasShownWelcomeSheet {
                        WelcomeFrameView()
                    }
                }
                .onAppear {
                    if hasShownWelcomeSheet {
                        isShowingWelcomeSheet = false
                    }
                }
        
    }
    

    var unLogged: some View {
        ZStack {
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.5) // Adjust the opacity as needed for the green tint
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(("Welcome to"))
                    .font(.custom("Avenir", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(Color(hex: "D9D9D9"))
                    
                Text(("PaidPlanet"))
                    .font(.custom("Avenir-Oblique", size: 32))
                    .fontWeight(.black)
                    .foregroundColor(.green)
                
                
                TextField("Email", text: $email)  .autocapitalization(.none)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "000000"))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 35)
                    .colorInvert()
                    .font(.custom("Avenir", size: 15).bold())
                
                if isSignUpMode {
                    TextField("Confirm Email", text: $confirmEmail)
                       .autocapitalization(.none)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "000000"))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 35)
                    .colorInvert()
                    .font(.custom("Avenir", size: 15).bold())
                }
                
                SecureField("Password", text: $password)
                      .autocapitalization(.none)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "000000"))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 35)
                    .colorInvert()
                    .font(.custom("Avenir", size: 15).bold())

                                    
                if isSignUpMode {
                    SecureField("Confirm Password", text: $confirmPassword)
                      .autocapitalization(.none)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "000000"))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 35)
                    .colorInvert()
                    .font(.custom("Avenir", size: 15).bold())
                }
                
                if isSignUpMode {
                    TextField("What would you like to be called?", text: $name)
                                              .autocapitalization(.none)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "000000"))
                    .foregroundColor(Color(hex: "FFFFFF"))
                    .cornerRadius(14.0)
                    .padding(.horizontal, 35)
                    .colorInvert()
                    .font(.custom("Avenir", size: 15).bold())

                                       }
                        
                Toggle("Remember Me", isOn: $rememberMe)
                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "1B463C")))
                    .padding(.horizontal, 35)
                    .font(.custom("Avenir", size: 15).bold())
                
                Group {
                    Button(action: {
                        if isSignUpMode {
                            // Check if email and confirmEmail match
                            if email == confirmEmail {
                                // Check if password and confirmPassword match
                                if password == confirmPassword {
                                    // Register user
                                    registerUser()
                                } else {
                                    // Show password mismatch error
                                    //come back to this later!
                                    Text("Your passwords do not match.")
                                    print("Your passwords do not match.")
                                }
                            } else {
                                // Show email mismatch error
                                Text("Your emails do not match.")
                                Text("Your emails do not match.")
                            }
                        } else {
                            // Login user
                            loginUser()
                        }
                    }, label: {
                        Text(isSignUpMode ? "Sign Up" : "Login")
                            .font(.custom("Avenir", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "D9D9D9"))
                            .frame(width: 220, height: 60)
                            .background(Color(hex: "1B463C"))
                            .cornerRadius(14.0)
                    })
                    
                    Button(action: {
                        isSignUpMode.toggle()
                    }, label: {
                        Text(isSignUpMode ? "Already have an account? Log in" : "New to PaidPlanet? Sign up here")
                            .font(.custom("Avenir", size: 20))
                            .fontWeight(.black)
                            .foregroundColor(Color(hex: "D9D9D9"))
                            .cornerRadius(14.0)
                    })
                    
                
                }
            }
        }
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

// Convert hex to color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

class EmailManager {
    static let shared = EmailManager()
    var email: String = ""
    
    private init() {}
}
