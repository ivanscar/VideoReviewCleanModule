//
//  VideoPreView.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 05.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

protocol VideoPreviewPlayButtonDelegate: AnyObject {
    func videoPreviewDidTapPlayButton()
}

private enum Constants {
    
    static let buttonBackgroundColor = UIColor.black.withAlphaComponent(0.5)
    static let viewHeight: CGFloat = 240
    static let aspectRatio: CGFloat = 660 / 940
}

final class VideoPreView: UIView {
    
    typealias ViewModel = VideoReviewViewModel.VideoPreview
   
    // MARK: - Protocols properties
    public weak var delegate: VideoPreviewPlayButtonDelegate?
    
    // MARK: - Subviews
    private lazy var image = UIImageView().with { (imageView) in
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    private lazy var playButton = UIButton().with { (button) in
        button.setImage(.videoPlayLarge, for: .normal)
        button.backgroundColor = Constants.buttonBackgroundColor
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
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
    public func reload(_ viewModel: ViewModel) {
        image.setCachedImage(with: URL(string: viewModel.thumb))
    }
    
    // MARK: - Private methods
    private func setup() {
        addSubviews([
            image,
            playButton
        ])
        addConstraints()
    }
    
    private func addConstraints() {
        
        image.makeConstraints { (make) in
            make.edges.equalToSuperView()
        }
        
        playButton.makeConstraints { (make) in
            make.edges.equalToSuperView()
        }
    }
    
    @objc
    private func didTapPlayButton() {
        delegate?.videoPreviewDidTapPlayButton()
    }
}

extension VideoPreView {
    static func height() -> CGFloat {
        Constants.viewHeight
    }
}
