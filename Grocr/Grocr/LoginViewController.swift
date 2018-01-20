import UIKit
import Firebase


class LoginViewController: UIViewController {

  let loginToList = "LoginToList"
  var listener: NSObjectProtocol!
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  

  override func viewDidLoad() {
    listener = Auth.auth().addStateDidChangeListener {
      (auth, user) in
      if user != nil {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      }
    }
    Auth.auth().removeStateDidChangeListener(listener)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    Auth.auth().removeStateDidChangeListener(listener!)
  }
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    Auth.auth().signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!)
    let user = Auth.auth().currentUser
    if user != nil {
      performSegue(withIdentifier: loginToList, sender: nil)
    } else {
      let alert = UIAlertController(title: "Warning", message: "Wrong username or password", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true, completion: nil)
    }
  }
  
  // Sign up account
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register New Account", message: "Register", preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",style: .default){
      (action) in
      let emailField = alert.textFields![0]
      let passwordField = alert.textFields![1]
      Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: {
        (user, error) in
        if error != nil {
          var msg = ""
          if let errorCode = AuthErrorCode(rawValue: error!._code) {
            switch errorCode {
            case .emailAlreadyInUse:
              msg = "Email already in use"
            case .weakPassword:
              msg = "Please provide strong password"
            default:
              msg = "There is an error"
            }
          }
          let alert = UIAlertController(title: "Failed to register", message: msg, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default)
          alert.addAction(okAction)
          self.present(alert, animated: true, completion: nil)
        } else if user != nil {
          user?.sendEmailVerification(completion: {
            (error) in
            print(error?.localizedDescription ?? "No error")
          })
          Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!)
//          self.performSegue(withIdentifier: self.loginToList, sender: nil)
        }
      })
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    
    alert.addTextField {
      (textEmail) in
      textEmail.placeholder = "Enter your email"
    }
    alert.addTextField {
      (textPassword) in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
  
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
}
