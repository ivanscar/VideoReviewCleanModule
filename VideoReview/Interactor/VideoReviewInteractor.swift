//
//  VideoReviewInteractor.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 04.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

final class VideoReviewInteractor {
    
    // MARK: - Typealias
    typealias Model = VideoReviewInteractorModel
    
    // MARK: - Properties
    private let router: VideoReviewRouterInput
    private let presenter: VideoReviewPresenterInput
    private var model: Model
    private let dataManager: VideoReviewDataManager

    // MARK: - Init
    init(
        router: VideoReviewRouterInput,
        presenter: VideoReviewPresenterInput,
        model: Model,
        dataManager: VideoReviewDataManager
    ) {
        self.router = router
        self.presenter = presenter
        self.model = model
        self.dataManager = dataManager
    }
}

extension VideoReviewInteractor: VideoReviewInteractorInput {
    func viewDidLoad() {
        presenter.upate(model: model)
        loadData()
    }
    
    func viewDidTapBackButton() {
        router.dismiss()
    }
    
    func viewDidTapOpenProduct(at index: Int) {
        guard let nmId = model.videoReview.nmIds[safe: index] else {
            return
        }
        router.openProduct(with: nmId, brandName: model.videoReview.brandName ?? .emptyString)
    }
    
    func viewDidTapVideoItem() {
        router.presentVideoScreen(with: model.videoReview.videoUrl)
    }
}

// MARK: - Private methods
extension VideoReviewInteractor {
    private func loadData() {
        let nmStrings = model.videoReview.nmIds.map { String($0) }
        dataManager.fetchEnrichedProducts(with: nmStrings) { [weak self] (products) in
            guard let self = self else { return }
            guard let products = products
            else {
                self.router.showDefaultError()
                return
            }
            self.model.products = products
            self.presenter.upate(model: self.model)
        }
    }
}
