//
//  BaseCurrencyViewController.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 04/06/2022.
//

import UIKit

protocol BaseCurrencyTableViewControllerDelegate: AnyObject {
    func closeBaseCurrencyTableVC()
}

class BaseCurrencyTableViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    var currencyInformationSB: [CurrencyValue] = []
    var currencyInformation: [CurrencyValue] = []
    var baseCurrencyString: String?
    var baseCurrency: CurrencyValue?
    weak var delegate: BaseCurrencyTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Base currency"
        
        setupSearchBar()
        
        setupTableView()
        
        gettingCurrency()
        
        setupLeftSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gettingCurrency()
    }
    
    func setupLeftSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftFunc(gesture:)))
        swipeLeft.direction = .left
        
        self.tableView.addGestureRecognizer(swipeLeft)
    }
    @objc func swipeLeftFunc(gesture: UIGestureRecognizer) {
        delegate?.closeBaseCurrencyTableVC()
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -view.frame.width/5).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: view.frame.height/15).isActive = true
        searchBar.delegate = self
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -view.frame.width/5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseCurrencyTableViewCell.self, forCellReuseIdentifier: BaseCurrencyTableViewCell.reuseIdentifier)
    }
    
    func gettingCurrency() {
        baseCurrencyString = UserDefaults().string(forKey: "baseCurrency")
        GettingCurrency.shared.getUsers(favouriteCurrencyCode: [], baseCurrency: baseCurrencyString) { [weak self] (result) in
            switch result {
            case .success(let curr):
                guard let currFirst = curr.first else { return }
                guard let self = self else { return }
                self.currencyInformation = Array(currFirst.data.values)
                self.currencyInformation.sort(by: {$0.code < $1.code})
                self.currencyInformationSB = self.currencyInformation
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension BaseCurrencyTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyInformationSB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: BaseCurrencyTableViewCell.reuseIdentifier)
        cell.selectionStyle = .default
        cell.textLabel?.text = currencyInformationSB[indexPath.row].code
        if currencyInformationSB[indexPath.row].code == baseCurrencyString {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        baseCurrencyString = currencyInformationSB[indexPath.row].code
        UserDefaults().set(baseCurrencyString, forKey: "baseCurrency")
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

extension BaseCurrencyTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        currencyInformationSB = []
        
        if searchText == "" {
            currencyInformationSB = currencyInformation
        }
        
        for word in currencyInformation {
            if word.code.uppercased().contains(searchText.uppercased()) {
                currencyInformationSB.append(word)
            }
        }
        tableView.reloadData()
    }
}
