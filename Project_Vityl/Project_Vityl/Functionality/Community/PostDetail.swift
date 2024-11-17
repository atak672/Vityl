import UIKit
import SwiftData
import SwiftUI

struct PostDetail: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    var discussion: DiscussionPost
    @State private var isPresentingForm = false
    @State var newComment: String
    var comments: [String]
    

    var body: some View {
        ScrollView {
            HStack(alignment: .center) {
                AvatarImage(imageData: discussion.creator?.profile?.avatar, size: 170)
                    .frame(width: 120, height: 120)
                    .aspectRatio(contentMode: .fill) // Changed to .fill to ensure it fills the frame
                    .clipped() // This will clip the overflowing content
                    .cornerRadius(60) // If you want it to be round
                    .padding()
                
                let name = discussion.creator?.name ?? "anonymous"
                VStack {
                    Text(name)
                    Text(DiscussionPost.formatDate(date: discussion.date))
                }
            }
            Spacer()
            Text(discussion.discussionTitle)
                .font(.title)
                .bold()
            Spacer()
            Text(discussion.discussionBody)
                .font(.body)
                .padding()
            VStack(alignment: .leading) {
                Text("Comments:")
                    .font(.title2)
                Spacer()
                ForEach(discussion.comments, id: \.self) {comment in
                    Text(comment)
                        .frame(width: 350, height: 75, alignment: .center)
                        .background(Rectangle().fill(Color(.systemGray6)).shadow(radius: 3))
                        .cornerRadius(15)
                }
            }
            .frame(maxWidth: 350, alignment: .leading)
    
            if discussion.comments == [] {
                Text("No comments yet!")
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isPresentingForm = true

                }) {
                    Text("Add a Comment")
                }
            }
        }
        .sheet(isPresented: $isPresentingForm) {
            NavigationStack {
                NewCommentForm(data: $newComment)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") { isPresentingForm.toggle() }
                            
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                isPresentingForm.toggle()
                                discussion.comments.append(newComment)
                                newComment = ""

                            }
                        }
                    }
            }
        }

    }
}


struct ListView: View {
    var comments: [String]
    
    var body: some View {
        List(comments, id: \.self) { comment in
            Text(comment)
        }
    }
}


#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    authenticationService.login(email: "michelinman@gmail.com", modelContext: previewContainer.mainContext)
    if let currentUser = authenticationService.currentUser {
      let profile = Profile(name: "Carmy the Chef")
      currentUser.profile = profile
      return NavigationStack { MainDiscussionView(user: authenticationService.currentUser!) }
        .environment(authenticationService)
        .modelContainer(previewContainer)
    } else {
      return Text("Failed to create User")
    }
}
