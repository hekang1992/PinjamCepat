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
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 316.pix()))
        }
        
        timeSelectView.setDate(with: "20-08-1985")
        
        timeSelectView.onDateChanged = { dateString in
            print("日期已改变: \(dateString)")
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
