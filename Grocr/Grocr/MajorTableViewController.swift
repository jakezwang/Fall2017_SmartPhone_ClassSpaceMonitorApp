import Foundation
import UIKit
import Firebase

class MajorTableViewController: UITableViewController {
  var selectedSemester: String = ""
  var majorList: [String] = []
  let majorCell = "MajorCell"
  
  
  override func viewDidLoad() {
    Database.database().reference(withPath: Path.coursePath + selectedSemester).observe(.value, with: {
      snapshot in
      var tmp:[String] = []
      for major in snapshot.value as? [String : AnyObject] ?? [:] {
        tmp.append(major.key)
      }
      self.majorList = tmp.sorted()
      self.tableView.reloadData()
    })
  }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return majorList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: majorCell, for: indexPath)
//    let majorName =
    cell.textLabel?.text = majorList[indexPath.row]
    return cell
  }
  
  // Segue prepare
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)!
    let courseVC = segue.destination as! CourseTableViewController
    courseVC.selectedSemester = self.selectedSemester
    courseVC.selectedMajor = majorList[selectedIndex.row];
  }
  
}
