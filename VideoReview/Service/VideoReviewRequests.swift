//
//  VideoReviewRequests.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 03.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

extension ApiRequestFactory {
    enum VideoReview {
        typealias ResultBlock = ([VideoReviewDto]?) -> Void
        
        static func hostUrl() -> String {
            AppDelegate.shared.appConfigData.videoReviewsUrl ?? "http://video-reviews.products-short.svc.k8s.stage/api/v1/"
        }
        
        static func loadReviewsRequest(resultBlock: @escaping ResultBlock) -> ApiRequest {
            let path = hostUrl() + "video"
            var request = defaultRequestWithPath(path)
            let errorHandler = ErrorHandlerFactory.handlerWithNilBlock(resultBlock)
            request.errorHandler = errorHandler
            request.resultHandler = DataHandlerFactory.handlerMakeObjects(resultBlock: resultBlock, failureHandler: errorHandler)
            return request
        }
        
        static func loadReviewRequest(with nm: Int, brandId: Int, resultBlock: @escaping ResultBlock) -> ApiRequest {
            let path = hostUrl() + "video-by-nm?nm=\(nm)&brand=\(brandId)"
            var request = defaultRequestWithPath(path)
            let errorHandler = ErrorHandlerFactory.handlerWithNilBlock(resultBlock)
            request.errorHandler = errorHandler
            request.resultHandler = DataHandlerFactory.handlerMakeObjects(resultBlock: resultBlock, failureHandler: errorHandler)
            return request
        }
        
        static func searchReviewsRequest(
            with query: String,
            resultBlock: @escaping ([VideoReviewDto]) -> Void
        ) -> ApiRequest {
            let path = hostUrl() + "video?q=\(query)"
            var request = defaultRequestWithPath(path)
            let errorHandler = ErrorHandlerFactory.handlerWithBlock { _ in
                resultBlock([])
            }
            request.errorHandler = errorHandler
            request.resultHandler = DataHandlerFactory.handlerMakeObjects(resultBlock: resultBlock, failureHandler: errorHandler)
            return request
        }
    }
}
