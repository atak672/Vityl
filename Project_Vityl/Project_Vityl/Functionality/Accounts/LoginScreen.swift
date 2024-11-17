import SwiftUI
import AuthenticationServices

struct LoginScreen: View {
  @Environment(FakeAuthenticationService.self) var authenticationService
  @Environment(\.modelContext) private var modelContext
  @State var email: String = ""
  @State var validationStatus: Bool = false
  @State var loginError: String = ""

  var body: some View {
      ScrollView {
       
          
          Text("Email")
             .font(.title3)
             .fontWeight(.semibold)
             .frame(maxWidth: 330, alignment: .leading)
         
         TextField("Enter your email", text: $email)
             .keyboardType(.emailAddress)
             .autocapitalization(.none)
             .disableAutocorrection(true)
             .padding()
             .overlay(RoundedRectangle(cornerRadius: 10.0)
             .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
             .padding(.bottom)
             
         
         if !email.contains("@") && !email.isEmpty {
             Text("Make sure to include an @ in your email!")
                 .font(.caption)
                 .foregroundColor(.red)
         }
          
        

        Button("Login") { authenticationService.login(email: email, modelContext: modelContext) }
          .font(.headline)
          .foregroundColor(.white)
          .frame(width: 140, height: 40)
          .background(Color.blue)
          .cornerRadius(10)
          
          
        if let errorMessage = authenticationService.errorMessage {
          Text(errorMessage)
            .font(.headline)
            .foregroundStyle(.red)
        }
          
      }
      .navigationTitle("Login")
      .navigationBarBackButtonHidden(true)
      .padding()
  }

  
  func handleFailedAppleAuthorization(_ error: Error) {
    print("Authorization Failed \(error)")
  }
}
