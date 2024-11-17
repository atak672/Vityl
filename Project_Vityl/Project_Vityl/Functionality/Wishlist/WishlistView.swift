import Foundation
import SwiftUI
import SwiftData

struct WishlistView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(FakeAuthenticationService.self) var authenticationService
    var wishlistAlbums: [Album]
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State var showingAddAlbum = false
    @State var showingAlbumDetail = false
    let user: User
    var loader = AlbumLoader()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if user.wishlistAlbums.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .foregroundColor(.gray)

                        Text("Wishlist is empty :(")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(wishlistAlbums) { album in
                            NavigationLink(destination: AlbumDetailView(artist: album.artist, title: album.title, coverArt: album.coverArt, user: user)) {
                                VStack {
                                    if let url = URL(string: album.coverArt) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray.frame(width: 100, height: 100)
                                        }
                                        .frame(width: 115, height: 115)
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                    } else {
                                        Rectangle()
                                            .fill(Color.secondary)
                                            .frame(width: 115, height: 115)
                                            .cornerRadius(6)
                                    }
                                    
                                    Text(album.title)
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Text(album.artist)
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(minWidth: 120, minHeight: 160) 
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Wishlist")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.showingAddAlbum = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAlbum) {
                AddAlbumView(user: user)
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
//      return NavigationStack { WishlistView(user: authenticationService.currentUser!) }
//        .environment(authenticationService)
//        .modelContainer(previewContainer)
//    } else {
//      return Text("Failed to create wishlist view")
//    }
//}










