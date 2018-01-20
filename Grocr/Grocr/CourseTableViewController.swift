import Foundation
import UIKit
import Firebase

class CourseTableViewController: UITableViewController {
  var selectedSemester: String = ""
  var selectedMajor: String = ""
  var courseList: [String] = []
  let courseCell = "CourseCell"
  
  
  override func viewDidLoad() {
    let courseRef = Path.coursePath + selectedSemester + "/" + selectedMajor
    Database.database().reference(withPath: courseRef).observe(.value, with: {
      snapshot in
      var tmp:[String] = []
      for course in snapshot.value as? [String : AnyObject] ?? [:] {
        tmp.append(course.key)
      }
      self.courseList = tmp.sorted()
      self.tableView.reloadData()
    })
  }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return courseList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: courseCell, for: indexPath)
    let courseName = courseList[indexPath.row]
    cell.textLabel?.text = courseName
    return cell
  }
  
  // Segue prepare
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)!
    let classVC = segue.destination as! ClassTableViewController
    classVC.selectedSemester = self.selectedSemester
    classVC.selectedMajor = self.selectedMajor
    classVC.selectedCourse = courseList[selectedIndex.row]
  }
}
