import Foundation

struct User {
  
  let uid: String
  let email: String
//  var list: [String]
  
  init(authData: User) {
    uid = authData.uid
    email = authData.email
//    list = authData.list
  }
//  list:[String]
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
//    self.list = list
  }
  
}
