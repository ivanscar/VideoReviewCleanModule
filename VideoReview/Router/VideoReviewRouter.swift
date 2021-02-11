//
//  VideoReviewRouter.swift
//  Wildberries
//
//  Created by Ivan Sukhov on 04.02.2021.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoReviewRouter {
    weak var view: VideoReviewViewController?
    
    private let servicesProvider: ServicesProvider
    
    private var navigationController: UINavigationController? {
        view?.navigationController
    }
    
    init(servicesProvider: ServicesProvider) {
        self.servicesProvider = servicesProvider
    }
}

extension VideoReviewRouter: VideoReviewRouterInput {
    func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func openProduct(with nm: Int, brandName: String) {
        let path = NomenclatureUrlGenerator(nomenclature: nm).productCardUrl()
        let vc = ControllersFactory.getController(ofType: .productCard(title: brandName, path: path))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentVideoScreen(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let vc = ProductCardAVPlayerViewController()
        vc.player = AVPlayer(url: url)
        view?.present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    func showDefaultError() {
        view?.showAlertView(text: "something_wrong_two".localized(), type: .error)
    }
}
