
import SwiftUI
import Foundation
import SwiftData

struct EditAlbumForm: View {
    @Binding var purchasePrice: String
    @Binding var deleteAlbum: Bool
    let onSubmit: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Purchase Price")) {
                    TextField("Purchase Price", text: $purchasePrice)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    Toggle(isOn: $deleteAlbum) {
                        Text("Delete this album")
                    }
                }
            }
            .navigationBarTitle("Edit Album", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel", action: onCancel),
                trailing: Button("Submit", action: onSubmit)
            )
        }
    }
}

