import SwiftUI

@main
struct MainApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var showOptions = false
    @State private var selectedOption: String?
    
    var body: some View {
        TabView {
            HView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Button(action: {
                showOptions = true
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .tabItem {
                Text("Add")
            }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .sheet(isPresented: $showOptions) {
            OptionsView(selectedOption: $selectedOption)
        }
    }
}

struct HView: View {
    var body: some View {
        Text("Home View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}

struct OptionsView: View {
    @Binding var selectedOption: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose an option:")
                .font(.headline)
            
            Button(action: {
                selectedOption = "Option 1"
            }) {
                Text("Option 1")
            }
            
            Button(action: {
                selectedOption = "Option 2"
            }) {
                Text("Option 2")
            }
            
            Button(action: {
                selectedOption = "Option 3"
            }) {
                Text("Option 3")
            }
            
            Button(action: {
                selectedOption = "Option 4"
            }) {
                Text("Option 4")
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}
