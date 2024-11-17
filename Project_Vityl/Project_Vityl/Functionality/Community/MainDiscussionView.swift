import SwiftUI
import SwiftData

struct MainDiscussionView: View {
    @Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext)  var modelContext
    @Query var allUsers: [User]
    var discussions: [DiscussionPost] = DiscussionPost.previewData
    @State private var isPresentingForm = false
    @State private var editDiscussionForm: DiscussionPost.FormData = DiscussionPost.FormData()
    let user: User
    @State private var sortOption: PostSortOption = .date
    
    
    var body: some View {
                Text("Discussions")
                    .font(.custom("Futura", size: 40))
                Button(action: {
                    isPresentingForm.toggle()
                    editDiscussionForm.date = Date.now
                }) {
                    Text("Start a Discussion")
                }
                Picker(selection: $sortOption, label: Text("Sorting")) {
                    Text("All Discussions").tag(PostSortOption.date)
                    Text("My Discussions").tag(PostSortOption.byUser)
                    

                }
                if sortedPosts().count == 0 {
                    Text("No Discussions Yet!")
                }
                NavigationStack {
                    
                    List(sortedPosts()) { post in
                        NavigationLink(destination: PostDetail(discussion: post, newComment: "", comments: post.comments)) {
                            DiscussionPostRowView(post: post)
                        }
                        }

                    }
       
                    
                
            .sheet(isPresented: $isPresentingForm) {
                NavigationStack {
                    NewDiscussionForm(data: $editDiscussionForm)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel") { isPresentingForm.toggle()
                                    editDiscussionForm = DiscussionPost.FormData()
                                }
                                
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Save") {
                                    let post = DiscussionPost.create(from: editDiscussionForm, context: modelContext)
                                    post.creator = user
                                    user.discussions.append(post)
                                    isPresentingForm.toggle()
                                    editDiscussionForm = DiscussionPost.FormData()
                                    
                                }
                            }
                        }
                }
            }
        }
    
    
    
    
    func sortedPosts() -> [DiscussionPost] {
        var allDiscussions = [DiscussionPost]()
        for user in allUsers {
            allDiscussions.append(contentsOf: user.discussions)
        }
        switch sortOption {
        case .date:
            return allDiscussions.sorted { $0.date > $1.date }
        case .byUser:
            return user.discussions.sorted { $0.date > $1.date}
        }
        
    }
    
    enum PostSortOption {
        case date, byUser
    }
}
    

#Preview {
    let authenticationService = FakeAuthenticationService()
    let previewContainer = ModelData.preview
    if let currentUser = authenticationService.currentUser {
      return NavigationStack { MainDiscussionView(user: authenticationService.currentUser!) }
        .environment(authenticationService)
        .modelContainer(previewContainer)
    } else {
      return Text("Failed to create User")
    }
}
