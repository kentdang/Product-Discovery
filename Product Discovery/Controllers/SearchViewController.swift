//
//  SearchViewController.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class PDSearchBar: UISearchBar {
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 44
        return size
    }
}

class SearchViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottom: NSLayoutConstraint!
    
    private var searchText = "" {
        didSet {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
            perform(#selector(search), with: nil, afterDelay: 0.25)
        }
    }
    
    private var service: SearchService
    
    required init?(coder aDecoder: NSCoder) {
        self.service = SearchService(limit: 10, network: PDNetworkManager())
        super.init(coder: aDecoder)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        let searchBar = PDSearchBar()
        searchBar.setImage(UIImage(named: "icSearch"), for: .search, state: .normal)
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        service.delegate = self
        search()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? ProductDetailViewController, let product = sender as? Product {
            controller.loadProduct(product)
        }
    }
}

private extension SearchViewController {
    @objc func search() {
        service.search(for: searchText)
    }
    
    func loadMore() {
        guard tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.height - 50 else { return }
        service.loadMore()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        tableViewBottom.constant = 0
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  {
            var safeAreaBottomInset: CGFloat = 0
            if let window = UIApplication.shared.keyWindow {
                if #available(iOS 11.0, *) {
                    safeAreaBottomInset = window.safeAreaInsets.bottom
                }
            }
            let keyboardSize = keyboardFrame.cgRectValue.size
            let bottomInset = keyboardSize.height - safeAreaBottomInset
            tableViewBottom.constant = bottomInset
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.data.result.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(aClass: SearchItemCell.self, indexPath: indexPath)
        let product = service.data.result.products[indexPath.row]
        cell.configure(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = service.data.result.products[indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: product)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadMore()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadMore()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

extension SearchViewController: SearchServiceDelegate {
    func searchServiceDidLoadNewData(_ service: SearchService) {
        tableView.reloadData()
    }
    
    func searchService(_ service: SearchService, didAddData amount: Int) {
        let index = service.data.result.products.count - amount
        let indexPaths = (index..<service.data.result.products.count).map { IndexPath(row: $0, section: 0) }
        tableView.insertRows(at: indexPaths, with: .none)
    }
}

extension SearchViewController {
    class func controllerFromStoryboard(with network: PDNetworking) -> SearchViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        controller.service = SearchService(limit: 10, network: network)
        return controller
    }
}
