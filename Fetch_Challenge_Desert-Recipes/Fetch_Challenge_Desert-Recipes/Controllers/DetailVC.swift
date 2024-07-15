//
//  DetailVC.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by Yan Brunshteyn on 7/13/24.
//

import UIKit

class DetailVC: UIViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
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
    
    func configureNavbar() {
        navigationItem.title = viewModel?.meal?.strMeal
    }
    
    func configureContent() {
        let instructionsTitleLabel = UILabel()
        instructionsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsTitleLabel.text = "Instructions:"
        instructionsTitleLabel.numberOfLines = 1
        instructionsTitleLabel.textAlignment = .left
        instructionsTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        instructionsTitleLabel.layer.zPosition = 1000
        view.addSubview(instructionsTitleLabel)
        NSLayoutConstraint.activate([
            instructionsTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            instructionsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            instructionsTitleLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width),
        ])
        
        let ingredientsMeasurementsTitleLabel = UILabel()
        ingredientsMeasurementsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsMeasurementsTitleLabel.text = "Ingredients/Measurements:"
        ingredientsMeasurementsTitleLabel.numberOfLines = 1
        ingredientsMeasurementsTitleLabel.textAlignment = .left
        ingredientsMeasurementsTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(ingredientsMeasurementsTitleLabel)
        NSLayoutConstraint.activate([
            ingredientsMeasurementsTitleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -5),
            ingredientsMeasurementsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ])
        
        // Instructions embedded inside scroll view
        instructionsScrollView.translatesAutoresizingMaskIntoConstraints = false
        instructionsScrollView.showsVerticalScrollIndicator = true
        instructionsScrollView.isScrollEnabled = true
        instructionsScrollView.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            instructionsScrollView.topAnchor.constraint(equalTo: instructionsTitleLabel.bottomAnchor, constant: 5),
            instructionsScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            instructionsScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            instructionsScrollView.bottomAnchor.constraint(equalTo: ingredientsMeasurementsTitleLabel.topAnchor, constant: -5)
        ])
        
        let instructionsLabel = UILabel()
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.numberOfLines = 0
        instructionsLabel.text = viewModel?.meal?.strInstructions
        instructionsLabel.textAlignment = .justified
        instructionsScrollView.addSubview(instructionsLabel)
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: instructionsScrollView.topAnchor),
            instructionsLabel.widthAnchor.constraint(equalTo: instructionsScrollView.widthAnchor, constant: -30),
            instructionsLabel.centerXAnchor.constraint(equalTo: instructionsScrollView.centerXAnchor),
            instructionsLabel.bottomAnchor.constraint(equalTo: instructionsScrollView.bottomAnchor)
        ])
    }
    
    // Binds viewModel to VC 
    func bindViewModel() {
        viewModel?.onMealUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.configureNavbar()
                self?.configureContent()
                self?.tableView.reloadData()
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
