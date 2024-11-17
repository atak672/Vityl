import Foundation
import SwiftData
import UIKit

class ModelData {

  static func startingData(modelContext: ModelContext) {
      let user1 = User(name: "Sydney Adamu", email: "sydney@gmail.com")
      let user2 = User(name: "Carmy Berzatto", email: "michelinman@gmail.com", valueCollection: 90)
      user2.albums = Album.previewData
      
      let discussion = DiscussionPost(date: Date.now )
      
      //let discussion1 = DiscussionPost(date: Date.now, time: "1:00 PM", discussionTitle: "Post1Title", discussionBody: "Post1Body", comments: ["comment1"], creator: user1)
      let discussion2 = DiscussionPost(date: Date.now, time: "2:00 PM", discussionTitle: "Post2Title", discussionBody: "Post2Body", comments: ["comment2"])
      
      user1.discussions = [discussion]
      user2.discussions = [discussion2]
      
      user1.profile = Profile(name: user1.name, biography: "I like Taylor Swift", avatar: nil)
      user2.profile = Profile(name: user2.name, biography: "I hate Taylor Swift", avatar: nil)
      
    modelContext.insert(user1)
    modelContext.insert(user2)
  }

  @MainActor
  static var preview: ModelContainer {
      let container = try! ModelContainer(for: User.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
      ModelData.startingData(modelContext: container.mainContext)
      return container
  }
    
    // Helper function to create a date from a string
    func dateFromString(_ dateString: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: dateString)!
    }
}
