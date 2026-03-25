//
//  EnView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit

class EnView: BaseView {
    
    var model: yieldedModel? {
        didSet {
            guard let model = model else { return }
            headView.model = model
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var headView: EndCardView = {
        let headView = EndCardView(frame: .zero)
        return headView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "en_ys_image".localized)
        oneImageView.contentMode = .center
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "en_bz_image".localized)
        twoImageView.contentMode = .center
        return twoImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        headView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
            if LanguageManager.shared.getCurrentLanguage() == .english {
                make.size.equalTo(CGSize(width: 375.pix(), height: 292.pix()))
            }else {
                make.size.equalTo(CGSize(width: 375.pix(), height: 270.pix()))
            }
        }
        
        contentView.addSubview(oneImageView)
        contentView.addSubview(twoImageView)
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(22)
            make.size.equalTo(CGSize(width: 335.pix(), height: 268.pix()))
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 335.pix(), height: 220.pix()))
            make.bottom.equalToSuperview().offset(-20.pix())
        }
    }
     
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
