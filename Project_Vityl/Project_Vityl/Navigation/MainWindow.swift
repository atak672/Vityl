import SwiftUI

struct HomeScreen: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(FakeAuthenticationService.self) var authenticationService
  @State var profileData: Profile.FormData?

  var body: some View {
    Group {
      if authenticationService.currentUser == nil {
        LoginScreen()
      } else if let currentUser = authenticationService.currentUser, let _ = currentUser.profile {
        VStack {
            MainWindow()
            Spacer()
        }
      } else {
        Text("Please create a Profile")
          .onAppear { setUpUserAndProfile() }
      }
    }
    .sheet(item: $profileData) { item in
      ProfileEditForm(profileData: item)
    }
  }

  func setUpUserAndProfile() {
    if let user = authenticationService.currentUser,
        user.profile == nil {
      let user = authenticationService.currentUser!
      user.profile = Profile(name: user.name)
      profileData = user.profile?.dataForForm
    }
  }

}

struct MainWindow: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @State private var recommendedAlbum: String = "Album Name"
    var body: some View {
        if (authenticationService.currentUser != nil) {
            TabView {
                NavigationStack {
                    VStack {
                        Text("Vityl")
                            .font(.custom("Futura", size: 50))
                            .fontWeight(.medium)
                        Text("Good afternoon " + (authenticationService.currentUser?.name ?? "User"))
                            .multilineTextAlignment(.center)
                        Spacer()
                        NavigationLink(destination: AddNewAlbum(user: authenticationService.currentUser!)) {
                            Text("Add to Collection")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 45)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        NavigationLink(destination: RecommendationsView(viewModel: RecommendationsViewModel(user: authenticationService.currentUser!), profile: authenticationService.currentUser!.profile!, user: authenticationService.currentUser!)) {
                            Text("Recommendations")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 45)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        NavigationLink(destination: WishlistView(wishlistAlbums: authenticationService.currentUser!.wishlistAlbums, user: authenticationService.currentUser!)) {
                            Text("Wishlist")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 45)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        NavigationLink(destination: OtherUsersView()) {
                            Text("Other User Profiles")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 45)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                        Text("You should try listening to\n \(recommendedAlbum)!")
                            .multilineTextAlignment(.center)
                            .onAppear {
                                recommendRandomAlbum()
                            }
                        Spacer()
                    }
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                NavigationStack {
                    MainDiscussionView( user: authenticationService.currentUser!)
                }
                .tabItem {
                    Label("Community", systemImage: "person.3")
                }
                NavigationStack {
                    AccountScreen()
                }
                .tabItem {
                    Label("My Account", systemImage: "person.circle.fill")
                }
            }
        } else {
            Text("Authentication Service not found")
        }
    }
    func recommendRandomAlbum() {
        recommendedAlbum = Album.albumNames.randomElement() ?? "No Album Available"
    }
}

#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
      let profile = Profile(name: "Carmy the Chef")
      currentUser.profile = profile
      return NavigationStack { MainWindow() }
        .environment(authenticationService)
        .modelContainer(previewContainer)
    } else {
      return Text("Failed to create wishlist view")
    }
}

