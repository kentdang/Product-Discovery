//
//  ProductDetailViewController.swift
//  Product Discovery
//
//  Created by Kent DANG on 8/31/19.
//  Copyright © 2019 Kent DANG. All rights reserved.
//

import UIKit

private enum Method {
    case productDetail, technicalSpecs, comparePrice
}

class ProductDetailViewController: UIViewController {
    @IBOutlet private weak var titleView: UIView!
    @IBOutlet private weak var titleViewNameLabel: UILabel!
    @IBOutlet private weak var titleViewPriceLabel: UILabel!
    @IBOutlet private weak var cartOutlinedButton: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var skuLabel: UILabel!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var supplierSalePriceLabel: UILabel!
    @IBOutlet private weak var promotionLabel: UILabel!
    @IBOutlet private weak var productDetailButton: UIButton!
    @IBOutlet private weak var technicalSpecsButton: UIButton!
    @IBOutlet private weak var comparePriceButton: UIButton!
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var methodViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var detailContainerView: UIView!
    @IBOutlet private weak var technicalSpecsContainerView: UIView!
    @IBOutlet private weak var comparePriceContainerView: UIView!
    @IBOutlet private weak var cartView: UIView!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var loadingView: UIView!
    private weak var detailViewController: ProductDescriptionViewController!
    private weak var technicalSpecsViewController: ProductTechinalSpecsViewController!
    private weak var comparePriceViewController: ProductComparePriceViewController!
    
    class var totalInCart: Int {
        return UserDefaults.amountInCart.reduce(0) { $0 + $1.value }
    }
    
    private var detail: ProductDetail? {
        didSet {
            if let images = detail?.images.sorted(by: { $0.priority < $1.priority }), !images.isEmpty {
                self.images = images
            } else {
                self.images = [Image(url: "", priority: 0)]
            }
            display()
        }
    }
    
    private var images: [Image] = [Image(url: "", priority: 0)]
    
    private var amount: Int = 0 {
        didSet {
            guard amount != oldValue else { return }
            updateProductCartAmount()
        }
    }
    
    private var isShowLoading = true {
        didSet {
            loadingView?.isHidden = !isShowLoading
        }
    }
    
    private var selectedMethod: Method = .productDetail
    
    private let service: ProductService
    
    private var navigationColors: (barTint: UIColor?, tint: UIColor?)?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    init(network: PDNetworking) {
        service = ProductService(network: network)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        service = ProductService(network: PDNetworkManager())
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        display()
        updateProductCartAmount()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let controller = segue.destination as? ProductDescriptionViewController {
            controller.delegate = self
            detailViewController = controller
        } else if let controller = segue.destination as? ProductTechinalSpecsViewController {
            controller.delegate = self
            technicalSpecsViewController = controller
        } else if let controller = segue.destination as? ProductComparePriceViewController {
            controller.delegate = self
            comparePriceViewController = controller
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restoreNavigationBar()
    }
    
    func loadProduct(_ product: Product) {
        var detail = product.detail
        let context = PDDatabase.database.persistentContainer.viewContext
        if let savedData = SavedProductDetail.fetchItem(sku: product.sku, in: context), let attributeGroups = savedData.attributeGroups {
            detail.attributeGroups = attributeGroups.value.compactMap { ProductDetail.AttributeGroup(dictionary: $0) }
            isShowLoading = false
        }
        self.detail = detail
        service.getDetail(for: product.sku) { [weak self] result in
            guard let this = self else { return }
            if case let .success(detail) = result {
                this.detail = detail
                SavedProductDetail.createOrUpdate(from: detail, in: context)
            }
            this.isShowLoading = false
        }
    }
}

private extension ProductDetailViewController {
    func setup() {
        NotificationCenter.addObserver(self, selector: #selector(amountInCartDidChange), key: .amountInCartDidChange)
        loadingView.isHidden = !isShowLoading
        navigationItem.titleView = titleView
        titleView.sizeToFit()
        DispatchQueue.main.async {
            self.selectMethod(.productDetail, forced: true)
        }
    }
    
    func updateNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationColors = (barTint: navigationBar.barTintColor, tint: navigationBar.tintColor)
        navigationController?.navigationBar.barTintColor = UIColor.detailNavigationBarTint
        navigationController?.navigationBar.tintColor = UIColor.detailNavigationText
    }
    
    func restoreNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar, let navigationColors = navigationColors else { return }
        navigationBar.barTintColor = navigationColors.barTint
        navigationBar.tintColor = navigationColors.tint
    }
    
    func display() {
        guard isViewLoaded, let detail = detail else { return }
        cartOutlinedButton.setBadgeNumber(ProductDetailViewController.totalInCart)
        titleViewNameLabel.text = detail.name
        titleViewPriceLabel.text = detail.price.priceText
        collectionView.reloadData()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        nameLabel.text = detail.name
        let skuText = NSMutableAttributedString(string: "Mã SP: ", attributes: [.foregroundColor: UIColor.detailSubText])
        skuText.append(NSAttributedString(string: detail.sku, attributes: [.foregroundColor: UIColor.deepSkyBlue]))
        skuLabel.attributedText = skuText
        statusView.backgroundColor = detail.status.style.backgroundColor
        statusLabel.textColor = detail.status.style.textColor
        statusLabel.text = detail.status.text
        priceLabel.text = detail.price.priceText
        if let saleOff = detail.price.saleOff {
            supplierSalePriceLabel.attributedText = saleOff.oldPriceText
            promotionLabel.text = "-\(Int(saleOff.percent))%"
            promotionLabel.superview?.isHidden = false
        } else {
            supplierSalePriceLabel.attributedText = nil
            promotionLabel.text = ""
            promotionLabel.superview?.isHidden = true
        }
        technicalSpecsViewController?.configure(attributes: detail.sortedAttributeGroups)
        cartView.isHidden = !(detail.status.isEnabled && detail.price.sellPrice != nil)
    }
    
