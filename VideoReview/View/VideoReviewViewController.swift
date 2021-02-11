//
//  VideoReviewViewController.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 04.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

private enum Constants {
    static let statusBarBackgroundColor: UIColor = .wbBrandBackground
    static let navigationBarTintColor: UIColor = .wbNavigationBarTitle
    static let navigationBarHeight: CGFloat = 60.0
    static let itemSpacing: CGFloat = 8
    static let itemsRowInset = UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16)
    static let collectionViewSingleContentInset = UIEdgeInsets(
        top: .zero,
        left: .zero,
        bottom: OpenProductButton.height + OpenProductButton.insets.bottom,
        right: .zero
    )
    static let collectionViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    enum OpenProductButton {
        static let height: CGFloat = 44
        static let insets = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
    }
}

final class VideoReviewViewController: UIViewController {
    
    typealias ViewModel = VideoReviewViewModel

    // MARK: - Protocol properties
    private var interactor: VideoReviewInteractorInput
    // MARK: - Properties
    private var model: ViewModel?
    
    // MARK: - Computed properties
    private var items: [ViewModel.Item] { model?.items ?? [] }
    
    private var isSingleProductReview: Bool {
        model?.isSingleProductReview == true
    }
    
    private let flowLayout = UICollectionViewFlowLayout().with {
        $0.minimumInteritemSpacing = .zero
        $0.minimumLineSpacing = .zero
    }
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .wbColorBackgroundCell
        
        view.register(cellWithClass: CollectionCell<VideoPreView>.self)
        view.register(cellWithClass: CollectionCell<VideoDescriptionView>.self)
        view.register(cellWithClass: CollectionCell<CarouselProductView>.self)

        return view
    }()
    private lazy var navigationBar: ProductCardNavbarView = makeNavigationBar()
    private lazy var statusBarView: UIView = makeStatusBarBackgroundView()
    private lazy var openProductButton: WBButton = {
        let button = WBButton()
        button.isHidden = true
        button.set(style: .filled)
        button.setPlacementStyle(.solo)
        button.setColorAndTitle(for: .openProduct)
        button.onTapHandler = { [weak self] _ in
            guard let self = self else { return }
            self.interactor.viewDidTapOpenProduct(at: .zero)
        }

        return button
    }()
    
    // MARK: Init
    init(interactor: VideoReviewInteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.updateColor(color: Constants.statusBarBackgroundColor, tintColor: Constants.navigationBarTintColor)
        statusBarView.backgroundColor = Constants.statusBarBackgroundColor
    }
    
    // MARK: - Private methods
    private func setup() {
        edgesForExtendedLayout = []
        navigationItem.largeTitleDisplayMode = .never
        setupCollectionView()
        view.addSubview(navigationBar)
        setupNavigation()
        view.addSubview(statusBarView)
        addStatusBarViewConstraints()
        view.addSubview(openProductButton)
        addOpenProductButtonConstraints()
    }
    
    private func addOpenProductButtonConstraints() {
        openProductButton.makeConstraints {
            $0.horizontally.bottom.equalToSuperView().inset(Constants.OpenProductButton.insets.left)
            $0.height.equalTo(Constants.OpenProductButton.height)
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    private func makeNavigationBar() -> ProductCardNavbarView {
        let view = ProductCardNavbarView.loadFromNib()
        view.delegate = self
        
        let isHiddenBackButton = navigationController?.splitViewController != nil
        view.update(isHiddenBackButton: isHiddenBackButton)
        view.update(likeButtonState: .hidden)
        view.update(isShareButtonHidden: true)
        
        return view
    }
    
    private func setupNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let vc = navigationController?.children.last(where: { $0.navigationItem.searchController != nil }) {
            if vc.navigationItem.searchController?.isActive == true {
                vc.navigationItem.searchController?.dismiss(animated: false)
                if #available(iOS 13.0, *) {} else {
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.setNavigationBarHidden(true, animated: true)
                    }
                }
            }
            searchControllerVisibilityHack(isHidden: true)
        }
        addNavigationBarConstraints()
        navigationBar.update(alpha: .zero)
    }
    
    private func makeStatusBarBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = Constants.statusBarBackgroundColor
        return view
    }
    
    private func addNavigationBarConstraints() {
        navigationBar.makeConstraints { (make) in
            make.horizontally.equalToSuperView()
            make.top.equalTo(view.cm.safeArea)
            make.height.equalTo(Constants.navigationBarHeight)
        }
    }
    
    private func addStatusBarViewConstraints() {
        statusBarView.makeConstraints { (make) in
            make.horizontally.top.equalToSuperView()
            make.bottom.equalTo(navigationBar.cm.top)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension VideoReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = items[safe: indexPath.row] else {
            return collectionView.dequeueCell(withClass: UICollectionViewCell.self, for: indexPath)
        }
        switch item {
        case .videoPreview(let viewModel):
            let cell = collectionView.dequeueCell(withClass: CollectionCell<VideoPreView>.self, for: indexPath)
            cell.view.reload(viewModel)
            cell.view.delegate = self
            return cell
        case .description(let viewModel):
            let cell = collectionView.dequeueCell(withClass: CollectionCell<VideoDescriptionView>.self, for: indexPath)
            cell.view.reload(viewModel)
            return cell
        case .goods(let viewModel):
            let cell = collectionView.dequeueCell(withClass: CollectionCell<CarouselProductView>.self, for: indexPath)
            cell.view.reload(viewModel)
            cell.view.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoReviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = items[safe: indexPath.row] else { return .zero }

        switch item {
        case .videoPreview:
            let rowHeight = VideoPreView.height()
            return CGSize(
                width: collectionView.contentWidth,
                height: rowHeight
            )
        case .description(let model):
            return CGSize(
                width: collectionView.contentWidth,
                height: VideoDescriptionView.height(with: model, for: collectionView.contentWidth)
            )
        case .goods(let model):
            return CGSize(
                width: collectionView.contentWidth,
                height: CarouselProductView.height(with: model, for: collectionView.contentWidth)
            )
        }
    }
}

extension VideoReviewViewController: VideoReviewViewControllerInput {
    
    func set(model: VideoReviewViewModel) {
        self.model = model
        openProductButton.isHidden = !isSingleProductReview
        collectionView.contentInset = model.contentInset
    }
    
    func reload() {
        collectionView.reloadData()
    }
}

extension VideoReviewViewController: ProductCardNavbarViewProtocol {
    func didTouchLikeButton() {}
    
    func didTouchShareButton(source: UIView) {}
    
    func didTouchBackButton() {
        interactor.viewDidTapBackButton()
    }
}

extension VideoReviewViewController: CustomNavigationSupport {
    
    var prefersNavigationBarHidden: Bool {
        return true
    }
}

extension VideoReviewViewController: VideoPreviewPlayButtonDelegate {
    func videoPreviewDidTapPlayButton() {
        interactor.viewDidTapVideoItem()
    }
}

extension VideoReviewViewController: PanelAlertProtocol {}

extension VideoReviewViewController: CarouselProductViewDelegate {
    func didSelectItem(at index: Int) {
        interactor.viewDidTapOpenProduct(at: index)
    }
}
