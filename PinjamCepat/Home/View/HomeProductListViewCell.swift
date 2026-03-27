//
//  HomeProductListViewCell.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class HomeProductListViewCell: UITableViewCell {
    
    var tapProductBlock: ((String) -> Void)?
    
    private var disposeBag = DisposeBag()

    var model: yieldedModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.trouble ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            
            nameLabel.text = model.brain ?? ""
            appLabel.text = model.sabbath ?? ""
            
            oneLabel.text = model.poorly ?? ""
            twoLabel.text = model.beseech ?? ""
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#FFFFFF")
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.init(hexString: "#4EB1FE")?.cgColor
        return bgView
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
        nameLabel.textColor = UIColor.init(hexString: "#3A3A3A")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return nameLabel
    }()
    
    lazy var appImageView: UIImageView = {
        let appImageView = UIImageView()
        appImageView.image = UIImage(named: "apply_bg_image")
        return appImageView
    }()
    
    lazy var appLabel: UILabel = {
        let appLabel = UILabel()
        appLabel.textAlignment = .center
        appLabel.textColor = .white
        appLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return appLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#676767")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = .black
        twoLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return twoLabel
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(appImageView)
        appImageView.addSubview(appLabel)
        bgView.addSubview(oneLabel)
        bgView.addSubview(twoLabel)
        contentView.addSubview(tapBtn)
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 336.pix(), height: 81.pix()))
            make.bottom.equalToSuperview().offset(-12.pix())
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20.pix())
            make.top.equalToSuperview().offset(9.pix())
            make.left.equalToSuperview().offset(11)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(16)
        }
        
        appImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-13)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 129.pix(), height: 36.pix()))
        }
        
        appLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalToSuperview().offset(35.pix())
            make.height.equalTo(12)
        }
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView)
            make.top.equalTo(oneLabel.snp.bottom).offset(2.pix())
            make.height.equalTo(24)
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
