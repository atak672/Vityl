import Foundation
import SwiftUI

@Observable
class AlbumLoader {
    let apiClient = LastFmAPIService()
    private(set) var state: LoadingState = .idle

    enum LoadingState {
        case idle
        case loading
        case success(data: VinylCreate)
        case failed(error: Error)
    }
    
    @MainActor
    func reset() {
        self.state = .idle
    }

    @MainActor
    func loadSynposis(artist: String, title: String) async {
        self.state = .loading
        do {
            let albumInfo = try await apiClient.getAlbumInfo(artist: artist, album: title)
            let vinyl = albumInfo.toVinylCreate()
            self.state = .success(data: vinyl)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
