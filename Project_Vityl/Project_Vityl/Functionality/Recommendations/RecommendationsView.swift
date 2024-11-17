import SwiftUI

struct RecommendationsView: View {
    var viewModel: RecommendationsViewModel
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    let profile: Profile
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Top Hits Today (\(viewModel.topHitsToday.count))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)

                AlbumRow(albums: viewModel.topHitsToday)

                Text("Top \(viewModel.genreForFirstRecommendations.capitalized) (\(viewModel.firstGenreRecommendations.count))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)

                AlbumRow(albums: viewModel.firstGenreRecommendations)

                Text("Top \(viewModel.genreForSecondRecommendations.capitalized) (\(viewModel.secondGenreRecommendations.count))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)

                AlbumRow(albums: viewModel.secondGenreRecommendations)
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.initiateLoading()
        }
    }
}



struct AlbumRow: View {
    var albums: [Album]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(albums, id: \.id) { album in
                    VStack {
                        AsyncImage(url: URL(string: album.coverArt)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 120, height: 120)
                        .cornerRadius(10)

                        Text(album.title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)

                        Text(album.artist)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 140, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
            }
        }
    }
}



//#Preview {
//    let authenticationService = FakeAuthenticationService()
//    let previewContainer = ModelData.preview
//    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
//    if let currentUser = authenticationService.currentUser {
//      let profile = Profile(name: "Carmy the Chef")
//      currentUser.profile = profile
//        return NavigationStack { RecommendationsView(viewModel: RecommendationsViewModel(user: authenticationService.currentUser!), profile: currentUser.profile!, user: authenticationService.currentUser!) }
//        .environment(authenticationService)
//        .modelContainer(previewContainer)
//    } else {
//      return Text("Failed to create User")
//    }
//}
