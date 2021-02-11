//
//  VideoReviewContract.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 04.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

// MARK: - View
protocol VideoReviewViewControllerInput: AnyObject {
    func set(model: VideoReviewViewModel)
    func reload()
}

// MARK: - Interactor
protocol VideoReviewInteractorInput: AnyObject {
    func viewDidLoad()
    func viewDidTapBackButton()
    func viewDidTapOpenProduct(at index: Int)
    func viewDidTapVideoItem()
}

// MARK: - Presenter
protocol VideoReviewPresenterInput {
    func upate(model: VideoReviewInteractorModel)
}

// MARK: - Router
protocol VideoReviewRouterInput {
    func dismiss()
    func openProduct(with nm: Int, brandName: String)
    func presentVideoScreen(with urlString: String)
    func showDefaultError()
}
