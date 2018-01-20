import Foundation
import Firebase

struct ClassItem {
  let crn: String
  let section: String
  let campus: String
  let days: String
  let time: String
  let rem: Int
  let wlRem: Int
  let instructor: String
  let location: String
  
  
  let ref: DatabaseReference?
  
  init(key: String = "", section: String, campus: String, days: String, time: String, rem: Int, wlRem: Int, instructor: String, location: String) {
    self.crn = key
    self.section = section
    self.campus = campus
    self.days = days
    self.time = time
    self.rem = rem
    self.wlRem = wlRem
    self.instructor = instructor
    self.location = location
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    crn = snapshot.key
    
    let snapshotValue = snapshot.value as! [String: AnyObject]
    section = snapshotValue["section"] as! String
    campus = snapshotValue["campus"] as! String
    days = snapshotValue["days"] as! String
    time = snapshotValue["time"] as! String
    rem = snapshotValue["rem"] as! Int
    wlRem = snapshotValue["wlRen"] as! Int
    instructor = snapshotValue["instructor"] as! String
    location = snapshotValue["location"] as! String
    
    ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return [
      "section": section,
      "campus": campus,
      "days": days,
      "time": time,
      "rem": rem,
      "wlRem": wlRem,
      "instructor": instructor,
      "location": location
    ]
  }
  
}


