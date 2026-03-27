//
//  OrderListView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SnapKit

class OrderListView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        return bgView
    }()

    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#595959")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .right
        return twoLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(oneLabel)
        bgView.addSubview(twoLabel)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
        }
        twoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
