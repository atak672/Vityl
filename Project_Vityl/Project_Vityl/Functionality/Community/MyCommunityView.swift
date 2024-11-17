import SwiftUI

struct CommunityView: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        TabView {
            NavigationStack {
                VStack {
                    Text("My Community")
                        .font(.custom("Futura", size: 40)) 
                        .fontWeight(.medium)
                        .padding()
//                    NavigationLink(destination: MainDiscussionView()) {
//                        Text("Discussions")
//                            .font(.custom("Futura", size: 20))
//                            .padding()
//                    }
                    
//                    NavigationLink(destination: MainDiscussionView()) {
//                        Text("Marketplace")
//                            .font(.custom("Futura", size: 20))
//                    }
                    
                }
            }
        }
    }
}

#Preview {
  CommunityView()
        .environment(FakeAuthenticationService())
        .modelContainer(ModelData.preview)
}
