import Foundation
import SwiftData

@Model
class AlbumWish: Identifiable {
    var id: String
    var name: String
    var artist: String
    var coverUrl: URL?
    var isInWishlist: Bool

    init(id: String, name: String, artist: String, coverUrl: URL? = nil, isInWishlist: Bool = false) {
        self.id = id
        self.name = name
        self.artist = artist
        self.coverUrl = coverUrl
        self.isInWishlist = isInWishlist
    }

    struct FormData {
        var id: String = ""
        var name: String = ""
        var artist: String = ""
    }

    var dataForForm: FormData {
        FormData(id: id, name: name, artist: artist)
    }

    static func create(from formData: FormData, context: ModelContext) {
        let album = AlbumWish(id: formData.id, name: formData.name, artist: formData.artist)
        context.insert(album)
    }
}

extension AlbumWish {
    static let previewData = [
        AlbumWish(id: "123456", name: "Thriller", artist: "Michael Jackson", coverUrl: URL(string:"https://example.com/thriller.jpg")!),
        AlbumWish(id: "234567", name: "Back in Black", artist: "AC/DC", coverUrl: URL(string:"https://example.com/backinblack.jpg")!),
        AlbumWish(id: "345678", name: "The Dark Side of the Moon", artist: "Pink Floyd", coverUrl: URL(string:"https://example.com/darkside.jpg")!)
    ]
}
