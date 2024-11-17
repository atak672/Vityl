import SwiftUI
import SwiftData

struct DiscussionPostRowView: View {
    let post: DiscussionPost
    
    var body: some View {
        VStack {
            Text(post.discussionTitle)
                .font(.subheadline)
                .frame(alignment: .leading)
//                .padding()
            HStack {
                VStack {
                    Text(post.getName())
                        .font(.caption)
                    Text(DiscussionPost.formatDate(date: post.date))
                        .font(.caption)
                }
                Spacer()
                Text(String(post.comments.count) + " comments")
                    .frame(alignment: .bottomTrailing)
                    .font(.caption)
            }
        }
    }
}


//struct RecipeRow: View {
//    let recipe: Recipe
//    var body: some View {
//        HStack(alignment: .center) {
//            AsyncImage(url: recipe.thumbnailUrl) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .cornerRadius(6)
//            } placeholder: {
//                if recipe.thumbnailUrl != nil {
//                    ProgressView()
//                } else {
//                    Image(systemName: "")
//                }
//            }
//            .frame(maxWidth: 100, maxHeight: 100)
//            VStack {
//                Text(recipe.mealCourse.rawValue.uppercased())
//                    .font(.headline)
//                    .frame(maxWidth: 350, alignment: .topLeading)
//                Text(recipe.name)
//                    .font(.title3)
//                    .bold()
//                    .frame(maxWidth: 350, alignment: .topLeading)
//                Spacer()
//                
//            }
//            Spacer()
//            VStack {
//                Spacer()
//                Image(systemName: recipe.prev_prepared ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(recipe.prev_prepared ? Color.green : Color.black)
//                Spacer()
//            }
//        }
//    }
//}

#Preview {
    DiscussionPostRowView(post: DiscussionPost.previewData[0])
}
