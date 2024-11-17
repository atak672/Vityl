import SwiftUI

struct TabContainer: View {
  @Environment(FakeAuthenticationService.self) var authenticationService
  @Environment(\.modelContext) private var modelContext

    var body: some View {
        if authenticationService.currentUser != nil{
            HomeScreen()
            .navigationBarBackButtonHidden(true)
        }
        else {
            LoginScreen()
            .navigationBarBackButtonHidden(false)
        }
    }
}

#Preview {
  TabContainer()
    .environment(FakeAuthenticationService())
    .modelContainer(ModelData.preview)
}

