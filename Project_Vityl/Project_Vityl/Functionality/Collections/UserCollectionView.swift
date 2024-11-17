import Foundation
import SwiftUI
import SwiftData
import AuthenticationServices


struct UserCollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(FakeAuthenticationService.self) var authenticationService
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let user: User
    let profile: Profile
    let isSelf: Bool
    @State private var sortOption: AlbumSortOption = .dateAdded
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                HStack{
                    Picker(selection: $sortOption, label: Text("Sorting")) {
                        Text("Date Added").tag(AlbumSortOption.dateAdded)
                        Text("Artist").tag(AlbumSortOption.artistName)
                        Text("Album Title").tag(AlbumSortOption.albumTitle)
                        Text("Favorited").tag(AlbumSortOption.favorite)
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                if user.albums.count > 0 {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sortedAlbums()) { album in
                            NavigationLink(destination: AlbumView(album: album, isSelf: isSelf)){
                                VStack {
                                    if let url = URL(string: album.coverArt) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 115) // Match this width to the width of your album art
                                        .cornerRadius(6)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 3)
                                                .stroke(Color.black, lineWidth: 1) // Black border around the image
                                        )
                                    } else {
                                        Text("No Image URL Available").foregroundColor(.black)
                                    }
                                    
                                    Text(album.title)
                                        .foregroundColor(.black)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Text(album.artist)
                                        .foregroundColor(.black)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                }
                                //i.frame(minHeight: 170)
                                .background(Color.cyan)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1) 
                                )
                                .frame(minWidth: 120)
                            }
                        }
                    }
                    .padding()
                } else {
                    VStack { // Adjust spacing as needed
                        Image("sad_vinyl")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200) // Adjust width and height as needed
                        
                        Text("There's Nothing Here")
                            .font(.custom("Futura", size: 30))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                    }
                    .padding([.leading, .trailing], 24)
                }
            }
        }
        .navigationTitle("Collection")
        .navigationBarItems(trailing: Group {
            if isSelf {
                NavigationLink(destination: AddNewAlbum(user: user)) {
                    Text("Add New")
                }
            }
        })
    }
    
    
    func sortedAlbums() -> [Album] {
        switch sortOption {
        case .dateAdded:
            return user.albums.sorted { $0.dateAdded > $1.dateAdded }
        case .artistName:
            return user.albums.sorted { $0.artist.localizedCaseInsensitiveCompare($1.artist) == .orderedAscending }
        case .albumTitle:
            return user.albums.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .favorite:
            return user.albums.filter {$0.favorite == true}
        }
        
    }
    
    enum AlbumSortOption {
        case dateAdded, artistName, albumTitle, favorite
    }
    

}
    

#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
      let profile = Profile(name: "Carmy the Chef")
      currentUser.profile = profile
        return NavigationStack { UserCollectionView(user: authenticationService.currentUser!, profile: currentUser.profile!, isSelf: false) }
        .environment(authenticationService)
        .modelContainer(previewContainer)
    } else {
      return Text("Failed to create User")
    }
}
