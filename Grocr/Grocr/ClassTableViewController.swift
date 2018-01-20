import Foundation
import UIKit
import Firebase

class ClassTableViewController: UITableViewController {
  var selectedSemester: String = ""
  var selectedMajor: String = ""
  var selectedCourse: String = ""
  var classList: [String] = []
  let classCell = "ClassCell"
  
  override func viewDidLoad() {
    let classRef = Path.coursePath + selectedSemester + "/" + selectedMajor + "/" + selectedCourse
    Database.database().reference(withPath: classRef).observe(.value, with: {
      snapshot in
      var tmp:[String] = []
      for curClass in snapshot.value as? [String : AnyObject] ?? [:] {
        tmp.append(curClass.key)
      }
      self.classList = tmp.sorted()
      self.tableView.reloadData()
    })
  }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return classList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: classCell, for: indexPath)
    let className = classList[indexPath.row]
    cell.textLabel?.text = className
    return cell
  }
  
  // Segue prepare
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)!
    let classDisplayVC = segue.destination as! ClassViewController
    classDisplayVC.selectedSemester = self.selectedSemester
    classDisplayVC.selectedMajor = self.selectedMajor
    classDisplayVC.selectedCourse = self.selectedCourse
    classDisplayVC.selectedClass = classList[selectedIndex.row]
  }
  
}
