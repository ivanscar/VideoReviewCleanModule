//
//  VideoReviewBuilder.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 04.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

enum VideoReviewBuilder {
    struct Input {
        let model: VideoReviewData
        let servicesProvider: ServicesProvider
        
        init(
            model: VideoReviewData,
            servicesProvider: ServicesProvider
        ) {
            self.model = model
            self.servicesProvider = servicesProvider
        }
    }
    
    static func build(input: Input) -> VideoReviewViewController {
        let model = VideoReviewInteractorModel(
            videoReview: input.model,
            productTitle: "products_from_video".localized()
        )
        let router = VideoReviewRouter(servicesProvider: input.servicesProvider)
        let presenter = VideoReviewPresenter(mapper: VideoReviewPresenterMapper())
        let provider = EnrichmentProvider()
        let dataManager = VideoReviewDataManager(
            provider: provider
        )
        let interactor = VideoReviewInteractor(
            router: router,
            presenter: presenter,
            model: model,
            dataManager: dataManager
        )
        let viewController = VideoReviewViewController(interactor: interactor)
        router.view = viewController
        presenter.view = viewController
        return viewController
    }
}
