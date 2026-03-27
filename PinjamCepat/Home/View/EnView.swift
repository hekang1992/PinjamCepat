//
//  EnView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MJRefresh

class EnView: BaseView {
    
    var tapProductBlock: ((String) -> Void)?
    
    var policyBlock: (() -> Void)?
    
    // MARK: - Model
    var model: yieldedModel? {
        didSet { updateUI() }
    }
    
    // MARK: - UI Components
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var headView: EndCardView = {
        let headView = EndCardView(frame: .zero)
        return headView
    }()
    
    private lazy var oneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "en_ys_image".localized)
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(oneImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    private lazy var twoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "en_bz_image".localized)
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(twoImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
private extension EnView {
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headView)
        contentView.addSubview(oneImageView)
        contentView.addSubview(twoImageView)
    }
    
    func setupConstraints() {
        setupScrollViewConstraints()
        setupContentViewConstraints()
        setupHeadViewConstraints()
        setupOneImageViewConstraints()
        setupTwoImageViewConstraints()
    }
    
    func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func setupContentViewConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    func setupHeadViewConstraints() {
        let isEnglish = LanguageManager.shared.getCurrentLanguage() == .english
        let height: CGFloat = isEnglish ? 292.pix() : 270.pix()
        
        headView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: height))
        }
        
        headView.tapProductBlock = { [weak self] productId in
            self?.tapProductBlock?(productId)
        }
        
        headView.policyBlock = { [weak self] in
            self?.policyBlock?()
        }
    }
    
    func setupOneImageViewConstraints() {
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(22)
            make.size.equalTo(CGSize(width: 335.pix(), height: 268.pix()))
        }
    }
    
    func setupTwoImageViewConstraints() {
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 335.pix(), height: 220.pix()))
            make.bottom.equalToSuperview().offset(-20.pix())
        }
    }
    
    func updateUI() {
        guard let model = model else { return }
        headView.model = model
    }
    
}

extension EnView {
    
    func endRefresh() {
        self.scrollView.mj_header?.endRefreshing()
    }
    
    @objc private func oneImageViewTapped() {
        let productId = String(model?.whimseys ?? 0)
        self.tapProductBlock?(productId)
    }

    @objc private func twoImageViewTapped() {
        let productId = String(model?.whimseys ?? 0)
        self.tapProductBlock?(productId)
    }
    
}