    func updateProductCartAmount() {
        guard isViewLoaded else { return }
        amountLabel.text = amount < 100 ? "\(amount)" : "99+"
        if let price = detail?.price, let sellPrice = price.sellPrice {
            let total = sellPrice * Double(amount)
            totalLabel.text = total.formattedCurrency(currencyCode: price.currencyCode)
        } else {
            totalLabel.text = Double.formattedCurrency(of: 0, currencyCode: Price.defaultCurrencyCode)
        }
    }
    
    @IBAction func selectMethod(sender: UIButton) {
        guard let method = method(for: sender) else { return }
        selectMethod(method, animated: true)
    }
    
    @IBAction func increase(sender: UIButton) {
        guard let detail = detail, detail.status.isEnabled && detail.price.sellPrice != nil else { return }
        amount += 1
    }
    
    @IBAction func descrease(sender: UIButton) {
        guard let detail = detail, detail.status.isEnabled && detail.price.sellPrice != nil else { return }
        amount = max(0, amount - 1)
    }
    
    @IBAction func addToCart(sender: UIButton) {
        guard let detail = detail, detail.status.isEnabled else { return }
        UserDefaults.amountInCart[detail.sku] = (UserDefaults.amountInCart[detail.sku] ?? 0) + amount
        amount = 0
    }
    
    @objc func amountInCartDidChange() {
        guard isViewLoaded else { return }
        cartOutlinedButton.setBadgeNumber(ProductDetailViewController.totalInCart)
    }
    
    @IBAction func pageControlDidChange(sender: UIPageControl) {
        guard sender.currentPage < images.count else { return }
        collectionView.scrollToItem(at: IndexPath(item: sender.currentPage, section: 0), at: .left, animated: true)
    }
}

private extension ProductDetailViewController {
    var buttonForSelectedMethod: UIButton! {
        switch selectedMethod {
        case .productDetail: return  productDetailButton
        case .technicalSpecs: return  technicalSpecsButton
        case .comparePrice: return  comparePriceButton
        }
    }
    
    var containerViewForSelectedMethod: UIView! {
        switch selectedMethod {
        case .productDetail: return  detailContainerView
        case .technicalSpecs: return  technicalSpecsContainerView
        case .comparePrice: return  comparePriceContainerView
        }
    }
    
    var controllerForSelectedMethod: ProductMethodViewController! {
        switch selectedMethod {
        case .productDetail: return  detailViewController
        case .technicalSpecs: return  technicalSpecsViewController
        case .comparePrice: return  comparePriceViewController
        }
    }
    
    func method(for button: UIButton) -> Method? {
        switch button {
        case productDetailButton: return .productDetail
        case technicalSpecsButton: return .technicalSpecs
        case comparePriceButton: return .comparePrice
        default: return nil
        }
    }
    
    func selectMethod(_ method: Method, forced: Bool = false, animated: Bool = false) {
        guard isViewLoaded && (method != selectedMethod || forced) else { return }
        selectedMethod = method
        let button: UIButton = buttonForSelectedMethod
        var buttons: [UIButton] = [productDetailButton, technicalSpecsButton, comparePriceButton]
        let containerView: UIView = containerViewForSelectedMethod
        var containerViews: [UIView] = [detailContainerView, technicalSpecsContainerView, comparePriceContainerView]
        guard let index1 = buttons.firstIndex(of: button), let index2 = containerViews.firstIndex(of: containerView) else { return }
        buttons.remove(at: index1)
        if let titleLabel = button.titleLabel {
            let titleRect = titleLabel.convert(titleLabel.bounds, to: button.superview)
            var frame = indicatorView.frame
            frame.origin.x = titleRect.minX
            frame.size.width = titleRect.width
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                self.indicatorView.frame = frame
                buttons.forEach { $0.setTitleColor(.detailSubText, for: .normal) }
                button.setTitleColor(.detailNavigationText, for: .normal)
            }
        }
        containerViews.remove(at: index2)
        containerViews.forEach { $0.isHidden = true }
        containerView.isHidden = false
        controllerForSelectedMethod.updateLayout()
    }
}

extension ProductDetailViewController: ProductMethodViewControllerDelegate {
    func productMethodViewController(_ controller: UIViewController, didChangeHeight height: CGFloat) {
        guard controllerForSelectedMethod == controller else { return }
        methodViewHeight.constant = height + 43
    }
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(aClass: ProductDetailImageCell.self, indexPath: indexPath)
        cell.configure(url: images[indexPath.row].url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let pos = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width)
            pageControl.currentPage = min(max(pos, 0), pageControl.numberOfPages - 1)
        }
    }
}
