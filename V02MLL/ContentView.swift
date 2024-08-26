import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var showAlert: Bool = false
    @State private var useFaceID: Bool = false

    var body: some View {
        NavigationView {
            if isAuthenticated {
                MainTabView(isAuthenticated: $isAuthenticated)
            } else {
                LoginView(username: $username, password: $password, isAuthenticated: $isAuthenticated, showAlert: $showAlert, useFaceID: $useFaceID)
                    .onAppear {
                        checkFaceIDPreference()
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Credentials"), message: Text("Please try again"), dismissButton: .default(Text("OK")))
                    }
//                    .background(Color(hex: "#C49797")) // Применяем фоновый цвет к каждой строке
            }
        }
    }

    func checkFaceIDPreference() {
        useFaceID = UserDefaults.standard.bool(forKey: "useFaceID")
        if useFaceID {
            authenticateWithFaceID()
        }
    }

    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to login."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        isAuthenticated = true
                    } else {
                        showAlert = true
                    }
                }
            }
        } else {
            showAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
