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

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
}

extension BaseViewController {
    
    func switchRootVc() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?
            .windows
            .first(where: { $0.isKeyWindow }) else { return }
        
        let tabBarController = BaseTabBarController()
        
        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve) {
            window.rootViewController = tabBarController
        }
    }
    
    func toLoginVc() {
        let loginVc = BaseNavigationController(rootViewController: LoginViewController())
        loginVc.modalPresentationStyle = .overFullScreen
        self.present(loginVc, animated: true)
    }
    
}
