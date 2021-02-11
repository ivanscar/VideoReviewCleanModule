//
//  VideoDescriptionView.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 08.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

private enum Constants {
    
    enum TitleLabel {
        static let font = UIFont.semibold(size: 19)
        static let textColor = UIColor.wbColorTextPrimary
        static let insets = UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
    }
    enum InfoStackView {
        static let numberOfLines = 1
        static let font = UIFont.regular(size: 13)
        static let spacing: CGFloat = 0
        static let textColor = UIColor.wbColorTextComment
        static let insets = UIEdgeInsets(top: 4, left: 8, bottom: 24, right: 0)
    }
    enum DescriptionLabel {
        static let font = UIFont.regular(size: 15)
        static let textColor = UIColor.wbColorTextPrimary
        static let insets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
    }
}

final class VideoDescriptionView: UIView {
    
    typealias ViewModel = VideoReviewViewModel.Description

    // MARK: - Subviews
    private lazy var titleLabel = UILabel().with {
        $0.numberOfLines = .zero
        $0.font = Constants.TitleLabel.font
        $0.textColor = Constants.TitleLabel.textColor
    }
    private lazy var infoStackView = UIStackView().with {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = Constants.InfoStackView.spacing
    }
    private lazy var descriptionLabel = UILabel().with {
        $0.numberOfLines = .zero
        $0.font = Constants.DescriptionLabel.font
        $0.textColor = Constants.DescriptionLabel.textColor
    }
    
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
        titleLabel.text = model.title
        updateStackView(model)
        descriptionLabel.text = model.description
    }
    
    // MARK: - Private methods
    private func setup() {
        addSubviews([
            titleLabel,
            infoStackView,
            descriptionLabel
        ])
        addConstraints()
    }
    
    private func addConstraints() {
        titleLabel.makeConstraints {
            $0.top.equalToSuperView().offset(Constants.TitleLabel.insets.top)
            $0.horizontally.equalToSuperView().inset(Constants.TitleLabel.insets.left)
        }
        infoStackView.makeConstraints {
            $0.top.equalTo(titleLabel.cm.bottom).offset(Constants.InfoStackView.insets.top)
            $0.horizontally.equalTo(titleLabel)
            $0.bottom.lessOrEqualTo(self).inset(Constants.InfoStackView.insets.bottom)
        }
        descriptionLabel.makeConstraints {
            $0.top.equalTo(infoStackView.cm.bottom).offset(Constants.DescriptionLabel.insets.top)
            $0.horizontally.equalToSuperView().inset(Constants.DescriptionLabel.insets.left)
        }
    }
    
    private func updateStackView(_ model: ViewModel) {
        infoStackView.removeArrangedSubviews()
        let arrangedSubviews = [
            makeLabel(with: model.brandName),
            makeLabel(with: model.videoInfo)
        ].compactMap { $0 }
        arrangedSubviews.forEach {
            infoStackView.addArrangedSubview($0)
        }
    }

    private func makeLabel(with text: String?) -> UILabel? {
        guard let text = text else { return nil }
        let label = UILabel()
        label.numberOfLines = Constants.InfoStackView.numberOfLines
        label.font = Constants.InfoStackView.font
        label.textColor = Constants.InfoStackView.textColor
        label.text = text
        return label
    }
}

extension VideoDescriptionView {
    static func height(with viewModel: ViewModel, for width: CGFloat) -> CGFloat {
        let contentWidth = width - Constants.TitleLabel.insets.horizontal
        let titleHeight = viewModel.title.height(constraintedWidth: contentWidth, font: Constants.TitleLabel.font)
            + Constants.TitleLabel.insets.vertical
        var infoHeight: CGFloat = Constants.InfoStackView.insets.vertical
        if !viewModel.brandName.isEmpty {
            infoHeight += viewModel.brandName.height(constraintedWidth: contentWidth, font: Constants.InfoStackView.font)
        }
        if !viewModel.videoInfo.isEmpty {
            infoHeight += viewModel.videoInfo.height(constraintedWidth: contentWidth, font: Constants.InfoStackView.font)
        }
        var descriptionHeight: CGFloat = 0
        if !viewModel.description.isEmpty {
            descriptionHeight = viewModel.description.height(constraintedWidth: contentWidth, font: Constants.DescriptionLabel.font)
                + Constants.DescriptionLabel.insets.vertical
        }
        let heights = [titleHeight, infoHeight, descriptionHeight]
        return heights.reduce(.zero, +)
    }
}
