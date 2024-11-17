import Foundation
import SwiftUI
import SwiftData
import ScrobbleKit

struct AlbumView: View {
    @Environment(\.modelContext) var modelContext
    @State var album: Album
    @State private var isPresentingAlbumForm: Bool = false
    @State private var editAlbumFormData: Album.FormData = Album.FormData()
    @State var albumInfo: SBKAlbum? = nil
    @State private var showingEditForm = false
    @State private var editPurchasePrice: String = "0"
    @State private var deleteAlbum: Bool = false
    @Environment(FakeAuthenticationService.self) var authenticationService
    @State private var originalPurchasePrice: Double?
    var isSelf: Bool
    
    let manager = SBKManager(apiKey: APIKEY-ALBUM, secret: SECRET-KEY)

    
        var body: some View {
            ScrollView (.vertical){
                VStack(alignment: .center){
                    VStack(alignment: .center) {
                        let url = URL(string: album.coverArt)
                        AsyncImage(url: url){ image in image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
    
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .frame(maxWidth: 180, maxHeight: 180)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.black, lineWidth: 1) // Black border around the image
                    )
    
                    Text(album.title)
                        .font(.title)
                        .fontWeight(.semibold)
    
                    Text(album.artist)
                        .font(.title3)
    
                    Spacer()
                    
                    if isSelf == true {
                        if album.hasReview == false {
                            if isSelf {
                                Button("Add a Review") {
                                    editAlbumFormData = album.dataForForm
                                    isPresentingAlbumForm.toggle()
                                }
                                .sheet(isPresented: $isPresentingAlbumForm) {
                                    NavigationStack {
                                        NewReview(data: $editAlbumFormData)
                                            .toolbar {
                                                ToolbarItem(placement: .navigationBarLeading) {
                                                    Button("Cancel") { isPresentingAlbumForm.toggle() }
                                                    
                                                }
                                                ToolbarItem(placement: .navigationBarTrailing) {
                                                    Button("Save") {
                                                        Album.review(album, from: editAlbumFormData)
                                                        isPresentingAlbumForm.toggle()
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                            
                            
                        }
                        else {
                            if isSelf {
                                Button("Edit Your Review") {
                                    editAlbumFormData = album.dataForForm
                                    isPresentingAlbumForm.toggle()
                                }
                                .sheet(isPresented: $isPresentingAlbumForm) {
                                    NavigationStack {
                                        EditReview(data: $editAlbumFormData)
                                            .toolbar {
                                                ToolbarItem(placement: .navigationBarLeading) {
                                                    Button("Cancel") { isPresentingAlbumForm.toggle() }
                                                    
                                                }
                                                ToolbarItem(placement: .navigationBarTrailing) {
                                                    Button("Save") {
                                                        Album.review(album, from: editAlbumFormData)
                                                        isPresentingAlbumForm.toggle()
                                                    }
                                                }
                                            }
                                    }
                                }
                                
                                StarRatings($editAlbumFormData.stars)
                                Text(editAlbumFormData.reviewNote)
                            } else{ // Other people can only see review. Can't edit
                                StarRatings($editAlbumFormData.stars)
                                Text(editAlbumFormData.reviewNote)
                            }
                            
                        }
                    }
    
                }
    
                .onAppear {
                    Task {
                        do {
                            albumInfo = try await manager.getInfo(forAlbum: .albumArtist(album: album.title, artist: album.artist))
    
    
                        } catch {
                            albumInfo = nil
    
                        }
                    }
    
                }
                .padding()
                
                
    
                Text("Tracklist")
                    .font(.title2)
                    .underline()
                Spacer()
    
                VStack (alignment:.leading){
    
    
                    if (albumInfo == nil){
                        Text("No tracklist Info Available")
                    }
                    else{
                        let albumInfo = albumInfo!
                        let num = albumInfo.tracklist.count
                        ForEach(0...num-1, id: \.self) {i in
    
                            let track = albumInfo.tracklist[i]
                            HStack{
                                Text("\(i+1). \(track.name)")
                                    .lineLimit(2)
                            }
    
                        }
    
                    }
                }
                .frame(maxWidth: 300, alignment: .leading)
                Spacer()
            
                
            
                VStack (alignment: .center) {
                    Text("Notes")
                        .font(.title2)
                        .underline()
                    TextEditor(text: $album.notes)
                        .frame(width: 350, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1) // Black border around the VStack
                        )
                }
                .padding(23)
                
                
                
                Text("Date Added: \(Self.dateFormatter.string(from: album.dateAdded))")
                    .bold()
                    .fontWeight(.light)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    if (isSelf == true){
                        editPurchasePrice = String(album.purchasePrice)
                        originalPurchasePrice = album.purchasePrice
                        showingEditForm = true
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Assuming 'album.favorite' is a @State or @Binding property.
                    // This action will toggle its boolean value.
                    album.favorite.toggle()
                }) {
                    Image(systemName: album.favorite ? "star.fill" : "star")
                        .foregroundColor(album.favorite ? Color.yellow : Color.gray)
                }
            }
        }
        .sheet(isPresented: $showingEditForm) {
            EditAlbumForm(purchasePrice: $editPurchasePrice, deleteAlbum: $deleteAlbum,
                    onSubmit: {
                        if deleteAlbum {
                            deleteAlbumFromCollection(user: authenticationService.currentUser!, album: album)
                        } else if let newPrice = Double(editPurchasePrice), newPrice != album.purchasePrice {
                            // Save the old price in case you need to revert or for history tracking
                            let oldPrice = album.purchasePrice
                            
                            // Update the album with the new price
                            updateAlbumPrice(user: authenticationService.currentUser!, album: album, price: newPrice)
                            
                            // Optionally do something with oldPrice if needed
                        }
                        showingEditForm = false
                    },
                    onCancel: {
                        // Reset the state if canceling
                        showingEditForm = false
                        deleteAlbum = false
                    }
                )
                .onAppear {
                    // Initialize the editPurchasePrice with the current album purchase price
                    editPurchasePrice = String(album.purchasePrice)
                    
                }
       }
        .onAppear {
            if album.hasReview {
                editAlbumFormData = album.dataForForm
            } else {
                editAlbumFormData = Album.FormData()
            }
        }
    }
    
    func updateAlbumPrice(user: User, album: Album, price: Double){
        user.valueCollection -= album.purchasePrice
        user.valueCollection += price
        album.purchasePrice = price
    }
    
    func deleteAlbumFromCollection(user: User, album: Album) {
        user.valueCollection -= album.purchasePrice
        if let index = user.albums.firstIndex(where: { $0.id == album.id }) {
            user.albums.remove(at: index)
        }
    }
    
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter
        }()
}


#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    let album = Album.previewData[1]
    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
      let profile = Profile(name: "Carmy the Chef")
      currentUser.profile = profile
        return NavigationStack { AlbumView(album:album, isSelf: true) }
        .environment(authenticationService)
        .modelContainer(previewContainer)
    } else {
      return Text("Failed to create User")
    }
}
