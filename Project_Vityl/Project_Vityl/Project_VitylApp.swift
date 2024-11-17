
import SwiftUI
import SwiftData

@main
struct CS207_Project_VitylApp: App {
    
    let authenticationService = FakeAuthenticationService()
    var sharedModelContainer: ModelContainer = {
      let schema = Schema([
        User.self,
        Profile.self
      ])
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
      
      do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
      } catch {
        fatalError("Could not create ModelContainer: \(error)")
      }
    }()
    
    var body: some Scene {
        WindowGroup {
          WelcomeView()
            .onAppear { authenticationService.maybeLoginSavedUser(modelContext: sharedModelContainer.mainContext) }
        }
        .modelContainer(sharedModelContainer)
        .environment(authenticationService)
    }
}
