import Foundation
import SwiftData


@Observable
class FakeAuthenticationService {
  var currentUser: User?
  var errorMessage: String?
  let currentUserKey: String = "currentUserEmail"

  func login(email: String, modelContext: ModelContext) {
    let ws = CharacterSet.whitespacesAndNewlines
    if let user = try? fetchUser(email.trimmingCharacters(in: ws).lowercased(), modelContext: modelContext) {
      errorMessage = nil
      loginUser(user)
    } else {
      errorMessage = "Login Failed"
      logout()
    }
  }

  func loginUser(_ user: User) {
    currentUser = user
    UserDefaults.standard.set(user.email, forKey: currentUserKey)
    UserDefaults.standard.synchronize()
  }

  func logout() {
    currentUser = nil
    UserDefaults.standard.set(nil, forKey: currentUserKey)
    UserDefaults.standard.synchronize()
  }

  func fetchUser(_ email: String, modelContext: ModelContext) throws -> User? {
    let userPredicate = #Predicate<User> { $0.email == email }
    let userFetch = FetchDescriptor(predicate: userPredicate)
    return try modelContext.fetch(userFetch).first
  }

  func maybeLoginSavedUser(modelContext: ModelContext) {
    let email = UserDefaults.standard.string(forKey: currentUserKey)
    if let email,
       let user = try? fetchUser(email, modelContext: modelContext) {
      loginUser(user)
    }
  }
}

