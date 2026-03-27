//
//  OrderListEmptyView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderListEmptyView: BaseView {
    
    // MARK: - Properties
    var tapBlock: (() -> Void)?
    
    // MARK: - UI Components
    private lazy var emptyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(UIImage(named: "em_oc_image".localized), for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindEvents()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(emptyButton)
        
        emptyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.size.equalTo(buttonSize)
        }
    }
    
    private var buttonSize: CGSize {
        let isIndonesian = LanguageManager.shared.getCurrentLanguage() == .indonesian
        let width = isIndonesian ? 261 : 209
        return CGSize(width: width.pix(), height: 224.pix())
    }
    
    private func bindEvents() {
        emptyButton
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.tapBlock?()
            })
            .disposed(by: disposeBag)
    }
}
