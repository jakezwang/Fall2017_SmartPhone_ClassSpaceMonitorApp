import Foundation
import Firebase

struct SavedItem {
  let key: String
  let semesterPath: String
  let majorPath: String
  let coursePath: String
  let classPath: String
  var completed: Bool
  let ref: DatabaseReference?
  
  init(key: String, semesterPath: String, majorPath: String, coursePath: String, classPath: String, completed: Bool) {
    self.key = key
    self.semesterPath = semesterPath
    self.majorPath = majorPath
    self.coursePath = coursePath
    self.classPath = classPath
    self.completed = completed
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    semesterPath = snapshotValue["semesterPath"] as! String
    majorPath = snapshotValue["majorPath"] as! String
    coursePath = snapshotValue["coursePath"] as! String
    classPath = snapshotValue["classPath"] as! String
    completed = snapshotValue["completed"] as! Bool
    ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return [
      "semesterPath" : semesterPath,
      "majorPath" : majorPath,
      "coursePath" : coursePath,
      "classPath" : classPath,
      "completed" : completed
    ]
  }
  
}



