import Foundation

struct LastFmAPIService {
    let session: URLSession = .shared

    func getAlbumInfo(artist: String, album: String) async throws -> AlbumInfo {
        let path = LastFmEndpoint.getAlbumInfo(artist: artist, album: album)
        let response: AlbumInfoResponse = try await performRequest(url: path)
        return response.album
    }

    func performRequest<T: Codable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func getTopAlbums(tag: String, limit: Int = 5) async throws -> [TopAlbumInfo] {
        let path = LastFmEndpoint.getTopAlbums(tag: tag, limit: limit)
        do {
            let response: TopAlbumsResponse = try await performRequest(url: path)
            return response.albums.album
        } catch {
            throw error
        }
    }

}

struct TopAlbumsResponse: Codable {
    let albums: TopAlbums

    struct TopAlbums: Codable {
        let album: [TopAlbumInfo]
        let attr: Attr?

        struct Attr: Codable {
            let tag: String
            let page: String
            let perPage: String
            let totalPages: String
            let total: String
        }
    }
}


struct AlbumInfoResponse: Codable {
    let album: AlbumInfo
}

struct TopAlbumInfo: Codable {
    let name: String
    let mbid: String?
    let url: String
    let artist: Artist
    let images: [ImagePFP]
    let attr: Attr?

    struct Artist: Codable {
        let name: String
        let mbid: String?
        let url: String
    }

    struct Attr: Codable {
        let rank: String
    }

    enum CodingKeys: String, CodingKey {
        case name
        case mbid
        case url
        case artist
        case images = "image"
        case attr = "@attr"
    }

    func toVinylCreate() -> VinylCreate {
        let imageUrl = images.first(where: { $0.size == "large" })?.text ?? ""
        return VinylCreate(title: name, artist: artist.name, coverImage: imageUrl, genres: nil)
    }
}

struct AlbumInfo: Codable {
    let name: String
    let artist: String
    //let releaseDate: String
    let images: [ImagePFP]
    let tags: TagsContainer
    
    enum CodingKeys: String, CodingKey {
        case name
        case artist
        //case releaseDate = "releasedate"
        case images = "image"
        case tags = "tags"
    }
    
    struct TagsContainer: Codable {
        let tag: [Tag]
    }

    
    func toVinylCreate() -> VinylCreate {
        let imageUrl = images.first(where: { $0.size == "large" })?.text ?? ""
        let genres = tags.tag.first?.name ?? ""
        return VinylCreate(title: name, artist: artist, coverImage: imageUrl, genres: genres )
    }
}


struct ImagePFP: Codable {
    let text: String
    let size: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

struct tagResponse {
    
}

struct VinylCreate {
    let title: String
    let artist: String
    let coverImage: String
    //let releaseYear: String
    var genres: String?
}

struct Tag: Codable {
    let name: String
    let url: String
}

