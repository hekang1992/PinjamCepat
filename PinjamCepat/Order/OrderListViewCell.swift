//
//  OrderListViewCell.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import SnapKit
import Kingfisher

class OrderListViewCell: UITableViewCell {
    
    var model: preachedModel? {
        didSet {
            guard let model = model else { return }
            oneLabel.text = model.sabbath ?? ""
            nameLabel.text = model.brain ?? ""
            
            let logoUrl = model.trouble ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            
            let listArray = model.erudite ?? []
            setupListView(with: listArray)
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "ocdo_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()

    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = .white
        oneLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return oneLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .right
        nameLabel.textColor = UIColor.init(hexString: "#0C1E2F")
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return nameLabel
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        return logoImageView
    }()
    
    lazy var conView: UIView = {
        let conView = UIView()
        return conView
    }()
    
    private var listViews: [OrderListView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(oneLabel)
        
        bgImageView.addSubview(nameLabel)
        bgImageView.addSubview(logoImageView)
        
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 109.pix()))
            make.bottom.equalToSuperview().offset(-14.pix())
        }
        oneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(10.pix())
            make.height.equalTo(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneLabel)
            make.right.equalToSuperview().offset(-17)
            make.height.equalTo(20)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.right.equalTo(nameLabel.snp.left).offset(-5)
            make.width.height.equalTo(17.pix())
        }
        
        bgImageView.addSubview(conView)
        conView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36.pix())
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupListView(with items: [eruditeModel]) {
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        
        for (index, item) in items.enumerated() {
            let listView = OrderListView()
            listView.oneLabel.text = item.vowed ?? ""
            listView.twoLabel.text = item.pestilence ?? ""
            if index == 0 {
                listView.twoLabel.textColor = UIColor.init(hexString: "#54B5FE")
                listView.twoLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            }else {
                listView.twoLabel.textColor = .black
                listView.twoLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            }
            conView.addSubview(listView)
            
            listView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(22)
                if index == 0 {
                    make.top.equalToSuperview().offset(2)
                } else {
                    make.top.equalTo(listViews[index - 1].snp.bottom).offset(1)
                }
            }
            
            listViews.append(listView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
