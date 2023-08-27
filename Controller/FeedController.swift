//
//  FeedController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import UIKit

private let reuseIdentifier = "GoalPostCell"
private var commentTextField: UITextField?

class FeedController: UICollectionViewController, UITextFieldDelegate {
    
    // MARK: - Properties

    var user: User? {
        didSet{
            configureLeftBarButton()
        }
    }
    
    private var goalPosts = [GoalPost]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureRightBarButton()
        fetchGoalPosts()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    

    
    // MARK: - Helpers
    
    
    
    
    
    
    
    // MARK: - Selectors
    
    @objc func goalPostButtonTapped() {
        print("DEBUG: GOAL POST BUTTON TAPPED")
        //guard let user = user else { return }
        let controller = UploadGoalPostController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    

    
    @objc func searchButtonTapped() {
        print("DEBUG: SEARCH TAPPED")
    }
    
    @objc func profileImageTapped() {
        print("DEBUG: PROFILE IMAGE TAPPED")
    }
    
    // MARK: - API
    
    func fetchGoalPosts(){
        collectionView.refreshControl?.beginRefreshing()
        
        GoalPostService.shared.fetchGoalPosts{ goalPosts in
                //self.goalPosts = goalPosts.sorted(by: {$0.timestamp })
        self.goalPosts = goalPosts
            }
        self.collectionView.refreshControl?.endRefreshing()
        }
    
    
    func configureUI() {
        
        collectionView.register(GoalPostCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(image: UIImage(named: "seedlogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 30, height: 30)
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
    }
    
    @objc func handleRefresh() {
        fetchGoalPosts()
    }
    
    func configureLeftBarButton() {
        
    }
    
    func configureRightBarButton() {
        let goalPostButton = UIButton(type: .system)
        let image = UIImage(systemName: "plus.circle.fill")
        goalPostButton.setImage(image, for: .normal)
        goalPostButton.addTarget(self, action: #selector(goalPostButtonTapped), for: .touchUpInside)
        
        // Create a bar button item with the custom view (rightButton)
        let rightBarButtonItem = UIBarButtonItem(customView: goalPostButton)
        
        // Add the custom bar button item to the right bar button items of the navigation item
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        // Create the "Search" button
        let searchButton = UIButton(type: .system)
        let searchImage = UIImage(systemName: "magnifyingglass")
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchButton.setDimensions(width: 32, height: 32)
        searchButton.layer.cornerRadius = 16
        
        // Create bar button items with the custom views (plusButton and searchButton)
        let plusBarButtonItem = UIBarButtonItem(customView: goalPostButton)
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        
        // Add the custom bar button items to the right bar button items array
        navigationItem.rightBarButtonItems = [plusBarButtonItem, searchBarButtonItem]
    }
}


    
    // MARK: - UICollectionViewDelegate/DataSource

    extension FeedController {
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return goalPosts.count
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GoalPostCell
            
            cell.delegate = self
            cell.goalPost = goalPosts[indexPath.row]
            
        return cell
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let controller = GoalPostController(goalPost: goalPosts[indexPath.row])
           // navigationController?.pushViewController(controller, animated: true)

        }
    }
    
    
    // MARK: - UICollectinViewDelegateFlowLayout

    extension FeedController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let viewModel = GoalPostViewModel(goalPost: goalPosts[indexPath.row])
//            let height = viewModel.size(forWidth: view.frame.width).height
            
            return CGSize(width: view.frame.width, height: 120)
        }
    }

extension FeedController: GoalPostCellDelegate{
    func handleProfileImageTapped(_ cell: GoalPostCell) {
        
    }
    
    func handleCommentTapped(_ cell: GoalPostCell) {
        
        
    }
    
    func handleFetchUser(withUsername user: String) {
        
    }
    
    func handleLikeTapped(_ cell: GoalPostCell) {
        //guard let goalPost = cell.goalPost else {return}
        print("like tapped")
        
        //GoalPostService.shared.likeGoalPost(goalPost: goalPost) {(err, ref) in
            cell.goalPost?.didLike.toggle()
            //let likes = goalPost.didLike ? goalPost.likes - 1: goalPost.likes + 1
            //cell.goalPost?.likes = likes
            //
            //        guard !goalPost.didLike else {return}
            //        NotificationService.shared.uploadNotification(toUser: goalPost.user,
            //                                                      type: .like,
            //                                                      goalPostID: goalPost.tweetID)
            //
            
        //}
    }
}




