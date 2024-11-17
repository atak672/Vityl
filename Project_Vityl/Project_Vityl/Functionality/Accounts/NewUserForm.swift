import SwiftUI
import SwiftData

struct NewUserForm: View {
    @Binding var data: User.FormData
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Name")
                       .font(.title3)
                       .fontWeight(.semibold)
                       .frame(maxWidth: 330, alignment: .leading)
                   
                    TextField("Enter your name", text: $data.name)
                       .keyboardType(.emailAddress)
                       .autocapitalization(.none)
                       .disableAutocorrection(true)
                       .padding()
                       .overlay(RoundedRectangle(cornerRadius: 10.0)
                       .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                       .padding(.bottom)
                    
                    Text("Email")
                       .font(.title3)
                       .fontWeight(.semibold)
                       .frame(maxWidth: 330, alignment: .leading)
                   
                    TextField("Enter your email", text: $data.email)
                       .keyboardType(.emailAddress)
                       .autocapitalization(.none)
                       .disableAutocorrection(true)
                       .padding()
                       .overlay(RoundedRectangle(cornerRadius: 10.0)
                       .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                       .padding(.bottom)
                       
                   
                    

                    
                    if !data.email.contains("@") && !data.email.isEmpty {
                        Text("Make sure to include an @ in your email!")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
                Text("IF SUBMIT GREYED OUT, EMAIL INVALID OR ALREADY IN USE")
                    .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.red) // Choose a color that stands out but is not too strong.
                        .padding() // Add padding to all sides.
                        .frame(maxWidth: .infinity, alignment: .center) // Center the text in its frame.
                        .multilineTextAlignment(.center)
                
            
            }
            .navigationBarTitle("Sign Up", displayMode: .inline)
            
        
            
        }
    }
    
   
}


struct RegisterUser_Previews: PreviewProvider {
    // Create a static instance of `FormData` for the preview
    static var sampleFormData = User.FormData()
    
    static var previews: some View {
        // Use a constant binding for the preview
        let bindingSampleFormData = Binding.constant(sampleFormData)

        NewUserForm(data: bindingSampleFormData)
            .environment(\.modelContext, ModelData.preview.mainContext) // Provide a mock `ModelContext` if needed
    }
}


