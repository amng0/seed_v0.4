//
//  LoginController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

// TO DO:
// Box around email/password container
// Change color of icons for email and password containers
// Make placeholder text grey
// Choose color for bottomStack text

// Forgot password field controller

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "seedlogo.png")
        return iv
    }()
    
    private let textHeader: UILabel = {
        let header = UILabel()
        header.text = "seed"
        
        return header
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "mail")
        let view = Utilities().inputContainerView(withImage: image!, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "wallet.pass")
        let view = Utilities().inputContainerView(withImage: image!, textField: passwordTextField)
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive
        = true
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities().textField(withPlaceHolder: "Username")
        return tf
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    //fix second part
    private let forgotPasswordButton: UIButton = {
        let button = Utilities().attributedButton(firstPart: "Forgot Password", secondPart: "")
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleForgotPassword(){
        print("DEBUG: Forgot password controller would be up in here")
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error logging in \(error.localizedDescription)")
                return
            }
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
        
        //MARK: - Helpers
        
        func configureUI(){
            view.backgroundColor = .white
            navigationController?.navigationBar.barStyle = .black //Makes the items in nav bar white
            
            view.addSubview(logoImageView)
            logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
            logoImageView.setDimensions(width: 69, height: 69)
            
            view.addSubview(textHeader)
            textHeader.textColor = .black
            textHeader.font = UIFont(name:"HelveticaNeue-Bold", size: 50)
            textHeader.textAlignment = .center
            
            let stack = UIStackView(arrangedSubviews: [textHeader, emailContainerView, passwordContainerView, loginButton])
            stack.axis = .vertical
            stack.spacing = 20
            stack.distribution = .fillEqually
            
            view.addSubview(stack)
            stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 25, paddingRight: 25)
            
            
            let bottomStack = UIStackView(arrangedSubviews: [dontHaveAccountButton, forgotPasswordButton])
 
            bottomStack.axis = .vertical
            //bottomStack.spacing = 2
            bottomStack.distribution = .fillEqually
            
            view.addSubview(bottomStack)
            bottomStack.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 4, paddingRight: 40)
        }
    }

