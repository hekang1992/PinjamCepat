//
//  CenterView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Combine

class CenterView: UIView {
    
    var modelArray: [preachedModel]? {
        didSet {
            guard let modelArray = modelArray else { return }
            setupListView(with: modelArray)
        }
    }
    
    var listTapBlock: ((preachedModel) -> Void)?
    
    lazy var listContainerView: UIView = {
        let listContainerView = UIView()
        listContainerView.backgroundColor = .clear
        listContainerView.layer.cornerRadius = 20
        listContainerView.layer.masksToBounds = true
        listContainerView.layer.borderWidth = 1
        listContainerView.layer.borderColor = UIColor.init(hexString: "#DBEAFE")?.withAlphaComponent(0.5).cgColor
        return listContainerView
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    private var listItemViews: [UIView] = []
    
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
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "cin_logo_image")
        return logoImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .center
        phoneLabel.text = phoneNumberRegex(number: LoginManager.shared.getPhone() ?? "")
        phoneLabel.textColor = .black
        phoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return phoneLabel
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "cin_desc_image".localized)
        return descImageView
    }()
    
    lazy var policyBtn: UIButton = {
        let policyBtn = UIButton(type: .custom)
        policyBtn.adjustsImageWhenHighlighted = false
        policyBtn.setBackgroundImage(UIImage(named: "pol_in_foot_image".localized), for: .normal)
        return policyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(listContainerView)
        listContainerView.addSubview(descImageView)
        contentView.addSubview(policyBtn)
        
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(83)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
        
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(21)
            make.right.equalToSuperview().offset(-21)
        }
        
        descImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        policyBtn.snp.makeConstraints { make in
            make.top.equalTo(listContainerView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 338, height: 99))
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupListView(with models: [preachedModel]) {
        listItemViews.forEach { $0.removeFromSuperview() }
        listItemViews.removeAll()
        
        var previousView: UIView?
        
        for (index, model) in models.enumerated() {
            let itemView = createListItemView(with: model, index: index)
            listContainerView.addSubview(itemView)
            listItemViews.append(itemView)
            
            itemView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(12)
                make.height.equalTo(46)
                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(12)
                } else {
                    if index == 0 {
                        make.top.equalToSuperview().offset(51)
                    }else {
                        make.top.equalToSuperview().offset(12)
                    }
                }
                
                if index == models.count - 1 {
                    make.bottom.equalToSuperview().offset(-18)
                }
            }
            
            previousView = itemView
        }
        
        setupGradientBackground()
    }
    
    private func createListItemView(with model: preachedModel, index: Int) -> UIView {
        let itemView = CenterListView()
        itemView.model = model
        itemView.listTapBlock = { [weak self] in
            guard let self else { return }
            self.listTapBlock?(model)
        }
        return itemView
    }
    
    private func setupGradientBackground() {
        gradientLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = listContainerView.bounds
        gradient.colors = [
            UIColor.init(hexString: "#EFF6FF")!.cgColor,
            UIColor.init(hexString: "#F2F2F2")!.cgColor
        ]
        
        let angle: CGFloat = 135.0 * .pi / 180.0
        let startPoint = CGPoint(x: cos(angle), y: sin(angle))
        let endPoint = CGPoint(x: cos(angle + .pi), y: sin(angle + .pi))
        
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        listContainerView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = listContainerView.bounds
    }
}

extension CenterView {
    
    func phoneNumberRegex(number: String) -> String {
        var result = ""
        for (index, char) in number.enumerated() {
            if index < 2 || index >= number.count - 4 {
                result.append(char)
            } else {
                result.append("*")
            }
        }
        return result
    }
}
