import SwiftUI

struct OtherView: View {
    @Binding var isAuthenticated: Bool
    @State private var showListView = false

    var body: some View {
        VStack {
            Spacer()
            
            Button(action: logout) {
                Text("Logout")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            NavigationLink(destination: CustomListView()) {
                Text("List")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
    }
    
    func logout() {
        isAuthenticated = false
        UserDefaults.standard.set(false, forKey: "useFaceID")
    }
}

struct OtherView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView(isAuthenticated: .constant(true))
    }
}
