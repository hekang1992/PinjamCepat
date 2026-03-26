//
//  PopIDAuthView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopIDAuthView: BaseView {
    
    private lazy var grayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "time_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.text = "Information Confirmation".localized
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return descLabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle("Confirm".localized, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        nextBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        return nextBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    var onDateChanged: (() -> Void)?
    var cancelChanged: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(grayView)
        grayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(404.pix())
        }
        
        bgImageView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.pix())
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(25)
        }
        
        bgImageView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.pix())
            make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
        }
        
        bgImageView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.pix(), height: 40.pix()))
        }
        
        nextBtn
            .rx
            .tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.onDateChanged?()
            })
            .disposed(by: disposeBag)
        
        cancelBtn
            .rx
            .tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.cancelChanged?()
            })
            .disposed(by: disposeBag)
        
    }
    
}

