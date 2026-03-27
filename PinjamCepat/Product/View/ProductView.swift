//
//  ProductView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ProductView: BaseView {
    
    var nextBlock: ((recordModel, linesModel) -> Void)?
        
    var model: glovesModel? {
        didSet {
            guard let model else { return }
            nextBtn.setTitle(model.lines?.sabbath ?? "", for: .normal)
        }
    }
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nextBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        return nextBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ProductListViewCell.self, forCellReuseIdentifier: "ProductListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nextBtn)
        addSubview(tableView)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10.pix())
        }
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5.pix())
        }
        
        nextBtn
            .rx
            .tap
            .throttle(.microseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self, let model else { return }
                if let cardModel = model.lines {
                    self.nextBlock?(model.record ?? recordModel(),
                                    cardModel)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProductView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.pix()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "pd_o_head_image")
        headView.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 142.pix()))
        }
        
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "cc_en_image".localized)
        headView.addSubview(descImageView)
        descImageView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(20.pix())
            make.centerX.equalToSuperview()
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 230.pix(), height: 18.pix()))
            }else {
                make.size.equalTo(CGSize(width: 258.pix(), height: 18.pix()))
            }
        }
        
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor(hexString: "#7E7E7E")
        oneLabel.font = .systemFont(ofSize: 12, weight: .medium)
        
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = UIColor(hexString: "#262626")
        twoLabel.font = .systemFont(ofSize: 48, weight: .bold)
        
        headImageView.addSubview(logoImageView)
        headImageView.addSubview(nameLabel)
        headImageView.addSubview(oneLabel)
        headImageView.addSubview(twoLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.pix())
            make.left.equalToSuperview().offset(19)
            make.width.height.equalTo(28)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.left.equalTo(logoImageView.snp.right).offset(5)
            make.height.equalTo(20)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(55.pix())
            make.left.equalToSuperview().offset(19)
            make.height.equalTo(15)
        }
        
        twoLabel.snp.makeConstraints { make in
            make.top.equalTo(oneLabel.snp.bottom)
            make.left.equalTo(oneLabel)
            make.height.equalTo(59)
        }
        
        logoImageView.kf.setImage(with: URL(string: model?.lines?.trouble ?? ""))
        nameLabel.text = model?.lines?.brain ?? ""
        oneLabel.text = model?.lines?.disease ?? ""
        twoLabel.text = model?.lines?.solely ?? ""
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.contemplative?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListViewCell", for: indexPath) as! ProductListViewCell
        cell.model = self.model?.contemplative?[indexPath.row]
        let index = indexPath.row + 1
        cell.configNumInfo(with: String(format: "0%d", index))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = self.model?.contemplative?[indexPath.row]
        let stepModel = self.model?.record
        
        let isAuth = cellModel?.against ?? 0
        
        if isAuth == 1 {
            if let cellModel = cellModel, let cardModel = self.model?.lines {
                self.nextBlock?(cellModel, cardModel)
            }
        }else {
            if let stepModel = stepModel, let cardModel = self.model?.lines {
                self.nextBlock?(stepModel, cardModel)
            }
        }
    }
    
}
