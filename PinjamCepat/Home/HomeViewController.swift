//
//  HomeViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    
    lazy var tryBtn: UIButton = {
        let tryBtn = UIButton(type: .custom)
        tryBtn.setBackgroundImage(UIImage(named: "try_again_image"), for: .normal)
        return tryBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tryBtn)
        
        tryBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 219, height: 58))
        }
        
        tryBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.toLoginVc()
            })
            .disposed(by: disposeBag)
        
    }
    
}
