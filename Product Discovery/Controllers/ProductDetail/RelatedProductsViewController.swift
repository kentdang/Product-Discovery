//
//  RelatedProductsViewController.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/2/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class RelatedProductsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let service: SearchService
    
    init(limit: Int, network: PDNetworking) {
        self.service = SearchService(limit: limit, network: network)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.service = SearchService(limit: 10, network: PDNetworkManager())
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        service.delegate = self
        service.search(for: "")
    }
}

extension RelatedProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, SearchServiceDelegate {
    func searchServiceDidLoadNewData(_ service: SearchService) {
        collectionView.reloadData()
    }
    
    func searchService(_ service: SearchService, didAddData amount: Int) { }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return service.data.result.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(aClass: RelatedProductCell.self, indexPath: indexPath)
        cell.configure(product: service.data.result.products[indexPath.item])
        return cell
    }
}
