import Foundation
import UIKit
import Firebase

class SavedTableViewController: UITableViewController {
  var selectedSemester: String = ""
  var selectedMajor: String = ""
  var selectedCourse: String = ""
  var selectedClass: String = ""
  var curClassItem: ClassItem?
  
    
  @IBOutlet weak var courseLabel: UILabel!
  @IBOutlet weak var crnLabel: UILabel!
  @IBOutlet weak var remLabel: UILabel!
  @IBOutlet weak var wlRemLabel: UILabel!
  @IBOutlet weak var instructorLabel: UILabel!
  @IBOutlet weak var daysATimeLabel: UILabel!
  @IBOutlet weak var campusLabel: UILabel!
    
  override func viewDidLoad() {
    let curClassRef = Path.coursePath
      + selectedSemester + "/" + selectedMajor + "/" + selectedCourse + "/" + selectedClass
    print("Ref Path is: \(curClassRef)")
    Database.database().reference(withPath: curClassRef).observe(.value, with: {
      (snapshot) in
      print("Saved Snapshot is: \(snapshot)")
      self.curClassItem = ClassItem(snapshot: snapshot)
      self.initializeLabels()
      self.tableView.reloadData()
    })
  }
  
  func initializeLabels() {
    courseLabel.text = selectedCourse
    crnLabel.text = "CRN - " + selectedClass
    remLabel.text = "Remaining Space: " + String(curClassItem!.rem)
    wlRemLabel.text = "Waiting List Remaining Space: " + String(curClassItem!.wlRem)
    instructorLabel.text = "Instructor: " + curClassItem!.instructor
    daysATimeLabel.text = "Days: " + curClassItem!.days + ", Time: " + curClassItem!.time
    campusLabel.text = "Campus: " + curClassItem!.campus
  }
}
