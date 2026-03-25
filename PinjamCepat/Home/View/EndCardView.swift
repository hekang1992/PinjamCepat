//
//  EndCardView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import Kingfisher

class EndCardView: BaseView {
    
    var model: yieldedModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.trouble ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.brain ?? ""
            oneLabel.text = model.poorly ?? ""
            twoLabel.text = model.beseech ?? ""
            lBtn.setTitle("  " + (model.skill ?? ""), for: .normal)
            rBtn.setTitle("  " + (model.verily ?? ""), for: .normal)
            applyBtn.setTitle(model.sabbath ?? "", for: .normal)
        }
    }
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "enh_head_image".localized)
        return headImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#7E7E7E")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = UIColor.init(hexString: "#262626")
        twoLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return twoLabel
    }()
    
    lazy var lBtn: UIButton = {
        let lBtn = UIButton(type: .custom)
        lBtn.isEnabled = false
        lBtn.setTitleColor(UIColor.init(hexString: "#494949"), for: .normal)
        lBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        lBtn.setImage(UIImage(named: "lf_icon_image"), for: .normal)
        return lBtn
    }()
    
    lazy var rBtn: UIButton = {
        let rBtn = UIButton(type: .custom)
        rBtn.isEnabled = false
        rBtn.setTitleColor(UIColor.init(hexString: "#494949"), for: .normal)
        rBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        rBtn.setImage(UIImage(named: "rf_icon_image"), for: .normal)
        return rBtn
    }()
    
    lazy var policyBtn: UIButton = {
        let policyBtn = UIButton(type: .custom)
        policyBtn.adjustsImageWhenHighlighted = false
        policyBtn.setBackgroundImage(UIImage(named: "hc_loan_image"), for: .normal)
        return policyBtn
    }()
    
    lazy var applyBtn: UIButton = {
        let applyBtn = UIButton(type: .custom)
        applyBtn.setTitleColor(.white, for: .normal)
        applyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        applyBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        return applyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headImageView)
        headImageView.addSubview(logoImageView)
        headImageView.addSubview(nameLabel)
        headImageView.addSubview(oneLabel)
        headImageView.addSubview(twoLabel)
        headImageView.addSubview(lBtn)
        headImageView.addSubview(rBtn)
        
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20.pix())
            make.size.equalTo(CGSize(width: 355.pix(), height: 192.pix()))
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.pix())
            make.left.equalToSuperview().offset(19.pix())
            make.width.height.equalTo(28.pix())
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55.pix())
            make.left.equalToSuperview().offset(19.pix())
            make.height.equalTo(15)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom)
            make.left.equalToSuperview().offset(19.pix())
            make.height.equalTo(59)
        }
        
        lBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19.pix())
            make.height.equalTo(22)
            make.top.equalTo(twoLabel.snp.bottom).offset(10)
        }
        
        rBtn.snp.makeConstraints { make in
            make.left.equalTo(lBtn.snp.right).offset(23)
            make.height.equalTo(22)
            make.top.equalTo(twoLabel.snp.bottom).offset(10)
        }
        
        if LanguageManager.shared.getCurrentLanguage() == .english {
            addSubview(policyBtn)
            addSubview(applyBtn)
            
            policyBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(headImageView.snp.bottom).offset(13.pix())
                make.size.equalTo(CGSize(width: 278.pix(), height: 16.pix()))
            }
            
            applyBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(policyBtn.snp.bottom).offset(11.pix())
                make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            }
            
        }else {
            addSubview(applyBtn)
            
            applyBtn.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(headImageView.snp.bottom).offset(20.pix())
                make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            }
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
