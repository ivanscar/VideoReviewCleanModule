//
//  VideoReviewInteractorModel.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 10.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

struct VideoReviewInteractorModel {
    var isSingleProductReview: Bool {
        products.count == 1
    }
    let videoReview: VideoReviewData
    let productTitle: String
    var products: [EnrichedProduct] = []
}
