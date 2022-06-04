//
//  CurrencyTableViewController.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 24/05/2022.
//

import UIKit
import Alamofire

class CurrencyTableViewController: UIViewController {
    
    let tableView = UITableView()
    let userDefaults = UserDefaults()
    var favouriteCurrency: [CurrencyValue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        
//        setupBaseCurrencyButton()
        setupFavouriteCurrencyButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gettingCurrency()
    }
    
    func gettingCurrency() {
        let favouriteCurrencyCode = self.userDefaults.array(forKey: "favouriteCurrency") as? [String] ?? []
        GettingCurrency.shared.getUsers(favouriteCurrencyCode: favouriteCurrencyCode) { result in
            switch result {
            case .success(let curr):
                guard let currFirst = curr.first else { return }
                self.favouriteCurrency = Array(currFirst.data.values)
                self.favouriteCurrency.sort(by: {$0.code < $1.code})
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    /*
    func setupBaseCurrencyButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(baseCurrencyButtonPressed))
        self.navigationItem.leftBarButtonItem = button
    }
    @objc func baseCurrencyButtonPressed() {
    }*/
    
    func setupFavouriteCurrencyButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(favouriteCurrencyButtonPressed))
        self.navigationItem.rightBarButtonItem = button
    }
    @objc func favouriteCurrencyButtonPressed() {
        let selectingCurrencyVC = SelectingCurrencyViewController()
        navigationController?.pushViewController(selectingCurrencyVC, animated: true)
    }
}

extension CurrencyTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteCurrency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: CurrencyTableViewCell.reuseID)
        cell.selectionStyle = .none
        cell.textLabel?.text = favouriteCurrency[indexPath.row].code
        cell.detailTextLabel?.text =  String(favouriteCurrency[indexPath.row].value)
        return cell
    }
}

private extension CurrencyTableViewController {
    func addSubviews() {
        view.addSubview(tableView)
    }
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
