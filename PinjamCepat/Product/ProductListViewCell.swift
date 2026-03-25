//
//  ProductListViewCell.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit

class ProductListViewCell: UITableViewCell {
    
    var model: recordModel? {
        didSet {
            guard let model else { return }
            let against = model.against ?? 0
            
            numLabel.textColor = against == 1 ? .white : UIColor.init(hexString: "#949494")
            
            numLabel.backgroundColor = against == 1 ? UIColor.init(hexString: "#3AA9FD") : UIColor.init(hexString: "#E1E1E1")
            
            typeImageView.image = against == 1 ? UIImage(named: "tc_sel_image") : UIImage(named: "tc_nor_image")
            
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .center
        numLabel.layer.cornerRadius = 8
        numLabel.layer.masksToBounds = true
        numLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return numLabel
    }()
    
    private lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hexString: "#161616")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return oneLabel
    }()
    
    lazy var typeImageView: UIImageView = {
        let typeImageView = UIImageView()
        return typeImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgView)
        bgView.addSubview(numLabel)
        bgView.addSubview(oneLabel)
        bgView.addSubview(typeImageView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(69)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(37)
            make.left.equalToSuperview().offset(10)
        }
        
        typeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.right.equalToSuperview().offset(-14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductListViewCell {
    
    func configNumInfo(with num: String) {
        self.numLabel.text = num
    }
    
}
