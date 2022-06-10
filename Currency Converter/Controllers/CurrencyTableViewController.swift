//
//  CurrencyTableViewController.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 24/05/2022.
//

import UIKit
import Alamofire

protocol CurrencyTableViewControllerDelegate: AnyObject {
    func openBaseCurrencyTableVC()
    func openSelectingCurrencyTableVC()
}
extension CurrencyTableViewControllerDelegate {
    func openBaseCurrencyTableVC() {}
    func openSelectingCurrencyTableVC() {}
}

class CurrencyTableViewController: UIViewController {
    
    let tableView = UITableView()
    let userDefaults = UserDefaults()
    var favouriteCurrency: [CurrencyValue] = []
    var baseCurrencyString: String?
    weak var delegate: CurrencyTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItemTitle()
        
        setupRightSwipe()
        setupLeftSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gettingCurrency()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.reuseID)
    }
    
    func setupNavigationItemTitle() {
        baseCurrencyString = userDefaults.string(forKey: "baseCurrency")
        navigationItem.title = baseCurrencyString
    }
    
    func setupRightSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightFunc(gesture:)))
        swipeRight.direction = .right
        
        self.tableView.addGestureRecognizer(swipeRight)
    }
    @objc func swipeRightFunc(gesture: UIGestureRecognizer) {
        delegate?.openBaseCurrencyTableVC()
    }
    
    func setupLeftSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftFunc(gesture:)))
        swipeLeft.direction = .left
        
        self.tableView.addGestureRecognizer(swipeLeft)
    }
    @objc func swipeLeftFunc(gesture: UIGestureRecognizer) {
        delegate?.openSelectingCurrencyTableVC()
    }
    
    func gettingCurrency() {
        let favouriteCurrencyCode = self.userDefaults.array(forKey: "favouriteCurrency") as? [String] ?? []
        baseCurrencyString = userDefaults.string(forKey: "baseCurrency")
        GettingCurrency.shared.getUsers(favouriteCurrencyCode: favouriteCurrencyCode, baseCurrency: baseCurrencyString) { [weak self] (result) in
            switch result {
            case .success(let curr):
                guard let currFirst = curr.first else { return }
                self?.favouriteCurrency = Array(currFirst.data.values)
                self?.favouriteCurrency.sort(by: {$0.code < $1.code})
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
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
