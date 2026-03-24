//
//  LoadingManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit

final class LoadingManager {
    
    static let shared = LoadingManager()
    private init() {}
    
    private var containerView: UIView?
    
    func show() {
        DispatchQueue.main.async {
            guard self.containerView == nil else { return }
            guard let window = Self.getKeyWindow() else { return }
            
            let grayView = UIView()
            grayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
            let container = UIView()
            container.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            container.layer.cornerRadius = 12
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .white
            indicator.startAnimating()
            
            window.addSubview(grayView)
            grayView.addSubview(container)
            container.addSubview(indicator)
            
            grayView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            container.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 100, height: 100))
            }
            
            indicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            
            self.containerView = grayView
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }
}

extension LoadingManager {
    private static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
