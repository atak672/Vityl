import Foundation
import SwiftUI
import SwiftData

@Model
class DiscussionPost: Identifiable {
    var date: Date
    var time: String?
    var discussionTitle: String
    var discussionBody: String
    var comments: [String]
    var creator: User?

    
//    @Relationship
    
    
//    @Relationship
//    var comments: [Comment]
    
    init(date: Date = Date.now, time: String = "", discussionTitle: String = "", discussionBody: String = "", comments: [String] = []) {
        self.date = date
        self.time = time
        self.discussionTitle = discussionTitle
        self.discussionBody = discussionBody
        self.comments = comments
    }
    

    static func formatDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        return dateFormatter.string(from: date)
    }
    
    
    struct FormData {
        var date: Date = Date.now
        var time: String = ""/*Text(Date.now.formatted(date: .omitted, time: .standard))*/
        var discussionTitle: String = ""
        var discussionBody: String = ""
        var comments: [String] = []
    }
    
    var dataForForm: FormData {
        FormData(
            date: date,
            time: time ?? "",
            discussionTitle: discussionTitle,
            discussionBody: discussionBody,
            comments: comments 
        )
    }
    
    static func create(from formData: FormData, context: ModelContext) ->DiscussionPost {
        let post = DiscussionPost(date: formData.date, time: formData.time, discussionTitle: formData.discussionTitle, discussionBody: formData.discussionBody, comments: formData.comments)
        context.insert(post)
        return post
    }

    
    
    
    
    struct FormDataComment {
        var comments: [String]
    }
    
    var dataForFormComment: FormDataComment {
        FormDataComment(
            comments: comments
        )
    }
//    
//    
//    
//    static func addComment(from formDataComment: FormDataComment) -> Comment{
//        self.comments.append(dataForFormComment.comments)
//    }
    
    
    
    

    
    func getName() -> String {
        let name = self.creator?.name ?? "anonymous"
        return name
    }

    

}

//
//@Model
//class Comment: Identifiable {
//    var date: Date
//    var time: String?
//    var comment: String
//    var name: String
//    
//    
//    @Relationship
//    var commenter: User?
//    
//    
//    init(date: Date, time: String? = nil, comment: String, name: String, commenter: User? = nil) {
//        self.date = date
//        self.time = time
//        self.comment = comment
//        self.name = name
//    }
////    
////    
////    static func formatDate(date: Date) -> String{
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "YY/MM/dd"
////        return dateFormatter.string(from: date)
////    }
////    
////    
////    
////    struct FormData {
////        var date: Date = Date.now
////        var time: String = ""/*Text(Date.now.formatted(date: .omitted, time: .standard))*/
////        var comment: String = ""
////        
////    }
////
////    
////    var dataForForm: FormData {
////        FormData(
////            date: date,
////            time: time ?? "",
////            comment: comment
////        )
////    }
////    
////    static func create(from formData: FormData, context: ModelContext) -> Comment{
////        let comment = Comment(date: formData.date, time: formData.time, comment: formData.comment, name: "")
////        return comment
////    }
////    
////    
//    func getName() -> String {
//        let name = self.commenter?.name ?? "anonymous"
//        return name
//    }
//    
//    
//}


extension DiscussionPost {
    static let previewData: [DiscussionPost] =  [
        DiscussionPost(date: Date.now, time: "17:00:00", discussionTitle: "What is your favorite album?", discussionBody: "Mine is folklore by Taylor Swift", 
                       comments:["Mine is 1989!", "I also love folklore!"]),
        DiscussionPost(date: Date.now, time: "17:00:00", discussionTitle: "What is your favorite album?", discussionBody: "Mine is folklore by Taylor Swift",
                       comments:["Mine is 1989!", "I also love folklore!"])
    ]
    
    
}
