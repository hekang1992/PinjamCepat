//
//  EndCardView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class EndCardView: BaseView {
    
    var tapProductBlock: ((String) -> Void)?
    
    var policyBlock: (() -> Void)?
    
    // MARK: - Model
    var model: yieldedModel? {
        didSet { updateUI() }
    }
    
    // MARK: - UI Components
    private lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "enh_head_image".localized)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var oneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hexString: "#7E7E7E")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var twoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hexString: "#262626")
        label.font = .systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        return createButton(imageName: "lf_icon_image")
    }()
    
    private lazy var rightButton: UIButton = {
        return createButton(imageName: "rf_icon_image")
    }()
    
    private lazy var policyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.isHidden = true
        button.setBackgroundImage(UIImage(named: "hc_loan_image"), for: .normal)
        return button
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        return button
    }()
    
    private lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        
        tapBtn
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self, let model else { return }
                let productId = String(model.whimseys ?? 0)
                self.tapProductBlock?(productId)
            })
            .disposed(by: disposeBag)
        
        applyButton
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self, let model else { return }
                let productId = String(model.whimseys ?? 0)
                self.tapProductBlock?(productId)
            })
            .disposed(by: disposeBag)
        
        policyButton
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self else { return }
                self.policyBlock?()
            })
            .disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension EndCardView {
    
    func createButton(imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.isEnabled = false
        button.setTitleColor(UIColor(hexString: "#494949"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
    
    func setupUI() {
        addSubview(headImageView)
        headImageView.addSubview(logoImageView)
        headImageView.addSubview(nameLabel)
        headImageView.addSubview(oneLabel)
        headImageView.addSubview(twoLabel)
        headImageView.addSubview(leftButton)
        headImageView.addSubview(rightButton)
        headImageView.addSubview(tapBtn)
        
        let isEnglish = LanguageManager.shared.getCurrentLanguage() == .english
        
        if isEnglish {
            addSubview(policyButton)
            addSubview(applyButton)
        } else {
            addSubview(applyButton)
        }
    }
    
    func setupConstraints() {
        setupHeadImageViewConstraints()
        setupLogoImageViewConstraints()
        setupNameLabelConstraints()
        setupOneLabelConstraints()
        setupTwoLabelConstraints()
        setupButtonsConstraints()
        setupBottomButtonsConstraints()
    }
    
    func setupHeadImageViewConstraints() {
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20.pix())
            make.size.equalTo(CGSize(width: 355.pix(), height: 192.pix()))
        }
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupLogoImageViewConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.pix())
            make.left.equalToSuperview().offset(19.pix())
            make.width.height.equalTo(28.pix())
        }
    }
    
    func setupNameLabelConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
    }
    
    func setupOneLabelConstraints() {
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55.pix())
            make.left.equalToSuperview().offset(19.pix())
            make.height.equalTo(15)
        }
    }
    
    func setupTwoLabelConstraints() {
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom)
            make.left.equalToSuperview().offset(19.pix())
            make.height.equalTo(59)
        }
    }
    
    func setupButtonsConstraints() {
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19.pix())
            make.height.equalTo(22)
            make.top.equalTo(twoLabel.snp.bottom).offset(10)
        }
        
        rightButton.snp.makeConstraints { make in
            make.left.equalTo(leftButton.snp.right).offset(23)
            make.height.equalTo(22)
            make.top.equalTo(twoLabel.snp.bottom).offset(10)
        }
    }
    
    func setupBottomButtonsConstraints() {
        let isEnglish = LanguageManager.shared.getCurrentLanguage() == .english
        let topOffset = isEnglish ? 13.pix() : 20.pix()
        
        if isEnglish {
            policyButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(headImageView.snp.bottom).offset(topOffset)
                make.size.equalTo(CGSize(width: 278.pix(), height: 16.pix()))
            }
            
            applyButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(policyButton.snp.bottom).offset(11.pix())
                make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            }
        } else {
            applyButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(headImageView.snp.bottom).offset(topOffset)
                make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            }
        }
    }
    
    func updateUI() {
        guard let model = model else { return }
        
        logoImageView.kf.setImage(with: URL(string: model.trouble ?? ""))
        nameLabel.text = model.brain
        oneLabel.text = model.poorly
        twoLabel.text = model.beseech
        leftButton.setTitle("  " + (model.skill ?? ""), for: .normal)
        rightButton.setTitle("  " + (model.verily ?? ""), for: .normal)
        applyButton.setTitle(model.sabbath, for: .normal)
        
        let loanUrl = UserDefaults.standard.string(forKey: "loan_url") ?? ""
        if loanUrl.isEmpty {
            policyButton.isHidden = true
        }else {
            policyButton.isHidden = false
        }
        
    }
}
