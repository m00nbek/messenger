//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Oybek on 7/4/21.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutSubviews()
    }
    // MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.layer.masksToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .continue
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "Email Address..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        tf.leftViewMode = .always
        tf.backgroundColor = .white
        return tf
    }()
    private let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .continue
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "First Name..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        tf.leftViewMode = .always
        tf.backgroundColor = .white
        return tf
    }()
    private let lastNameField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .continue
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "Last Name..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        tf.leftViewMode = .always
        tf.backgroundColor = .white
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.placeholder = "Password..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        tf.leftViewMode = .always
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        return tf
    }()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    // MARK: - Selectors
    @objc private func registerButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
                  alertUserLoginError()
                  return
              }
        spinner.show(in: view)
        // Check if user exists
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            if exists {
                // user already exists
                self?.alertUserLoginError(message: "User already exists!")
                return
            }
            // Register User
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard error == nil else {
                    print("Error creating account")
                    return
                }
                let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success {
                        // upload image
                        guard let image = self?.imageView.image,
                              let data = image.pngData() else {
                                  return
                              }
                        let fileName = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("StorageManager error: \(error)")
                            }
                        }
                    }
                })
                DispatchQueue.main.async {
                    self?.spinner.dismiss()
                }
                self?.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    @objc private func didTapChangePic() {
        presentPhotoActionSheet()
    }
    private func alertUserLoginError(message: String = "Please enger all the information to create a new account!") {
        let alert = UIAlertController(title: "Whoops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    // MARK: - API
    // MARK: - Functions
    private func configureUI() {
        view.backgroundColor = .white
        configureNav()
        
        // delegates
        firstNameTextField.delegate = self
        lastNameField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // addSubviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangePic))
        imageView.addGestureRecognizer(gesture)
        
    }
    private func layoutSubviews() {
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size) / 2, y: 20, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2
        firstNameTextField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width-60, height: 52)
        lastNameField.frame = CGRect(x: 30, y: firstNameTextField.bottom + 10, width: scrollView.width-60, height: 52)
        emailTextField.frame = CGRect(x: 30, y: lastNameField.bottom + 10, width: scrollView.width-60, height: 52)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width-60, height: 52)
        registerButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 10, width: scrollView.width-60, height: 52)
    }
    private func configureNav() {
        title = "Register"
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            registerButtonTapped()
        }
        return true
    }
}
// MARK: - UIImagePickerControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentImagePicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    private func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let selectedImage = info[.editedImage] as? UIImage
        self.imageView.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
