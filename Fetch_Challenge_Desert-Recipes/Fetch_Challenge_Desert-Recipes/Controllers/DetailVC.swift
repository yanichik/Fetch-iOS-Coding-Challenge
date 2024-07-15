//
//  DetailVC.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by admin on 7/13/24.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var instructionsScrollView: UIScrollView!
    
    var viewModel: DetailViewModel?
    
    init(with viewModel: DetailViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupTableView()
        Task {
            if let mealIdString = viewModel?.mealId {
                await viewModel?.fetchMeal(mealIdString: mealIdString)
            }
        }
    }
    
//    func configureNavbar() {
//        guard let mealName = viewModel?.meal?.strMeal else { return }
//        let titleLabel = UILabel()
//        titleLabel.numberOfLines = 2
//        titleLabel.textAlignment = .center
//        titleLabel.font = .systemFont(ofSize: 17)
//        titleLabel.text = mealName + "\nInstructions"
//        navigationItem.titleView = titleLabel
//    }
    
    func configureNavbar() {
        navigationItem.title = viewModel?.meal?.strMeal
    }
    
    func configureInstructionsLabels() {
        let instructionsTitleLabel = UILabel()
        instructionsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsTitleLabel.text = "Instructions:"
        instructionsTitleLabel.textAlignment = .left
        instructionsTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
//        view.addSubview(instructionsTitleLabel)
//        NSLayoutConstraint.activate([
//            instructionsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
//            instructionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
//        ])
        
        instructionsScrollView.addSubview(instructionsTitleLabel)
        NSLayoutConstraint.activate([
            instructionsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            instructionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
        
        instructionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionsScrollView)
        
        
        NSLayoutConstraint.activate([
            instructionsScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            instructionsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            instructionsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            instructionsScrollView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -15)
        ])
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.numberOfLines = 0
        instructionsLabel.text = viewModel?.meal?.strInstructions
        instructionsScrollView.addSubview(instructionsLabel)
        NSLayoutConstraint.activate([
//            instructionsLabel.leadingAnchor.constraint(equalTo: instructionsScrollView.leadingAnchor),
            instructionsLabel.topAnchor.constraint(equalTo: instructionsScrollView.topAnchor),
//            instructionsLabel.trailingAnchor.constraint(equalTo: instructionsScrollView.trailingAnchor),
            instructionsLabel.bottomAnchor.constraint(equalTo: instructionsScrollView.bottomAnchor),
            instructionsLabel.widthAnchor.constraint(equalTo: instructionsScrollView.widthAnchor)
        ])
        
//        instructionsScrollView.contentSize = instructionsLabel.intrinsicContentSize
    }
    
    func bindViewModel() {
        viewModel?.onMealUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.configureNavbar()
                self?.configureInstructionsLabels()
                self?.tableView.reloadData()
//                self?.
            }
        }
        
        viewModel?.onErrorMessageUpdated = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Notify App Admin of Error:", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self?.present(alert, animated: true)
            }
        }
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - TableView Delegate & Data Source
extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.rowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredients = viewModel?.ingredients else { return UITableViewCell()}
        guard let measurements = viewModel?.measurements else { return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = "\(ingredients[indexPath.row]): \(measurements[indexPath.row])"
        return cell
    }
}
