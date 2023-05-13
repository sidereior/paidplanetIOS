//
//  IOSApp.swift
//  IOS
//
//  Created by Alexander Nanda on 5/9/23.
//

import SwiftUI
import Firebase

@main
struct IOSApp: App {

    init() {
        FirebaseApp.configure()
    }
    
  var body: some Scene {
    WindowGroup {
      NavigationView {
        LoginPage()
      }
    }
  }
}
