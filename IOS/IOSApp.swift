import SwiftUI
import Firebase

@main
struct IOSApp: App {
    //Test
    init() {
        FirebaseApp.configure()
    }
    
  var body: some Scene {
    WindowGroup {
        LoginPage()
    }
  }
}
