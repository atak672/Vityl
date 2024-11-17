import SwiftUI
import SwiftData

struct NewReview: View {
    @Binding var data: Album.FormData
    
    
    var body: some View {
        VStack{
            let url = URL(string: data.coverArt)
            AsyncImage(url: url){ image in image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: 180, maxHeight: 180)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.black, lineWidth: 1) // Black border around the image
            )
            
            Text("Rate \(data.title) by \(data.artist)")
                .font(.custom("Futura", size: 20))
            StarRatings($data.stars)
            TextFieldWithLabel(label: "Add a Review:", text: $data.reviewNote)
        }
    }
}




#Preview {
  let preview = PreviewContainer([Album.self])
  let data = Binding.constant(Album.previewData[1].dataForForm)
    return NewReview(data: data)
      .modelContainer(preview.container)
}
