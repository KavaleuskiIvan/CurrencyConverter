//
//  ContainerViewController.swift
//  Currency Converter
//
//  Created by Kavaleuski Ivan on 04/06/2022.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var currencyVC = CurrencyTableViewController()
    var baseCurrencyVC: BaseCurrencyTableViewController? = nil
    var selectingCurrencyVC: SelectingCurrencyViewController? = nil
    var navContainerVC: UINavigationController?
    var navBaseCurrencyVC: UINavigationController?
    var navSelectingCurrencyVC: UINavigationController?
    var isBaseCurrencyTableVCMoved = false
    var isSelectingCurrencyTableVCMoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCurrencyTableVC()
    }
    
    func setupCurrencyTableVC() {
        currencyVC.delegate = self
        let navVC = UINavigationController(rootViewController: currencyVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navContainerVC = navVC
    }
    
    func setupBaseCurrencyTableVC() {
        baseCurrencyVC = BaseCurrencyTableViewController()
        baseCurrencyVC?.delegate = self
        guard let baseCurrencyVC = baseCurrencyVC else { return }
        let navVC = UINavigationController(rootViewController: baseCurrencyVC)
        addChild(navVC)
        view.insertSubview(navVC.view, at: 0)
        navVC.didMove(toParent: self)
        self.navBaseCurrencyVC = navVC
    }
    
    func removeBaseCurrencyTableVC() {
        guard let navBaseCurrencyVC = navBaseCurrencyVC else { return }
        navBaseCurrencyVC.willMove(toParent: nil)
        navBaseCurrencyVC.view.removeFromSuperview()
    }
    
    func setupSelectingCurrencyTableVC() {
        selectingCurrencyVC = SelectingCurrencyViewController()
        selectingCurrencyVC?.delegate = self
        guard let selectingCurrencyVC = selectingCurrencyVC else { return }
        let navVC = UINavigationController(rootViewController: selectingCurrencyVC)
        addChild(navVC)
        view.insertSubview(navVC.view, at: 0)
        navVC.didMove(toParent: self)
        self.navSelectingCurrencyVC = navVC
    }
    
    func removeSelectingCurrencyTableVC() {
        guard let navSelectingCurrencyVC = navSelectingCurrencyVC else { return }
        navSelectingCurrencyVC.willMove(toParent: nil)
        navSelectingCurrencyVC.view.removeFromSuperview()
    }
    
    func showBaseCurrencyTableVC(shouldMove: Bool) {
        if shouldMove {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navContainerVC?.view.frame.origin.x = self.currencyVC.view.frame.width - self.currencyVC.view.frame.width/5
            } completion: { (finished) in
                self.currencyVC.tableView.isUserInteractionEnabled = false
            }
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navContainerVC?.view.frame.origin.x = 0
            } completion: { (finished) in
                self.currencyVC.tableView.isUserInteractionEnabled = true
                self.removeBaseCurrencyTableVC()
            }
        }
    }
    
    func showSelectingCurrencyTableVC(shouldMove: Bool) {
        if shouldMove {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navContainerVC?.view.frame.origin.x = -(self.currencyVC.view.frame.width - self.currencyVC.view.frame.width/5)
            } completion: { (finished) in
                self.currencyVC.tableView.isUserInteractionEnabled = false
            }
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut) {
                self.navContainerVC?.view.frame.origin.x = 0
            } completion: { (finished) in
                self.currencyVC.tableView.isUserInteractionEnabled = true
                self.removeSelectingCurrencyTableVC()
            }
        }
    }
}

//MARK: CurrencyTableViewControllerDelegate
extension ContainerViewController: CurrencyTableViewControllerDelegate {
    func openBaseCurrencyTableVC() {
        setupBaseCurrencyTableVC()
        isBaseCurrencyTableVCMoved = !isBaseCurrencyTableVCMoved
        showBaseCurrencyTableVC(shouldMove: isBaseCurrencyTableVCMoved)
    }
    func openSelectingCurrencyTableVC() {
        setupSelectingCurrencyTableVC()
        isSelectingCurrencyTableVCMoved = !isSelectingCurrencyTableVCMoved
        showSelectingCurrencyTableVC(shouldMove: isSelectingCurrencyTableVCMoved)
    }
}

//MARK: BaseCurrencyTableViewControllerDelegate
extension ContainerViewController: BaseCurrencyTableViewControllerDelegate {
    func closeBaseCurrencyTableVC() {
        isBaseCurrencyTableVCMoved = !isBaseCurrencyTableVCMoved
        showBaseCurrencyTableVC(shouldMove: isBaseCurrencyTableVCMoved)
        currencyVC.gettingCurrency()
        currencyVC.setupNavigationItemTitle()
    }
}

//MARK: SelectingCurrencyViewControllerDelegate
extension ContainerViewController: SelectingCurrencyViewControllerDelegate {
    func closeSelectingCurrencyVC() {
        isSelectingCurrencyTableVCMoved = !isSelectingCurrencyTableVCMoved
        showSelectingCurrencyTableVC(shouldMove: isSelectingCurrencyTableVCMoved)
        currencyVC.gettingCurrency()
    }
}
