//
//  PopIDAuthView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopIDAuthView: BaseView {
    
    var modelArray: [peculiarModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "time_bg_image")
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.text = "Information Confirmation".localized
        descLabel.textColor = .white
        descLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return descLabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle("Confirm".localized, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        nextBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        return nextBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    var onDateChanged: (() -> Void)?
    var cancelChanged: (() -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(SureListViewCell.self, forCellReuseIdentifier: "SureListViewCell")
        tableView.isScrollEnabled = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(404.pix())
        }
        
        bgImageView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.pix())
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(25)
        }
        
        bgImageView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.pix())
            make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
        }
        
        bgImageView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 50.pix(), height: 40.pix()))
        }
        
        bgImageView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30.pix())
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(nextBtn.snp.top).offset(-5.pix())
        }
        
        nextBtn
            .rx
            .tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.onDateChanged?()
            })
            .disposed(by: disposeBag)
        
        cancelBtn
            .rx
            .tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.cancelChanged?()
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension PopIDAuthView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.modelArray?[indexPath.row]
        
        let cellType: CellType
        
        if indexPath.row == 0 || indexPath.row == 1 {
            cellType = .text
        }else {
            cellType = .click
        }
        
        let cell = SureListViewCell(style: .default,
                                    reuseIdentifier: "SureListViewCell_\(cellType.rawValue)",
                                    type: cellType)
        cell.model = model
        
        if cellType == .text {
            
            cell.textChangeBlock = { text in
                model?.commonwealth = text
            }
            
        }else {
            
            cell.tapBlock = { [weak self] text in
                guard let self = self else { return }
                self.endEditing(true)
                let timeSelectView = TimeSelectView()
                
                let KeyWindow = getKeyWindow()
                
                KeyWindow?.addSubview(timeSelectView)
                timeSelectView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
                timeSelectView.setDate(with: text)
                
                timeSelectView.cancelChanged = {
                    timeSelectView.removeFromSuperview()
                }
                
                timeSelectView.onDateChanged = { dateString in
                    model?.commonwealth = dateString
                    cell.nameFiled.text = dateString
                    timeSelectView.removeFromSuperview()
                }
            }
            
        }
        
        return cell
        
    }
}

extension PopIDAuthView {
    
    private  func getKeyWindow() -> UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
}
