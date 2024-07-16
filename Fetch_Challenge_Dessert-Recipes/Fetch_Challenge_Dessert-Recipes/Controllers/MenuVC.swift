//
//  MenuVC.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by Yan Brunshteyn on 7/9/24.
//

import UIKit

class MenuVC: UIViewController {
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = MenuViewModel()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
        bindViewModel()
        setupTableView()
        Task {
            await viewModel.fetchDesertMeals()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Deselects row when navigating back to MenuVC
        if let selectedIndexPath = selectedIndexPath {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func configureNavbar() {
        navigationItem.title = "Dessert Menu"
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
    }
    
    func bindViewModel() {
        viewModel.onMealsListUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onErrorMessageUpdated = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Notify App Admin of Error:", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self?.present(alert, animated: true)
            }
        }
    }
}

// MARK: - TableView Delegate & Data Source
extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mealsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mealName = viewModel.mealsList[indexPath.row].strMeal
        let mealThumb = viewModel.mealsList[indexPath.row].strMealThumb
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as? MenuItemCell {
            Task {
                await cell.configure(with: MenuItem(imageName: mealThumb, title: mealName))
            }
            return cell
        }
        selectedIndexPath = indexPath
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = tableView.indexPathForSelectedRow
        let detailViewModel = DetailViewModel()
        detailViewModel.mealId = viewModel.mealsList[indexPath.row].idMeal
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC")
                as? DetailVC else { return }
        detailVC.viewModel = detailViewModel
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
