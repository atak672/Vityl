import Foundation

struct LastFmEndpoint {
    static let baseUrl = "https://ws.audioscrobbler.com/2.0/"
    static let apiKey = APIKEY-FM
    
    static func getAlbumInfo(artist: String, album: String) -> String {
        let encodedArtist = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedAlbum = album.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(baseUrl)?method=album.getinfo&api_key=\(apiKey)&artist=\(encodedArtist)&album=\(encodedAlbum)&format=json"
    }
    
    static func getAlbumTags(artist: String, album: String) -> String {
        let encodedArtist = artist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedAlbum = album.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(baseUrl)?method=album.gettags&api_key=\(apiKey)&artist=\(encodedArtist)&album=\(encodedAlbum)&format=json"
    }
    
    static func getTopAlbums(tag: String, limit: Int = 5) -> String {
        let encodedTag = tag.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(baseUrl)?method=tag.gettopalbums&tag=\(encodedTag)&api_key=\(apiKey)&format=json&limit=\(limit)"
    }
}
