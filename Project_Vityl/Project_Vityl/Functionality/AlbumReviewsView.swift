import SwiftUI
import SwiftData
import Foundation


struct AlbumReviewsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(FakeAuthenticationService.self) var authenticationService
    let profile: Profile

    var body: some View {
            List {
                ForEach(profile.user?.albums.filter { $0.hasReview } ?? [], id: \.id) { album in
                    HStack {
                        AsyncImage(url: URL(string: album.coverArt)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                        
                        VStack(alignment: .leading) {
                            Text(album.title)
                                .font(.headline)
                            Text(album.artist)
                                .font(.subheadline)
                            if let stars = album.stars {
                                // Assuming stars is a Double and not a Binding<Double>
                                StarRatings(Binding.constant(stars))
                                    .frame(height: 20) // Adjust height as necessary
                            }
                            if let review = album.reviewNote {
                                Text("Review: \(review)")
                                    .italic()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Album Reviews")
            .navigationBarTitleDisplayMode(.inline)
        }
    }


#Preview{
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
      let profile = Profile(name: "Carmy Berzatto")
      currentUser.profile = profile
      return NavigationStack { AlbumReviewsView(profile: currentUser.profile!) }
        .environment(authenticationService)
        .modelContainer(previewContainer)
    } else {
      return Text("Failed to create User")
    }
}
