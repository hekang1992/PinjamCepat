//
//  HomeCardViewCell.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HomeCardViewCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    var tapProductBlock: ((String) -> Void)?
    
    var model: yieldedModel? {
        didSet {
            guard let model = model else { return }
            cardView.model = model
        }
    }
    
    lazy var cardView: EndCardView = {
        let cardView = EndCardView(frame: .zero)
        return cardView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "toc_de_image")
        return descImageView
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(cardView)
        contentView.addSubview(descImageView)
        contentView.addSubview(tapBtn)
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(375.pix())
            make.height.equalTo(270.pix())
        }
        descImageView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 175.pix(), height: 18.pix()))
            make.bottom.equalToSuperview().offset(-15.pix())
        }
        
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tapBtn
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self, let productID = self.model?.whimseys else { return }
                self.tapProductBlock?(String(productID))
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
