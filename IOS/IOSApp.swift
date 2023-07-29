import SwiftUI
import Firebase

@main
struct IOSApp: App {

    init() {
        FirebaseApp.configure()
    }
    
  var body: some Scene {
    WindowGroup {
        LoginPage()
    }
  }
}
