//
//  SureListViewCell.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum CellType: String {
    case text = "1"
    case click = "2"
}

class SureListViewCell: UITableViewCell {
    
    var model: peculiarModel? {
        didSet {
            guard let model = model else { return }
            oneLabel.text = model.guardianship ?? ""
            nameFiled.placeholder = model.guardianship ?? ""
            nameFiled.text = model.commonwealth ?? ""
        }
    }
    
    var tapBlock: ((String) -> Void)?
    
    var textChangeBlock: ((String) -> Void)?
    
    private let cellType: CellType
    
    private let disposeBag = DisposeBag()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = .black
        oneLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return oneLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 5
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColor.init(hexString: "#F8F8F8")
        return bgView
    }()
    
    lazy var nameFiled: UITextField = {
        let nameFiled = UITextField()
        nameFiled.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        nameFiled.textColor = .black
        nameFiled.leftView = UIView(frame: CGRectMake(0, 0, 11, 11))
        nameFiled.leftViewMode = .always
        return nameFiled
    }()
    
    lazy var tapBtn: UIButton = {
        let tapBtn = UIButton(type: .custom)
        return tapBtn
    }()
    
    lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow_right_image")
        return arrowImageView
    }()
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, type: CellType) {
        self.cellType = type
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBagDispose?()
    }
    
    private var disposeBagDispose: (() -> Void)?
}

extension SureListViewCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(oneLabel)
        contentView.addSubview(bgView)
        
        switch cellType {
        case .text:
            bgView.addSubview(nameFiled)
            setupTextLayout()
            nameFiled.isEnabled = true
            
        case .click:
            bgView.addSubview(arrowImageView)
            bgView.addSubview(nameFiled)
            bgView.addSubview(tapBtn)
            setupClickLayout()
            nameFiled.isEnabled = false
        }
        
        oneLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.equalTo(18)
        }
        bgView.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom).offset(8)
            make.left.equalTo(oneLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(44.pix())
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupTextLayout() {
        nameFiled.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupClickLayout() {
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        nameFiled.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(arrowImageView.snp.left).offset(-5)
        }
        tapBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupRx() {
        switch cellType {
        case .text:
            nameFiled
                .rx
                .text
                .orEmpty
                .subscribe(onNext: { [weak self] text in
                    self?.textChangeBlock?(text)
                })
                .disposed(by: disposeBag)
            
            
        case .click:
            tapBtn
                .rx
                .tap
                .bind(onNext: { [weak self] in
                    self?.tapBlock?(self?.nameFiled.text ?? "")
                })
                .disposed(by: disposeBag)
        }
    }
}
