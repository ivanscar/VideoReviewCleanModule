//
//  VideoReviewPresenterMapper.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 05.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

private enum Constants {
    static let collectionViewSingleContentInset = UIEdgeInsets( top: 0, left: 0, bottom: 52, right: 0)
    static let collectionViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
}

final class VideoReviewPresenterMapper {
    
    typealias PresenterModel = VideoReviewInteractorModel
    typealias ViewModel = VideoReviewViewModel
    typealias Item = ViewModel.Item

    func assembleViewModel(_ model: PresenterModel) -> ViewModel {
        return ViewModel(
            isSingleProductReview: model.isSingleProductReview,
            items: [
                videoPreview(model),
                descriptionView(model),
                goodsPreview(model)
            ],
            contentInset: model.isSingleProductReview
                ? Constants.collectionViewSingleContentInset
                : Constants.collectionViewContentInset
        )
    }
}

extension VideoReviewPresenterMapper {
    
    private func videoPreview(_ model: PresenterModel) -> Item {
        return .videoPreview(VideoReviewViewModel.VideoPreview(
            playlist: model.videoReview.videoUrl,
            thumb: model.videoReview.image
        ))
    }
    
    private func descriptionView(_ model: PresenterModel) -> Item {
        return .description(VideoReviewViewModel.Description(
            title: model.videoReview.title,
            description: model.videoReview.description ?? .emptyString,
            videoInfo: model.videoReview.viewCount + .bulletWithSpaces + model.videoReview.dateText,
            brandName: model.videoReview.brandName ?? .emptyString
        ))
    }
    
    private func goodsPreview(_ model: PresenterModel) -> Item {
        return .goods(VideoReviewViewModel.Goods(
            title: model.productTitle,
            viewModels: model.products.map {
                CarouselCollectionViewCell.ViewModel(
                    imgUrl: NomenclatureUrlGenerator(nomenclature: $0.cod1S).imageUrl,
                    title: $0.brandName,
                    subtitle: $0.name,
                    description: $0.salePriceString,
                    needBlur: $0.isAdult
                )
            }
        ))
    }
}
