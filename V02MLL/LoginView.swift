import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isAuthenticated: Bool
    @Binding var showAlert: Bool
    @Binding var useFaceID: Bool

    var body: some View {
        VStack {
            TextField("Username", text: $username, onCommit: {
                UIApplication.shared.endEditing()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password, onCommit: {
                UIApplication.shared.endEditing()
            })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: authenticate) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .hideKeyboardOnTap()
    }
    
    func authenticate() {
        if username == "" && password == "" {
            showFaceIDPrompt()
        } else {
            showAlert = true
        }
    }

    func showFaceIDPrompt() {
        let alert = UIAlertController(title: "Enable Face ID", message: "Do you want to use Face ID for future logins?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            UserDefaults.standard.set(true, forKey: "useFaceID")
            self.isAuthenticated = true
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            UserDefaults.standard.set(false, forKey: "useFaceID")
            self.isAuthenticated = true
        }))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }
}
