//
//  SelectingCurrencyViewController.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 31/05/2022.
//

import UIKit

protocol SelectingCurrencyViewControllerDelegate: AnyObject {
    func closeSelectingCurrencyVC()
}

class SelectingCurrencyViewController: UIViewController {
    let userDefaults = UserDefaults()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var currencyInformationSB: [CurrencyValue] = []
    var currencyInformation: [CurrencyValue] = []
    var favouriteCurrency: [CurrencyValue] = []
    var baseCurrencyString: String? = ""
    
    weak var delegate: SelectingCurrencyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favourite currency"
        
        setupSearchBar()
        
        setupTableView()
        
        gettingCurrency()
        
        setupRightSwipe()
    }
    
    func setupRightSwipe() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightFunc(gesture:)))
        swipeRight.direction = .right
        
        self.tableView.addGestureRecognizer(swipeRight)
    }
    @objc func swipeRightFunc(gesture: UIGestureRecognizer) {
        delegate?.closeSelectingCurrencyVC()
    }
    
    func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width/5).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: view.frame.height/15).isActive = true
        searchBar.delegate = self
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.frame.width/5).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectingCurrencyTableViewCell.self, forCellReuseIdentifier: SelectingCurrencyTableViewCell.reuseIdentifier)
    }
    
    func gettingCurrency() {
        baseCurrencyString = userDefaults.string(forKey: "baseCurrency")
        GettingCurrency.shared.getUsers(favouriteCurrencyCode: [], baseCurrency: baseCurrencyString) { [weak self] (result) in
            switch result {
            case .success(let curr):
                guard let currFirst = curr.first else { return }
                guard let self = self else { return }
                self.currencyInformation = Array(currFirst.data.values)
                self.currencyInformation.sort(by: {$0.code < $1.code})
                let favouriteCurrencyCode = self.userDefaults.array(forKey: "favouriteCurrency") as? [String] ?? []
                for curr in favouriteCurrencyCode {
                    let favCurr = self.currencyInformation.first(where: {$0.code == curr})
                    if favCurr != nil {
                        self.favouriteCurrency.append(favCurr!)
                    }
                }
                self.currencyInformationSB = self.currencyInformation
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveFavouriteCurrency() {
        userDefaults.removeObject(forKey: "favouriteCurrency")
        var favouriteCurrencyCode: [String] = []
        self.favouriteCurrency.sort(by: {$0.code < $1.code})
        for currency in favouriteCurrency {
            favouriteCurrencyCode.append(currency.code)
        }
        userDefaults.set(favouriteCurrencyCode, forKey: "favouriteCurrency")
        tableView.reloadData()
    }
}

extension SelectingCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = ["Favourite Currency","Currencies"]
        return sectionName[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = [favouriteCurrency,currencyInformationSB]
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: SelectingCurrencyTableViewCell.reuseIdentifier)
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            if favouriteCurrency.count != 0 {
                for curr in favouriteCurrency {
                    if currencyInformation.first(where: { value in value.code == curr.code }) != nil {
                        cell.accessoryType = .checkmark
                    }
                }
                cell.textLabel?.text = favouriteCurrency[indexPath.row].code
                cell.detailTextLabel?.text = String(favouriteCurrency[indexPath.row].value)
                return cell
            }
            return cell
        default:
            for curr in favouriteCurrency {
                if curr.code == currencyInformationSB[indexPath.row].code {
                    cell.accessoryType = .checkmark
                }
            }
            cell.textLabel?.text = currencyInformationSB[indexPath.row].code
            cell.detailTextLabel?.text = String(currencyInformationSB[indexPath.row].value)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            switch indexPath.section {
            case 0:
                let index = favouriteCurrency.firstIndex { value in
                    value.code == favouriteCurrency[indexPath.row].code
                }
                if let index = index {
                    favouriteCurrency.remove(at: index)
                }
            default:
                let index = favouriteCurrency.firstIndex { value in
                    value.code == currencyInformationSB[indexPath.row].code
                }
                if let index = index {
                    favouriteCurrency.remove(at: index)
                }
            }
            saveFavouriteCurrency()
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            favouriteCurrency.append(currencyInformationSB[indexPath.row])
            self.favouriteCurrency.sort(by: {$0.code < $1.code})
            saveFavouriteCurrency()
        }
    }
}

extension SelectingCurrencyViewController: UISearchBarDelegate {
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
