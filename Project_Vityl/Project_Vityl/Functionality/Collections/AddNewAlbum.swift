import SwiftUI
import Foundation

struct AddNewAlbum: View {
    @State var albumLoader = AlbumLoader()
    @State private var searchArtist = ""
    @State private var searchTitle = ""
    @State private var price = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(FakeAuthenticationService.self) var authenticationService
    let user: User
    @State var vinyl: VinylCreate = VinylCreate(title: "", artist: "", coverImage: "")
    @State var successfulAdd: Bool = false
    @State private var showMessage: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Search for artist...", text: $searchArtist)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                        .padding()
                        .disableAutocorrection(true)
                        
                    TextField("Search for album...", text: $searchTitle)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10.0)
                            .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                        .padding()
                        .disableAutocorrection(true)

                    Button("Search Albums") {
                        Task {
                            await albumLoader.loadSynposis(artist: searchArtist, title: searchTitle)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(searchArtist.isEmpty || searchTitle.isEmpty)
                    .padding()

                    switch albumLoader.state {
                    case .idle:
                        Color.clear
                    case .loading:
                        ProgressView()
                    case .failed(_):
                        Text("No Information Available")
                    case .success(let vinyl):
                        if (vinyl.artist != ""){
                            VStack {
                                HStack {
                                    // Album Image
                                    if let imageUrl = URL(string: vinyl.coverImage) {
                                        AsyncImage(url: imageUrl) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    } else {
                                        Rectangle()
                                            .fill(Color.secondary)
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        // Album Title
                                        Text(vinyl.title)
                                            .font(.headline)
                                        
                                        // Artist Name
                                        Text(vinyl.artist)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                
                                    
                                    Button(action: {
                                        let purchase = Double(price) ?? 0
                                        let newAlbum = Album(title: vinyl.title, artist: vinyl.artist, coverArt: vinyl.coverImage, genre: vinyl.genres ?? "", purchasePrice: purchase)
                                        if !user.albums.contains(where: { $0.title.lowercased() == newAlbum.title.lowercased() }) {
                                            user.albums.append(newAlbum)
                                            user.valueCollection += purchase
                                            successfulAdd = true
                                        } else {
                                            user.albums.append(newAlbum)
                                            user.valueCollection += purchase
                                            successfulAdd = true
                                        }
                                        // Trigger the message display
                                        withAnimation {
                                            showMessage = true
                                        }
                                        // Set a timer to hide the message after 2 seconds
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            withAnimation {
                                                showMessage = false
                                            }
                                        }
                                    }) {
                                        Text("Add")
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.gray, lineWidth: 1))
                                .padding(.horizontal)
                                
                                TextField("Purchase Price", text: $price)
                                    .padding()
                                    .overlay(RoundedRectangle(cornerRadius: 10.0)
                                        .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                                    .padding()
                                    .disableAutocorrection(true)
                                
                                
                                // Show success or failure message based on the state of successfulAdd
                                if showMessage {
                                    Text(successfulAdd == true ? "Album Successfully Added" : "Album Already Added")
                                        .padding()
                                        .background(successfulAdd == true ? Color.green : Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .opacity(showMessage ? 1 : 0) // This will animate the opacity
                                        .animation(.easeInOut(duration: 0.5), value: showMessage)
                                }
                            }
                        }
                    }
                }
                .onAppear{
                    Task {
                            self.albumLoader.reset()
                        }
                }
            }
        }
        .navigationTitle("Album Search")
    }
}



#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
        let profile = Profile(name: "Carmy the Chef")
        currentUser.profile = profile
        return NavigationStack {AddNewAlbum(user: authenticationService.currentUser!)
                .environment(authenticationService)
                .modelContainer(previewContainer)
        }
    }
    else {
      return Text("Failed to create User")
    }
}
