import SwiftUI
import SwiftData

struct WelcomeView: View {
    
    //@Environment(FakeAuthenticationService.self) var authenticationService
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var isPresentingNewUserForm: Bool = false
    @State private var newUserFormData = User.FormData()
    @State private var showSuccessMessage = false
    
    
    
    
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20) {
                Text("Vityl")
                    .font(.custom("Futura", size: 50))
                    .fontWeight(.medium)
                
                
                Image("vityl_icon")
                    .resizable()
                    .scaledToFit()
                
                NavigationLink(destination: TabContainer()) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 280, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                
                
                Button("Sign Up") {
                    isPresentingNewUserForm.toggle()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 280, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .sheet(isPresented: $isPresentingNewUserForm) {
                    NavigationStack {
                        NewUserForm(data: $newUserFormData)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Cancel") { isPresentingNewUserForm.toggle()
                                        newUserFormData = User.FormData()
                                    }
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Submit") {
                                        User.create(from: newUserFormData, context: modelContext)
                                        newUserFormData = User.FormData()
                                        showSuccessMessage = true
                                        
                                        // Hide the message after 2 seconds
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            showSuccessMessage = false
                                        }
                                       
                                        isPresentingNewUserForm.toggle()
                                    }
                                    .disabled(isValidEmail(newUserFormData.email))
                                }
                            }
                            .navigationTitle("Add User")
                    }
                    .padding()
                }
                .onAppear { if users.isEmpty {
                    ModelData.startingData(modelContext: modelContext)
                }}
                if showSuccessMessage {
                    Text("Registration Successful! Please Sign In")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        // Use opacity to make the message fade in and out
                        .opacity(showSuccessMessage ? 1 : 0)
                        .animation(.easeInOut(duration: 0.5), value: showSuccessMessage)
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        if users.contains(where: { $0.email == email }) {
                return true
            }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return !emailTest.evaluate(with: email)
    }
}
    
#Preview{
    WelcomeView()
      .environment(FakeAuthenticationService())
      .modelContainer(ModelData.preview)
}


