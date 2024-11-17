import SwiftUI
import Foundation

struct AvatarImage: View {
  let imageData: Data?
  let size: CGFloat

  var body: some View {
    Group {
      if let data = imageData, let uiImage = UIImage(data: data) {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .frame(width: size, height: size)
      } else {
        Image("pfpPlaceholder")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .mask(alignment: .top) { Circle() }
          .clipShape(Circle())
          .frame(width: size, height: size)
      }
    }
  }
}

