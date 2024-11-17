import Foundation
import SwiftUI
import ScrobbleKit
import SwiftUI

import SwiftUI

struct AlbumDetailView: View {
    let artist: String
    let title: String
    let coverArt: String
    @State private var albumInfo: SBKAlbum? = nil
    let manager = SBKManager(apiKey: "05305e08f48b3ae62001d827cad81618", secret: "49bf2a95b98853d05b8b0bd9717011a4")
    var user: User
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            AsyncImage(url: URL(string: coverArt)) {
                image in image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 200, height: 200)
            .cornerRadius(10)
            
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            Text(artist)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 20){
                Button(action: addAlbumToCollection) {
                    Label("Add to my collection", systemImage: "heart")
                }
                Button(action: removeAlbumFromWishlist) {
                    Label("Remove from wishlist", systemImage: "xmark")
                }
            }
            
            VStack(alignment: .leading){
                Text("Tracklist")
                    .font(.headline)
                if let tracklist = albumInfo?.tracklist {
                    ForEach(tracklist.indices, id: \.self) { index in
                        let track = tracklist[index]
                        Text("\(index + 1). \(track.name)")
                    }
                } else {
                    Text("Loading tracklist...")
                }
            }
        }
        .onAppear {
            loadAlbumInfo()
        }
        .padding()
    }

    private func loadAlbumInfo() {
        Task {
            do {
                albumInfo = try await manager.getInfo(forAlbum: .albumArtist(album: title, artist: artist))
            } catch {
                print("Failed to fetch album info")
                albumInfo = nil
            }
        }
    }
    
    private func addAlbumToCollection() {
        let newAlbum = Album(title: title, artist: artist, coverArt: coverArt)
        if !user.albums.contains(newAlbum) {
            user.albums.append(newAlbum)
            removeAlbumFromWishlist()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func removeAlbumFromWishlist() {
        user.wishlistAlbums.removeAll { $0.title == title && $0.artist == artist && $0.coverArt == coverArt }
    }
}



//#Preview {
//    let authenticationService = FakeAuthenticationService()
//    let previewContainer = ModelData.preview
//    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
//    if let currentUser = authenticationService.currentUser {
//        let profile = Profile(name: "Carmy the Chef")
//        currentUser.profile = profile
//        return NavigationStack {
//            AlbumDetailView(
//                artist: "Radiohead",
//                title: "OK Computer",
//                coverArt: "https://upload.wikimedia.org/wikipedia/en/b/ba/Radioheadokcomputer.png",
//                user: currentUser
//            )
//        }
//    } else {
//        return Text("Failed to create User")
//    }
//}

