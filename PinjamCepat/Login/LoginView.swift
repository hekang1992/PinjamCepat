//
//  LoginView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginView: BaseView {
    
    var backBlock: (() -> Void)?
    
    var codeBlock: (() -> Void)?
    
    var loginBlock: (() -> Void)?
    
    var policyBlock: (() -> Void)?
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.adjustsImageWhenHighlighted = false
        backBtn.setBackgroundImage(UIImage(named: "app_back_image"), for: .normal)
        return backBtn
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "en_login_desc_image".localized)
        return descImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.text = "Phone number".localized
        oneLabel.textColor = UIColor.init(hexString: "#333333")
        oneLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return oneLabel
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "login_list_bg_image")
        oneImageView.isUserInteractionEnabled = true
        return oneImageView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .center
        numLabel.text = "+91".localized
        numLabel.textColor = .black
        numLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return numLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hexString: "#BDBDBD")
        return lineView
    }()
    
    lazy var phoneFiled: UITextField = {
        let phoneFiled = UITextField()
        phoneFiled.keyboardType = .numberPad
        phoneFiled.placeholder = "Enter phone number".localized
        phoneFiled.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        phoneFiled.textColor = .black
        return phoneFiled
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.text = "Verification code".localized
        twoLabel.textColor = UIColor.init(hexString: "#333333")
        twoLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return twoLabel
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "login_list_bg_image")
        twoImageView.isUserInteractionEnabled = true
        return twoImageView
    }()
    
    lazy var codeFiled: UITextField = {
        let codeFiled = UITextField()
        codeFiled.keyboardType = .numberPad
        codeFiled.placeholder = "Enter verification code".localized
        codeFiled.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        codeFiled.textColor = .black
        return codeFiled
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitle("Get code".localized, for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        codeBtn.setBackgroundImage(UIImage(named: "code_btn_image"), for: .normal)
        codeBtn.setBackgroundImage(UIImage(named: "code_disbtn_image"), for: .disabled)
        return codeBtn
    }()
    
    lazy var loginBtn: UIButton = {
        let loginBtn = UIButton(type: .custom)
        loginBtn.setBackgroundImage(UIImage(named: "en_login_btn_image".localized), for: .normal)
        return loginBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.isSelected = true
        sureBtn.adjustsImageWhenHighlighted = false
        sureBtn.setBackgroundImage(UIImage(named: "po_nor_image"), for: .normal)
        sureBtn.setBackgroundImage(UIImage(named: "po_sel_image"), for: .selected)
        return sureBtn
    }()
    
    lazy var policyBtn: UIButton = {
        let policyBtn = UIButton(type: .custom)
        policyBtn.adjustsImageWhenHighlighted = false
        policyBtn.setBackgroundImage(UIImage(named: "en_pol_image".localized), for: .normal)
        return policyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(descImageView)
        addSubview(oneLabel)
        addSubview(oneImageView)
        oneImageView.addSubview(numLabel)
        oneImageView.addSubview(lineView)
        oneImageView.addSubview(phoneFiled)
        
        addSubview(twoLabel)
        addSubview(twoImageView)
        twoImageView.addSubview(codeBtn)
        twoImageView.addSubview(codeFiled)
        
        addSubview(loginBtn)
        addSubview(sureBtn)
        addSubview(policyBtn)
        
        backBtn.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(14)
            make.left.equalToSuperview().offset(21)
            make.width.height.equalTo(24)
        }
        
        descImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(14)
            make.size.equalTo(CGSize(width: 334, height: 108))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(31)
            make.left.equalToSuperview().offset(33)
            make.height.equalTo(18)
        }
        
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneLabel.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 309, height: 46))
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 47, height: 40))
        }
        
        lineView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(28)
            make.left.equalTo(numLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        
        phoneFiled.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-5)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneImageView.snp.bottom).offset(22)
            make.left.equalToSuperview().offset(33)
            make.height.equalTo(18)
        }
        
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoLabel.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 309, height: 46))
        }
        
        codeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(CGSize(width: 87, height: 38))
            make.centerY.equalToSuperview()
        }
        
        codeFiled.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalTo(codeBtn.snp.left).offset(-10)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(twoImageView.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 293, height: 58))
        }
        
        sureBtn.snp.makeConstraints { make in
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.left.equalToSuperview().offset(65)
            }else {
                make.left.equalToSuperview().offset(59)
            }
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-25)
            make.width.height.equalTo(12)
        }
        
        policyBtn.snp.makeConstraints { make in
            make.left.equalTo(sureBtn.snp.right).offset(6)
            make.centerY.equalTo(sureBtn)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 213, height: 26))
            }else {
                make.size.equalTo(CGSize(width: 224, height: 13))
            }
        }
        
        backBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.backBlock?()
            })
            .disposed(by: disposeBag)
        
        sureBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.sureBtn.isSelected.toggle()
            })
            .disposed(by: disposeBag)
        
        policyBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.policyBlock?()
            })
            .disposed(by: disposeBag)
        
        codeBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.codeBlock?()
            })
            .disposed(by: disposeBag)
        
        loginBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.loginBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    
    
    
}
