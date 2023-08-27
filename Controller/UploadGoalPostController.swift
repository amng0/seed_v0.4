//
//  UploadGoalPostController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import UIKit

class UploadGoalPostController: UIViewController {
    
    //MARK: - Properties
    
//    private let user: User
//    private let config: UploadGoalPostConfiguration
//    private lazy var viewModel = UploadGoalPostViewModel(config: config)
//
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
       button.addTarget(self, action: #selector(handleUploadGoalPost), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48/2
        iv.backgroundColor = .black
        return iv
    }()
    
    
    private let captionTextView = InputTextView()
    
    //MARK: - Lifecycle
    
//    init(user: User, config: UploadGoalPostConfiguration){
//        self.user = user
//        self.config = config
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    //MARK: - Selectors
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }

    @objc func handleUploadGoalPost(){
        guard let caption = captionTextView.text else {return}
        GoalPostService.shared.uploadGoalPost(caption: caption) { (error, ref) in
            if let error = error {
                print("Failed to upload tweet with error \(error.localizedDescription)")
                return
            }


           
            self.dismiss(animated: true, completion: nil)
        }
    }

    

    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white

        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        
        view.addSubview(imageCaptionStack)
        imageCaptionStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        
        
    }
    
    func configureNavigatonBar(){
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)

    }

    }
    


