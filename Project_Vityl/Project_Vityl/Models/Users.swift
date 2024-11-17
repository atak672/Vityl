import Foundation
import SwiftData

@Model class User {
    var name: String
    var email: String
    var albums: [Album] = []
    var wishlistAlbums: [Album] = []
    var valueCollection: Double = 0

  @Relationship(deleteRule: .cascade, inverse: \Profile.user)
  var profile: Profile?

    
    @Relationship(inverse: \DiscussionPost.creator)
    var discussions: [DiscussionPost] = []

    init(name: String, email: String, profile: Profile? = nil, discussions: [DiscussionPost] = [], valueCollection: Double = 0) {
        self.name = name
        self.email = email
        self.profile = profile
        self.discussions = discussions
        self.valueCollection = valueCollection
  }
}

extension User {
    struct FormData {
        var name: String = ""
        var email: String = ""
    }
    
    var dataForForm: FormData {
        FormData(
            name: name,
            email: email
        )
    }
    
    static func create(from formData: FormData, context: ModelContext) {
        let user = User(name: formData.name, email: formData.email)
        User.update(user, from: formData)
        context.insert(user)
    }
    
    static func update(_ user: User, from formData: FormData) {
        user.name = formData.name
        user.email = formData.email
    }
}

