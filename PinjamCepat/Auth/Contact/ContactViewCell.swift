//
//  ContactViewCell.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ContactViewCell: UITableViewCell {
    
    var oneBlock: ((String) -> Void)?
    
    var twoBlock: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    var model: nationsModel? {
        didSet {
            guard let model = model else { return }
            oneLabel.text = model.distinctly ?? ""
            oneFiled.placeholder = model.shaped ?? ""
            
            twoLabel.text = model.distorting ?? ""
            twoFiled.placeholder = model.magnifying ?? ""
            
            let destiny = model.destiny ?? ""
            let modelArray = model.write ?? []
            
            if let matchedModel = modelArray.first(where: { $0.led == destiny }) {
                oneFiled.text = matchedModel.jest ?? ""
            }
            
            if let name = model.jest, !name.isEmpty,
               let phone = model.afterthought, !phone.isEmpty {
                twoFiled.text = "\(name)-\(phone)"
            }

        }
    }
    
    private lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "kontak_image_01")
        return headImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = .black
        oneLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return oneLabel
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.layer.cornerRadius = 5
        oneView.layer.masksToBounds = true
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var oneFiled: UITextField = {
        let oneFiled = UITextField()
        oneFiled.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        oneFiled.textColor = .black
        oneFiled.leftView = UIView(frame: CGRectMake(0, 0, 11, 11))
        oneFiled.leftViewMode = .always
        return oneFiled
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "arrow_right_image")
        return oneImageView
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = .black
        twoLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return twoLabel
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.layer.cornerRadius = 5
        twoView.layer.masksToBounds = true
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var twoFiled: UITextField = {
        let twoFiled = UITextField()
        twoFiled.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        twoFiled.textColor = .black
        twoFiled.leftView = UIView(frame: CGRectMake(0, 0, 11, 11))
        twoFiled.leftViewMode = .always
        return twoFiled
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "arrow_right_image")
        return twoImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(headImageView)
        contentView.addSubview(oneLabel)
        contentView.addSubview(oneView)
        oneView.addSubview(oneImageView)
        oneView.addSubview(oneFiled)
        oneView.addSubview(oneBtn)
        
        contentView.addSubview(twoLabel)
        contentView.addSubview(twoView)
        twoView.addSubview(twoImageView)
        twoView.addSubview(twoFiled)
        twoView.addSubview(twoBtn)
        
        headImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 248.pix(), height: 18.pix()))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(18)
        }
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(8)
            make.left.equalTo(oneLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(44.pix())
        }
        
        oneImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        oneFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(oneImageView.snp.left).offset(-5)
        }
        
        oneBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(18)
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(twoLabel.snp.bottom).offset(8)
            make.left.equalTo(oneLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(44.pix())
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
        twoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        twoFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(oneImageView.snp.left).offset(-5)
        }
        
        twoBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneBtn
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.oneBlock?(self.oneFiled.text ?? "")
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.twoBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactViewCell {
    
    func configeImageView(nameStr: String) {
        self.headImageView.image = UIImage(named: nameStr)
    }
    
}
