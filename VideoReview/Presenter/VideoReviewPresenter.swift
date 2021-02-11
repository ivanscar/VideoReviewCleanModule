//
//  VideoReviewPresenter.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 04.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

final class VideoReviewPresenter {
    weak var view: VideoReviewViewControllerInput?
    private let mapper: VideoReviewPresenterMapper
    
    init(mapper: VideoReviewPresenterMapper) {
        self.mapper = mapper
    }
}

extension VideoReviewPresenter: VideoReviewPresenterInput {
    func upate(model: VideoReviewInteractorModel) {
        view?.set(model: mapper.assembleViewModel(model))
        view?.reload()
    }
}
