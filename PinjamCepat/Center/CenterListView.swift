//
//  CenterListView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import Kingfisher
import SnapKit

class CenterListView: BaseView {
    
    var model: preachedModel? {
        didSet {
            guard let model else { return }
            let logoUrl = model.bearded ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            oneLabel.text = model.vowed ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.05
        bgView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bgView.layer.shadowRadius = 4
        bgView.layer.masksToBounds = false
        return bgView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#1A1A1A")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return oneLabel
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow_right_image")
        arrowImageView.contentMode = .scaleAspectFit
        return arrowImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(oneLabel)
        bgView.addSubview(arrowImageView)
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            make.width.height.equalTo(20)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
