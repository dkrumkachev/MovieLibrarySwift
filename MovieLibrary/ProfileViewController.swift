import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Foundation

class ProfileViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var favouriteGenreTextField: UITextField!
    @IBOutlet weak var favouriteDirectorTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    var ref: DatabaseReference!
    var userKey: String = ""
    var favourites: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ref =  Database.database().reference().child("users");
        loadUserData()
    }
    
    func loadUserData() {
        let currentUserEmail = Auth.auth().currentUser?.email
        emailLabel.text = currentUserEmail
        let query = ref.queryOrdered(byChild: "email").queryEqual(toValue: currentUserEmail)
        query.observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    self.userKey = childSnapshot.key
                    if let value = childSnapshot.value as? [String: Any] {
                        DispatchQueue.main.async {
                            self.firstNameTextField.text = value["firstName"] as? String
                            self.lastNameTextField.text = value["lastName"] as? String
                            self.genderTextField.text = value["gender"] as? String
                            self.birthdayTextField.text = value["birthday"] as? String
                            self.phoneNumberTextField.text = value["phoneNumber"] as? String
                            self.countryTextField.text = value["country"] as? String
                            self.favouriteGenreTextField.text = value["favouriteGenre"] as? String
                            self.favouriteDirectorTextField.text = value["favouriteDirector"] as? String
                            self.bioTextField.text = value["bio"] as? String
                            self.favourites = value["favourites"] as? [String] ?? []
                        }
                    }
                    return
                }
            }
        })
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        let user =  [
            "email":  Auth.auth().currentUser?.email as Any,
            "firstName": firstNameTextField.text!,
            "lastName": lastNameTextField.text!,
            "gender": genderTextField.text!,
            "birthday":  birthdayTextField.text!,
            "phoneNumber": phoneNumberTextField.text!,
            "country": countryTextField.text!,
            "favouriteGenre": favouriteGenreTextField.text!,
            "favouriteDirector": favouriteDirectorTextField.text!,
            "bio": bioTextField.text!,
            "favourites": favourites
        ] as [String : Any]

        ref.child(userKey).setValue(user)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        } catch let signOutError as NSError {
            displayError(errorMessage: signOutError.localizedDescription)
        }
    }
    
    func displayError(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

}
