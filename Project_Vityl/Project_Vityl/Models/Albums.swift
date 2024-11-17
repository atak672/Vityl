import Foundation
import SwiftUI
import SwiftData

@Model
class Album: Identifiable { // Might have to change this so each instance has a new album ID, incase people have the same album in their collection
    var id: UUID = UUID()
    var title: String
    var artist: String
    var coverArt: String
    var dateAdded: Date
    var stars: Double?
    var reviewNote: String?
    var hasReview: Bool
    var notes: String = ""
    var favorite: Bool = false
    var isInWishlist: Bool = false
    var genre: String
    var purchasePrice: Double = 0

    
    
    init(title: String, artist: String, coverArt: String, dateAdded: Date = Date(), stars: Double? = nil, reviewNote: String? = nil, hasReview: Bool = false, notes: String = "", favorite: Bool = false, isInWishlist: Bool = false, genre: String = "", purchasePrice: Double = 0) {
        self.title = title
        self.artist = artist
        self.coverArt = coverArt
        self.dateAdded = dateAdded
        self.stars = stars
        self.reviewNote = reviewNote
        self.hasReview = hasReview
        self.notes = notes
        self.favorite = favorite
        self.isInWishlist = isInWishlist
        self.genre = genre
        self.purchasePrice = purchasePrice
    }
    
    
    struct FormData {
        var title: String = ""
        var artist: String = ""
        var coverArt: String = ""
        var dateAdded: Date = Date.now
        var stars: Double = 0.0
        var reviewNote: String = ""
        var hasReview: Bool = false
        var genre: String = ""
        var purchasePrice: Double = 0
        
    }
    var dataForForm: FormData {
        FormData(
            title: title,
            artist: artist,
            coverArt: coverArt,
            stars: stars ?? 0.0,
            reviewNote: reviewNote ?? "",
            genre: genre,
            purchasePrice: purchasePrice
        )
    }
    static func create(from formData: FormData, context: ModelContext) {
        let album = Album(title: formData.title, artist: formData.artist, coverArt: formData.coverArt, dateAdded: formData.dateAdded, genre: formData.genre, purchasePrice: formData.purchasePrice)
        Album.update(album, from: formData)
        context.insert(album)
    }
    
    static func update(_ album: Album, from formData: FormData) {
        album.title = formData.title
        album.artist = formData.artist
        album.coverArt = formData.coverArt
        album.dateAdded = formData.dateAdded
        album.genre = formData.genre
        album.purchasePrice = formData.purchasePrice
    }
    
    static func review(_ album: Album, from formData: FormData) {
        album.stars = formData.stars
        album.reviewNote = formData.reviewNote.isEmpty ? nil : formData.reviewNote
        album.hasReview = true
    }
    
   }



extension Album {
    static let previewData: [Album] =  [
        Album(title: "Taylor Swift", artist: "Taylor Swift", coverArt: "https://www.udiscovermusic.com/wp-content/uploads/2018/09/Taylor-Swift-debut-album-cover-web-optimised-820.jpg", dateAdded: Date(), stars: 3.5, reviewNote: "fun album!", hasReview: true, genre: "Country", purchasePrice: 10),
        Album(title: "Fearless", artist: "Taylor Swift", coverArt: "https://thecentraltrend.com/wp-content/uploads/2021/04/Screen-Shot-2021-04-13-at-11.09.29-PM.png", dateAdded: Date(), hasReview: false, genre: "Country", purchasePrice: 10),
        Album(title: "Speak Now", artist: "Taylor Swift", coverArt: "https://upload.wikimedia.org/wikipedia/en/8/8f/Taylor_Swift_-_Speak_Now_cover.png", dateAdded: Date(), hasReview: false, genre: "Country", purchasePrice: 10),
        Album(title: "Red", artist: "Taylor Swift", coverArt: "https://upload.wikimedia.org/wikipedia/en/thumb/4/47/Taylor_Swift_-_Red_%28Taylor%27s_Version%29.png/220px-Taylor_Swift_-_Red_%28Taylor%27s_Version%29.png", dateAdded: Date(), hasReview: false, genre: "Pop", purchasePrice: 10),
        Album(title: "1989", artist: "Taylor Swift", coverArt: "https://hips.hearstapps.com/hmg-prod/images/7-64ecb1c909b78.png?crop=0.502xw:1.00xh;0.498xw,0&resize=1200:*", dateAdded: Date(), hasReview: false, genre: "Pop", purchasePrice: 10),
        Album(title: "Reputation", artist: "Taylor Swift", coverArt: "https://m.media-amazon.com/images/I/91VnI1TRpxL._UF1000,1000_QL80_.jpg", dateAdded: Date(), hasReview: false, genre: "Pop", purchasePrice: 10),
        Album(title: "Lover", artist: "Taylor Swift", coverArt: "https://external-preview.redd.it/ZcMt1KbeWI8JUuEzdFBJsP6zxdv7bWKXRQ8DHZv95co.jpg?auto=webp&s=b91c0b6049e1be895b8712c8a84841a2a324d515", dateAdded: Date(), hasReview: false, genre: "Pop", purchasePrice: 10),
        Album(title: "Folklore", artist: "Taylor Swift", coverArt: "https://upload.wikimedia.org/wikipedia/en/f/f8/Taylor_Swift_-_Folklore.png", dateAdded: Date(), hasReview: false, genre: "Folk", purchasePrice: 10),
        Album(title: "Evermore", artist: "Taylor Swift", coverArt: "https://upload.wikimedia.org/wikipedia/en/0/0a/Taylor_Swift_-_Evermore.png", dateAdded: Date(), hasReview: false, genre: "Folk", purchasePrice: 10)]
    
    static let albumNames = [
        "Dark Side of the Moon - Pink Floyd",
        "Thriller - Michael Jackson",
        "Abbey Road - The Beatles",
        "The Queen Is Dead - The Smiths",
        "A Night at the Opera - Queen",
        "Rumours - Fleetwood Mac",
        "Back to Black - Amy Winehouse",
        "Nevermind - Nirvana",
        "The Miseducation of Lauryn Hill - Lauryn Hill",
        "OK Computer - Radiohead"
    ]
}



