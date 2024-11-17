import SwiftUI
import SwiftData


struct NewDiscussionForm: View {
    @Binding var data: DiscussionPost.FormData
    
    var body: some View {
        VStack{
            TextFieldWithLabel(label: "Title          ", text: $data.discussionTitle)
            TextFieldWithLabel(label: "Discussion", text: $data.discussionBody)
        }
    }
}

#Preview {
  let preview = PreviewContainer([DiscussionPost.self])
  let data = Binding.constant(DiscussionPost.previewData[0].dataForForm)
    return NewDiscussionForm(data: data)
      .modelContainer(preview.container)
}

