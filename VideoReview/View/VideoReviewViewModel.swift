//
//  VideoReviewViewModel.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 05.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

struct VideoReviewViewModel {
    let isSingleProductReview: Bool
    var items: [Item]
    let contentInset: UIEdgeInsets
}

extension VideoReviewViewModel {

    enum Item {
        case videoPreview(VideoPreview)
        case description(Description)
        case goods(Goods)
    }
}

extension VideoReviewViewModel {

    struct VideoPreview {
        let playlist: String
        let thumb: String
    }
    
    struct Description {
        let title: String
        let description: String
        let videoInfo: String
        let brandName: String
    }
    
    struct Goods {
        let title: String
        let viewModels: [CarouselCollectionViewCell.ViewModel]
    }
}
