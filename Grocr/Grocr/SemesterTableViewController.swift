import Foundation
import UIKit
import Firebase

class SemesterTableViewController: UITableViewController {
  var semesterList: [String] = []
  let semesterCell = "SemesterCell"
  let semesterRef = Database.database().reference(withPath: Path.coursePath)
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    semesterRef.observe(.value, with: {
      snapshot in
      var tmp:[String] = []
      for semester in snapshot.value as? [String : AnyObject] ?? [:] {
        tmp.append(semester.key)
        print(semester.key as String)
      }
      self.semesterList = tmp.sorted()
      self.tableView.reloadData()
    })
  }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return semesterList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: semesterCell, for: indexPath)
    let smesterName = semesterList[indexPath.row]
    cell.textLabel?.text = smesterName
    return cell
  }
  
  // Segue prepare
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if (segue != nil && segue.identifier == "showMajor") {
      var selectedIndex = tableView.indexPath(for: sender as! UITableViewCell)!
      let majorVC = segue.destination as! MajorTableViewController
      majorVC.selectedSemester = semesterList[selectedIndex.row];
//    }
  }

}
