import SwiftUI
import SwiftData


struct NewCommentForm: View {
    @Binding var data: String
    
    var body: some View {
        VStack{
            TextFieldWithLabel(label: "Comment:", text: $data)
        }
    }
}

//#Preview {
//  let preview = PreviewContainer([DiscussionPost.self])
//  let data = Binding.constant(DiscussionPost.previewData[0].dataForForm)
//    return NewCommentForm(data: data)
//      .modelContainer(preview.container)
//}

