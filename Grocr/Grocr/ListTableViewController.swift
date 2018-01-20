import Foundation
import UIKit
import Firebase

class ListTableViewController: UITableViewController {
  
  let listToUsers = "ListToUsers"
  let usersReference = Database.database().reference(withPath: "online")
  var pathList: [SavedItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.allowsMultipleSelectionDuringEditing = false
    userCountBarButtonItem = UIBarButtonItem(title: "0",style: .plain,target: self,action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    let curUser = Auth.auth().currentUser!
    Database.database().reference(withPath: "saved-items/" + curUser.uid).observe(.value, with: {
      (snapshot) in
      var tmp:[SavedItem] = []
      for curPath in snapshot.children {
        let tmpPathItem = SavedItem(snapshot: curPath as! DataSnapshot)
        tmp.append(tmpPathItem)
      }
      self.pathList = tmp
      self.tableView.reloadData()
    })

    Auth.auth().addStateDidChangeListener { (auth, user) in
      if let user = user {
        self.user = User(uid: user.uid, email: user.email!)
        let currentUserReference = self.usersReference.child(self.user.uid)
        currentUserReference.setValue(self.user.email)
        currentUserReference.onDisconnectRemoveValue()
      }
    }
    usersReference.observe(.value, with: { (snapshot) in
      if snapshot.exists() {
        self.userCountBarButtonItem?.title = snapshot.childrenCount.description
      } else {
        self.userCountBarButtonItem?.title = "0"
      }
    })
  }
  
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pathList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    
    cell.textLabel?.text = pathList[indexPath.row].majorPath + " " + pathList[indexPath.row].coursePath
    cell.detailTextLabel?.text = "CRN#  " + pathList[indexPath.row].classPath
    toggleCellCheckbox(cell, isCompleted: pathList[indexPath.row].completed)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let savedItem = pathList[indexPath.row]
      savedItem.ref?.setValue(nil)
      pathList.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    var savedItem = pathList[indexPath.row]
    let toggledCompletion = !savedItem.completed
    
    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    savedItem.completed = toggledCompletion
    savedItem.ref?.updateChildValues(["completed" : toggledCompletion])
    tableView.reloadData()
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = UIColor.gray
      cell.detailTextLabel?.textColor = UIColor.gray
    }
  }
  

  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
  
  // Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowSaved" {
      let button = sender as! UIButton
      let index = tableView.indexPath(for: button.superview?.superview as! UITableViewCell)?.row
      let savedVC = segue.destination as! SavedTableViewController
      savedVC.selectedSemester = pathList[index!].semesterPath
      savedVC.selectedMajor = pathList[index!].majorPath
      savedVC.selectedCourse = pathList[index!].coursePath
      savedVC.selectedClass = pathList[index!].classPath
    }
  }
  
}

