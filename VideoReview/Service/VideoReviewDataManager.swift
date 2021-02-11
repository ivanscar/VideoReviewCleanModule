//
//  VideoReviewDataManager.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 10.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

protocol VideoReviewDataManagerInput: AnyObject {
    func fetchEnrichedProducts(with nmIds: [String], callback: @escaping ([EnrichedProduct]?) -> Void)
}

final class VideoReviewDataManager {

    // MARK: - Properties
    private let provider: EnrichmentProvider

    // MARK: - Initialization
    init(provider: EnrichmentProvider) {
        self.provider = provider
    }
}

// MARK: - VideoReviewDataManagerInput
extension VideoReviewDataManager: VideoReviewDataManagerInput {
    
    func fetchEnrichedProducts(with nmIds: [String], callback: @escaping ([EnrichedProduct]?) -> Void) {
        let params = EnrichmentParams(productIds: nmIds)
        provider.enrichment(params: params, clientInfo: nil) { (info, _) in
            guard
                let info = info,
                let products: [EnrichedProduct] = info[objects: "products"]
            else {
                callback(nil)
                return
            }
            callback(products)
        }
    }
}
