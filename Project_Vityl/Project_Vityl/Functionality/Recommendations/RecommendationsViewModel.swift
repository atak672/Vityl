import Foundation
import SwiftUI
import SwiftData

@Observable
class RecommendationsViewModel {
    var topHitsToday: [Album] = []
    var firstGenreRecommendations: [Album] = []
    var secondGenreRecommendations: [Album] = []
    private let service = LastFmAPIService()
    var user: User
    
    var genreForFirstRecommendations: String = ""
    var genreForSecondRecommendations: String = ""

    init(user: User) {
        self.user = user
    }

    func initiateLoading() {
        Task {
            await loadRecommendations()
        }
    }

    private func topGenres(from albums: [Album]) -> [String] {
        var genreCounts = [String: Int]()
        for album in albums {
            let genre = album.genre
            genreCounts[genre, default: 0] += 1
        }
        return genreCounts.sorted { $0.value > $1.value }
                       .map { $0.key }
    }

    func loadRecommendations() async {
        let genres = topGenres(from: user.albums)
        topHitsToday = await fetchAndConvertAlbums(for: "pop", limit: 5)
        
        if genres.isEmpty {
            genreForFirstRecommendations = "country"
        } else {
            genreForFirstRecommendations = genres[0]
        }
        
        firstGenreRecommendations = await fetchAndConvertAlbums(for: genreForFirstRecommendations, limit: 5)
        
        if genres.count < 2 {
            genreForSecondRecommendations = "disco"
        } else {
            genreForSecondRecommendations = genres[1]
        }
        
        secondGenreRecommendations = await fetchAndConvertAlbums(for: genreForSecondRecommendations, limit: 5)
    }


    private func fetchAndConvertAlbums(for genre: String, limit: Int) async -> [Album] {
        do {
            let albumInfos = try await service.getTopAlbums(tag: genre, limit: limit)
            return albumInfos.map { VinylCreate.toAlbum($0.toVinylCreate()) }
        } catch {
            print("Error fetching albums for \(genre): \(error)")
            return []
        }
    }
}

extension VinylCreate {
    static func toAlbum(_ vinyl: VinylCreate) -> Album {
        return Album(title: vinyl.title, artist: vinyl.artist, coverArt: vinyl.coverImage, dateAdded: Date(), genre: vinyl.genres ?? "", purchasePrice: 0.0)
    }
}



