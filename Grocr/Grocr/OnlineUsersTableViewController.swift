import UIKit
import Firebase
import MessageUI

class OnlineUsersTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {
  
  let userCell = "UserCell"
  let usersReference = Database.database().reference(withPath: "online")
  var currentUsers: [String] = []
  @IBAction func sendButton(_ sender: Any) {
//    let viewCell = (sender as! UIButton).superview?.superview
//    let selectedIndex = tableView.indexPath(for: viewCell as! UITableViewCell)!
//    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: selectedIndex)

    let mailComposeController = configMailController() // sendTo: cell.textLabel!.text!
    if MFMailComposeViewController.canSendMail() {
      self.present(mailComposeController, animated: true, completion: nil)
    } else {
      showMailError()
    }
  }
  @IBAction func signoutButtonPressed(_ sender: AnyObject) {
    Database.database().reference(withPath: "online").child(Auth.auth().currentUser!.uid).removeValue()
    try! Auth.auth().signOut()
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    usersReference.observe(.value, with: {
      (snapshot) in
      var tmp: [String] = []
      for child in snapshot.children {
        let snap = child as! DataSnapshot
        tmp.append(snap.value as! String)
      }
      print(tmp)
      self.currentUsers = tmp
      self.tableView.reloadData()
    })
  }
  
  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
    let onlineUserEmail = currentUsers[indexPath.row]
    cell.textLabel?.text = onlineUserEmail
    return cell
  }

  // Mail service
  func configMailController () -> MFMailComposeViewController { // sendTo: String
    let composeVC = MFMailComposeViewController()
    composeVC.mailComposeDelegate = self
    composeVC.setToRecipients(["wangzhiyi05@gmail.com"])
    composeVC.setSubject("Hello!")
    composeVC.setMessageBody("Hello from " + Auth.auth().currentUser!.email!, isHTML: false)
    return composeVC
  }
  
  func showMailError() {
    let alert = UIAlertController(title: "Could not send mail", message: "Your device could not send this email", preferredStyle: .alert)
    let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(dismiss)
    self.present(alert, animated: true, completion: nil)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }

  
}
