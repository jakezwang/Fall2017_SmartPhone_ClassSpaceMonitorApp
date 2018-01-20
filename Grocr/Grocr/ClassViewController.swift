import Foundation
import UIKit
import Firebase

class ClassViewController: UITableViewController {
  var selectedSemester: String = ""
  var selectedMajor: String = ""
  var selectedCourse: String = ""
  var selectedClass: String = ""
  var curClassItem: ClassItem?
  
  @IBOutlet weak var courseLabel: UILabel!
  @IBOutlet weak var classLabel: UILabel!
  @IBOutlet weak var remLabel: UILabel!
  @IBOutlet weak var wlremLabel: UILabel!
  @IBOutlet weak var profLabel: UILabel!
  @IBOutlet weak var weekAndTimeLabel: UILabel!
  @IBOutlet weak var campus: UILabel!
  @IBAction func addButton(_ sender: Any) {
    if let user = Auth.auth().currentUser {
      let path = Path.savedPath + user.uid
      let autoRef = Database.database().reference(withPath: path).childByAutoId()
      autoRef.setValue(["semesterPath" : selectedSemester,
                        "majorPath" : selectedMajor,
                        "coursePath" : selectedCourse,
                        "classPath" : selectedClass,
                        "completed" : false
        ])
    } else {
      let alert = UIAlertController(title: "Failed to Add Class", message: "User session expired or user does not exist", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
    self.navigationController?.popToRootViewController(animated: true)
  }
    
    
  override func viewDidLoad() {
    let curClassRef = Path.coursePath
      + selectedSemester + "/" + selectedMajor + "/" + selectedCourse + "/" + selectedClass
    Database.database().reference(withPath: curClassRef).observe(.value, with: {
      snapshot in
      self.curClassItem = ClassItem(snapshot: snapshot)
      self.initializeLabels()
      self.tableView.reloadData()
    })
  }
  
  func initializeLabels() {
    courseLabel.text = selectedCourse
    classLabel.text = "CRN - " + selectedClass
    remLabel.text = "Remaining Space: " + String(curClassItem!.rem)
    wlremLabel.text = "Waiting List Remaining Space: " + String(curClassItem!.wlRem)
    profLabel.text = "Instructor: " + curClassItem!.instructor
    weekAndTimeLabel.text = "Days: " + curClassItem!.days + ", Time: " + curClassItem!.time
    campus.text = "Campus: " + curClassItem!.campus
  }
    
}
