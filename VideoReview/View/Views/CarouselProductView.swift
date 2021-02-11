//
//  CarouselProductView.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 10.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

protocol CarouselProductViewDelegate: AnyObject {
    func didSelectItem(at index: Int)
}

private enum Constants {
    enum Label {
        static let font = UIFont.semibold(size: 19)
        static let textColor = UIColor.wbColorTextPrimary
        static let insets = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
    }
    enum CollectionView {
        static let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let lineSpacing: CGFloat = 8.0
    }
    static let CollectionViewCellSize: CGSize = CGSize(width: 104, height: 233)
}

final class CarouselProductView: UIView {
    
    typealias ViewModel = VideoReviewViewModel.Goods

    // MARK: - Protocols properties
    public weak var delegate: CarouselProductViewDelegate?
    
    // MARK: - Properties
    private var model: ViewModel?

    // MARK: - Subviews
    private lazy var label = UILabel().with {
        $0.font = Constants.Label.font
        $0.textColor = Constants.Label.textColor
    }
    
    private let flowLayout = UICollectionViewFlowLayout().with {
        $0.minimumInteritemSpacing = .zero
        $0.minimumLineSpacing = Constants.CollectionView.lineSpacing
        $0.scrollDirection = .horizontal
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = true
        view.contentInset = Constants.CollectionView.insets
        view.register(nibWithCellClass: CarouselCollectionViewCell.self)

        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reload
    public func reload(_ model: ViewModel) {
        label.text = model.title
        self.model = model
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    private func setup() {
        addSubviews([
            label,
            collectionView
        ])
        addConstraints()
    }
    
    private func addConstraints() {
        label.makeConstraints { (make) in
            make.top.equalToSuperView().inset(Constants.Label.insets.top)
            make.horizontally.equalToSuperView().inset(Constants.Label.insets.left)
        }
        collectionView.makeConstraints { (make) in
            make.top.equalTo(label.cm.bottom).offset(Constants.Label.insets.bottom)
            make.horizontally.bottom.equalToSuperView()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CarouselProductView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.viewModels.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withClass: CarouselCollectionViewCell.self, for: indexPath)
        guard let item = model?.viewModels[safe: indexPath.row]
        else { return cell }

        cell.update(item)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CarouselProductView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.CollectionViewCellSize
    }
}

extension CarouselProductView {
    static func height(with viewModel: ViewModel, for width: CGFloat) -> CGFloat {
        let titleHeight = viewModel.title.height(constraintedWidth: width, font: Constants.Label.font)
            + Constants.Label.insets.vertical
        let collectionViewHeight = Constants.CollectionViewCellSize.height
        let heights = [titleHeight, collectionViewHeight]
        return heights.reduce(.zero, +)
    }
}
