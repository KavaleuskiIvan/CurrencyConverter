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
    
    let tableView = UITableView()
    var currencyInformation: [CurrencyValue] = []
    var baseCurrencyString: String?
    var baseCurrency: CurrencyValue?
    weak var delegate: BaseCurrencyTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Base currency"
        
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
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -view.frame.width/5).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BaseCurrencyTableViewCell.self, forCellReuseIdentifier: BaseCurrencyTableViewCell.reuseID)
    }
    
    func gettingCurrency() {
        baseCurrencyString = UserDefaults().string(forKey: "baseCurrency")
        GettingCurrency.shared.getUsers(favouriteCurrencyCode: [], baseCurrency: baseCurrencyString) { [weak self] (result) in
            switch result {
            case .success(let curr):
                guard let currFirst = curr.first else { return }
                self?.currencyInformation = Array(currFirst.data.values)
                self?.currencyInformation.sort(by: {$0.code < $1.code})
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension BaseCurrencyTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencyInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: BaseCurrencyTableViewCell.reuseID)
        cell.selectionStyle = .default
        cell.textLabel?.text = currencyInformation[indexPath.row].code
        if currencyInformation[indexPath.row].code == baseCurrencyString {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        baseCurrencyString = currencyInformation[indexPath.row].code
        UserDefaults().set(baseCurrencyString, forKey: "baseCurrency")
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
