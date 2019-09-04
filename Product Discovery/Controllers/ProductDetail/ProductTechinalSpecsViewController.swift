//
//  ProductTechinalSpecsViewController.swift
//  Product Discovery
//
//  Created by Kent DANG on 9/1/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

class ProductTechinalSpecsViewController: ProductMethodViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var bottomIconView: UIImageView!
    
    private var attributes: [ProductDetail.AttributeGroup] = [] {
        didSet {
            tableView.reloadData()
            updateLayout()
        }
    }
    
    private var isExpanded = false {
        didSet {
            guard isExpanded != oldValue else { return }
            updateLayout()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(attributes: [ProductDetail.AttributeGroup]) {
        self.attributes = attributes
    }
    
    override func updateLayout() {
        guard isViewLoaded else { return }
        let numberOfRowWhenCollapsed = 4
        if attributes.count <= numberOfRowWhenCollapsed {
            configureNormalLayout()
        } else {
            isExpanded ? configureExpandedLayout() : configureCollapsedLayout()
        }
    }
}

private extension ProductTechinalSpecsViewController {
    func setup() {
        gradientView.backgroundColor = UIColor.clear
        let layer = CAGradientLayer()
        layer.frame = gradientView.bounds
        layer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 1)
        layer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientView.layer.addSublayer(layer)
    }
    
    @IBAction func toggle() {
        isExpanded = !isExpanded
    }
    
    func configureCollapsedLayout() {
        gradientView.isHidden = false
        bottomHeight.constant = 42
        bottomIconView.transform = CGAffineTransform(rotationAngle: 0)
        bottomLabel.text = "Hiển thị nhiều hơn"
        delegate?.productMethodViewController(self, didChangeHeight: 194)
    }
    
    func configureExpandedLayout() {
        gradientView.isHidden = true
        bottomHeight.constant = 42
        bottomIconView.transform = CGAffineTransform(rotationAngle: .pi)
        bottomLabel.text = "Hiển thị ít hơn"
        delegate?.productMethodViewController(self, didChangeHeight: CGFloat(attributes.count * 35 + 54))
    }
    
    func configureNormalLayout() {
        gradientView.isHidden = true
        bottomHeight.constant = 0
        delegate?.productMethodViewController(self, didChangeHeight: CGFloat(attributes.count * 35 + 12))
    }
}

extension ProductTechinalSpecsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(aClass: ProductTechnicalSpecsCell.self, indexPath: indexPath)
        let attribute = attributes[indexPath.row]
        cell.configure(name: attribute.name, value: attribute.value, backgroundColor: indexPath.row % 2 == 0 ? .tableBackground : .white)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
