//
//  BaseViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import RxSwift
import RxCocoa
import Combine
import SnapKit

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var cancellables = Set<AnyCancellable>()
    
    private var productViewModel = ProductViewModel()
    
    lazy var headView: AppHeadView = {
        let headView = AppHeadView(frame: .zero)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "home_bg_image")
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productViewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                let portent = model.portent ?? ""
                if portent == "0" {
                    let cardModel = model.gloves?.lines ?? linesModel()
                    let stepModel = model.gloves?.record ?? recordModel()
                    self?.goAuthPageVc(stepModel: stepModel, cardModel: cardModel)
                }
            }
            .store(in: &cancellables)
        
    }
    
}

extension BaseViewController {
    
    func switchRootVc() {
        NotificationCenter.default.post(name: NSNotification.Name("switch_RootVc"), object: nil)
    }
    
    func toLoginVc() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
    
    func goH5WebVc(pageUrl: String) {
        if pageUrl.hasPrefix("ios://Pinj.amCe.pat") {
            AppRouter.open(pageUrl, from: self)
        }else {
            let webVc = H5WebViewController()
            webVc.pageUrl = pageUrl
            self.navigationController?.pushViewController(webVc, animated: true)
        }
    }
    
    func toProductVc() {
        guard let nav = navigationController else {
            navigationController?.popToRootViewController(animated: true)
            return
        }
        
        if let productVC = nav.viewControllers.compactMap({ $0 as? ProductViewController }).first {
            nav.popToViewController(productVC, animated: true)
        } else {
            nav.popToRootViewController(animated: true)
        }
    }
    
}

extension BaseViewController {
    
    func toProductDetailInfo(cardModel: linesModel) {
        let parameters = ["despondency": cardModel.whimseys ?? ""]
        productViewModel.getProductDetailInfo(parameters: parameters)
    }
    
    func goAuthPageVc(stepModel: recordModel, cardModel: linesModel) {
        let type = stepModel.mental ?? ""
        
        switch type {
        case "noa":
            break
            
        case "nob":
            let listVc = PersonalViewController()
            listVc.stepModel = stepModel
            listVc.cardModel = cardModel
            self.navigationController?.pushViewController(listVc, animated: true)
            
        case "noc":
            break
            
        case "nod":
            break
            
        case "noe":
            break
            
        default:
            break
        }
        
    }
}
