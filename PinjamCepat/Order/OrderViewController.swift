//
//  OrderViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit

class OrderViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timeSelectView = TimeSelectView()
        
        let KeyWindow = getKeyWindow()
        
        KeyWindow?.addSubview(timeSelectView)
        timeSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timeSelectView.setDate(with: "20-08-1985")
        
        timeSelectView.cancelChanged = {
            timeSelectView.removeFromSuperview()
        }
        
        timeSelectView.onDateChanged = { dateString in
            print("日期已改变: \(dateString)")
            timeSelectView.removeFromSuperview()
        }
    }
    
    private  func getKeyWindow() -> UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
}
