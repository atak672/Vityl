import SwiftUI
import PhotosUI

struct AccountScreen: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(FakeAuthenticationService.self) var authenticationService
  @State var profileData: Profile.FormData?

  var body: some View {
    Group {
      if authenticationService.currentUser == nil {
        LoginScreen()
      } else if let currentUser = authenticationService.currentUser, let profile = currentUser.profile {
        VStack {
          AccountView(user: currentUser, profile: profile, isSelf: true)
//            .toolbar {
//              ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Edit") { profileData = profile.dataForForm }
//              }
//
//            }
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

struct AccountView: View {
    
    let user: User
    let profile: Profile
    let isSelf: Bool
    @Environment(FakeAuthenticationService.self) var authenticationService

    
    var body: some View {
        ScrollView{
            VStack {
                // Profile Picture and Account Name
                HStack(alignment: .center) {
                    AvatarImage(imageData: profile.avatar, size: 170)
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fill) // Changed to .fill to ensure it fills the frame
                        .clipped() // This will clip the overflowing content
                        .cornerRadius(60) // If you want it to be round
                        .padding()
                        
                       
                    VStack(alignment: .leading) {
                        Text(profile.name) //
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("\(user.email)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                
                // Action Buttons for Reviews and Collection
                HStack {
                    NavigationLink(destination: AlbumReviewsView(profile: profile)) {
                        Text(isSelf ? "View Your Reviews" : "View Their Reviews")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 180, height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: UserCollectionView(user: user, profile: user.profile!, isSelf: isSelf)) {
                        Text(isSelf ? "View Your Collection" : "View Their Collection")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 180, height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                        
                    }
                    
                }
                
                
                // User Statistics: Top Artists, Top Genres, Total Reviews
                // Usage within the AccountView
                VStack {
                    let artists = topArtists(albums: user.albums)
                    let genres = topGenres(albums: user.albums)
                    
                    if artists.count != 0 {
                        StatisticView(title: "Top Artists", values: artists)
                    }
                    if genres.count != 0{
                        StatisticView(title: "Top Genres", values: genres)
                    }
                }
                .padding()
                
                VStack {
                    Text("Collection Statistics")
                        .font(.title2) // Increased title size
                        .fontWeight(.bold)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        CompactStatisticView(title: "Albums", value: "\(user.albums.count)")
                        CompactStatisticView(title: "Artists", value: "\(topArtists(albums: user.albums).count)")
                        CompactStatisticView(title: "Genres", value: "\(topGenres(albums: user.albums).count)")
                    }
                    ValueStatisticView(value: user.valueCollection)
                }
                .frame(maxWidth: .infinity) // Ensuring the HStack takes full width
                .padding(.horizontal, 20) // Add horizontal padding
                .padding(.bottom,30)
                HStack (alignment: .center){
                    if isSelf {
                        NavigationLink(destination: ProfileEditForm(profileData:  profile.dataForForm)){
                            Text("Edit Account")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: 120)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .padding(.bottom, 10)
                        }
                    
                    
                        Button("Logout") { authenticationService.logout() }
                            .fontWeight(.bold) // Apply bold font weight to the text
                            .foregroundColor(.white) // Set the text color to white
                            .frame(maxWidth: 120) // Button width to maximum available width
                            .padding() // Padding around the text inside the button
                            .background(Color.red) // Background color of the button
                            .cornerRadius(8) // Rounded corners
                            .padding(.bottom, 10) // Padding at the bottom outside the button
                    }
                    
                  
                    
                   
                }
              
            }
        }
    }
    
}

struct StatisticView: View {
    let title: String
    let values: [String]
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2) // Increased title size
                .fontWeight(.bold)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .center) // Center the title

            VStack(alignment: .leading, spacing: 6) { // Increased spacing
                ForEach(values.indices, id: \.self) { index in
                    Text("\(index + 1). \(values[index])")
                        .font(.title3) // Increased font size for items
                        .padding(.vertical, 4)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
        }
        .padding(.vertical, 5)
    }
}

struct ValueStatisticView: View {
    let value: Double
    
    var body: some View {
        VStack {
            Text("Collection Value")
                .font(.caption) // Keep caption font size for titles
                .fontWeight(.bold)
            
            Text("$\(String(format: "%.2f", value))")
                .fontWeight(.bold)
        }
        .padding()
        .frame(minWidth: 100)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
        .padding(.horizontal, 10)
    }
}

struct CompactStatisticView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption) // Keep caption font size for titles
                .fontWeight(.bold)
            
            Text("\(value)")
                .font(.title3) // Use title3 for larger number display
                .fontWeight(.semibold)
        }
        .padding(12) // Add padding for better touch targets
        .frame(minWidth: 80) // Minimum width for uniformity
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 0.5))
        .padding(2)
    }
}


func topArtists(albums: [Album]) -> [String] {
    // Count the occurrences of each artist
    let artistCounts = albums.reduce(into: [:]) { counts, album in
        counts[album.artist, default: 0] += 1
    }
    
    // Sort the artists by occurrence count in descending order and get the top 3
    let sortedArtists = artistCounts.sorted { $0.value > $1.value }.map { $0.key }
    return Array(sortedArtists.prefix(3))
}

func topGenres(albums: [Album]) -> [String] {
    // Count the occurrences of each artist
    let genreCounts = albums.reduce(into: [:]) { counts, album in
        counts[album.genre, default: 0] += 1
    }
    
    // Sort the artists by occurrence count in descending order and get the top 3
    let sortedGenres = genreCounts.sorted { $0.value > $1.value }.map { $0.key }
    return Array(sortedGenres.prefix(3))
}


#Preview {
  let authenticationService = FakeAuthenticationService()
  let previewContainer = ModelData.preview
  authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
  if let currentUser = authenticationService.currentUser {
    let profile = Profile(name: "Carmy Berzatto")
    currentUser.profile = profile
    return NavigationStack { AccountView(user: authenticationService.currentUser!, profile: currentUser.profile!, isSelf: true) }
      .environment(authenticationService)
      .modelContainer(previewContainer)
  } else {
    return Text("Failed to create User")
  }
}
