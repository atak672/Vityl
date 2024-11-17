import Foundation
import SwiftData
import SwiftUI

struct AddAlbumView: View {
    @State private var albumLoader = AlbumLoader()
    @State private var searchArtist = ""
    @State private var searchTitle = ""
    @State private var price = ""
    @Environment(\.modelContext) private var modelContext
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.presentationMode) var presentationMode
    let user: User
    @State private var vinyl: VinylCreate = VinylCreate(title: "", artist: "", coverImage: "")
    @State private var successfulAdd: Bool = false
    @State private var showMessage: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
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
                        EmptyView()
                    case .loading:
                        ProgressView()
                    case .failed:
                        Text("No Information Available")
                    case .success(let vinyl):
                        if !vinyl.artist.isEmpty {
                            albumDetails(vinyl: vinyl)
                        }
                    }
                }
                .padding()
                .onAppear {
                    albumLoader.reset()
                }

                if showMessage {
                    Text(successfulAdd ? "Album Successfully Added" : "Album Already Added")
                        .padding()
                        .background(successfulAdd ? Color.green : Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .opacity(showMessage ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: showMessage)
                }
            }
            .navigationTitle("Album Search")
        }
    }

    private func albumDetails(vinyl: VinylCreate) -> some View {
        VStack {
            HStack {
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
                    Text(vinyl.title)
                        .font(.headline)
                    
                    Text(vinyl.artist)
                        .font(.subheadline)
                }
                Spacer()
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

            Button(action: {
                let purchase = Double(price) ?? 0
                let newAlbum = Album(title: vinyl.title, artist: vinyl.artist, coverArt: vinyl.coverImage, genre: vinyl.genres ?? "", purchasePrice: purchase)
                if !user.wishlistAlbums.contains(where: { $0.title.lowercased() == newAlbum.title.lowercased() }) {
                    user.wishlistAlbums.append(newAlbum)
                    successfulAdd = true
                    presentationMode.wrappedValue.dismiss()
                } else {
                    successfulAdd = false
                }
                withAnimation {
                    showMessage = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showMessage = false
                    }
                }
            }) {
                Text("Add")
            }

            if showMessage {
                Text(successfulAdd ? "Album Successfully Added" : "Album Already Added")
                    .padding()
                    .background(successfulAdd ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .opacity(showMessage ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: showMessage)
            }
        }
    }
}







//struct AddAlbumView: View {
//    @State var albumLoader = AlbumLoader()
//    @State private var searchArtist = ""
//    @State private var searchTitle = ""
//    @State private var price = ""
//    @Environment(\.modelContext) private var modelContext
//    @Environment(FakeAuthenticationService.self) var authenticationService
//    let user: User
//    @State var vinyl: VinylCreate = VinylCreate(title: "", artist: "", coverImage: "")
//    @State var successfulAdd: Bool = false
//    @State private var showMessage: Bool = false
//    @State private var showForm: Bool = true
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                if showForm{
//                    VStack(spacing: 15) {
//                        TextField("Search for artist...", text: $searchArtist)
//                            .padding()
//                            .overlay(RoundedRectangle(cornerRadius: 10.0)
//                                .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
//                            .padding()
//                            .disableAutocorrection(true)
//                        
//                        TextField("Search for album...", text: $searchTitle)
//                            .padding()
//                            .overlay(RoundedRectangle(cornerRadius: 10.0)
//                                .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
//                            .padding()
//                            .disableAutocorrection(true)
//                        
//                        Button("Search Albums") {
//                            Task {
//                                await albumLoader.loadSynposis(artist: searchArtist, title: searchTitle)
//                            }
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .disabled(searchArtist.isEmpty || searchTitle.isEmpty)
//                        .padding()
//                        
//                        switch albumLoader.state {
//                        case .idle:
//                            Color.clear
//                        case .loading:
//                            ProgressView()
//                        case .failed(_):
//                            Text("No Information Available")
//                        case .success(let vinyl):
//                            if !vinyl.artist.isEmpty {
//                                VStack {
//                                    HStack {
//                                        if let imageUrl = URL(string: vinyl.coverImage) {
//                                            AsyncImage(url: imageUrl) { image in
//                                                image.resizable()
//                                            } placeholder: {
//                                                Image(systemName: "photo")
//                                                    .resizable()
//                                                    .scaledToFit()
//                                            }
//                                            .frame(width: 100, height: 100)
//                                            .cornerRadius(10)
//                                        } else {
//                                            Rectangle()
//                                                .fill(Color.secondary)
//                                                .frame(width: 100, height: 100)
//                                                .cornerRadius(10)
//                                        }
//                                        
//                                        VStack(alignment: .leading) {
//                                            Text(vinyl.title)
//                                                .font(.headline)
//                                            
//                                            Text(vinyl.artist)
//                                                .font(.subheadline)
//                                        }
//                                        Spacer()
//                                    }
//                                    .padding()
//                                    .background(RoundedRectangle(cornerRadius: 10)
//                                        .strokeBorder(Color.gray, lineWidth: 1))
//                                    .padding(.horizontal)
//                                    
//                                    TextField("Purchase Price", text: $price)
//                                        .padding()
//                                        .overlay(RoundedRectangle(cornerRadius: 10.0)
//                                            .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
//                                        .padding()
//                                        .disableAutocorrection(true)
//                                    
//                                    Button(action: {
//                                        let purchase = Double(price) ?? 0
//                                        let newAlbum = Album(title: vinyl.title, artist: vinyl.artist, coverArt: vinyl.coverImage, genre: vinyl.genres ?? "", purchasePrice: purchase)
//                                        if !user.wishlistAlbums.contains(where: { $0.title.lowercased() == newAlbum.title.lowercased() }) {
//                                            user.wishlistAlbums.append(newAlbum)
//                                            successfulAdd = true
//                                            showForm = false
//                                        } else {
//                                            successfulAdd = false
//                                        }
//                                        withAnimation {
//                                            showMessage = true
//                                        }
//                                        
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                            withAnimation {
//                                                showMessage = false
//                                            }
//                                        }
//                                    }) {
//                                        Text("Add")
//                                    }
//                                    
//                                    if showMessage {
//                                        Text(successfulAdd == true ? "Album Successfully Added" : "Album Already Added")
//                                            .padding()
//                                            .background(successfulAdd == true ? Color.green : Color.red)
//                                            .foregroundColor(.white)
//                                            .cornerRadius(10)
//                                            .opacity(showMessage ? 1 : 0)
//                                            .animation(.easeInOut(duration: 0.5), value: showMessage)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                    .onAppear{
//                        albumLoader.reset()
//                    }
//                }
//            }
//            .navigationTitle("Album Search")
//        }
//    }
//}

                             





