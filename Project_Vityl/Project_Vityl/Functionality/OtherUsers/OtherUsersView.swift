import SwiftUI
import SwiftData

struct OtherUsersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var allUsers: [User]  // Assuming this fetches all User objects

    var body: some View {
        NavigationView {
            List(allUsers) { user in
                let profile = user.profile
                NavigationLink(destination: Group {
                    if user.profile != nil {
                        AccountView(user: user, profile: user.profile!, isSelf: false)
                    } else {
                        Text("Profile not available")
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(user.name)  // Display the user's name
                        // Add more details as needed
                    }
                }
            }
            .navigationTitle("Other Users")
        }
    }
}

#Preview {
    OtherUsersView()
        .environment(FakeAuthenticationService())
        .modelContainer(ModelData.preview)
}
