//
//  AppSheetSelectView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AppSheetSelectView: BaseView {
    
    // MARK: - Data
    var modelArray: [writeModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var nameStr: String? {
        didSet {
            descLabel.text = nameStr
        }
    }
    
    var selectedIndex: IndexPath?
    
    var selectedModel: writeModel? {
        guard let index = selectedIndex else { return nil }
        return modelArray?[index.row]
    }
    
    // MARK: - UI
    lazy var bgImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "time_bg_image")
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Confirm".localized, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        btn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.estimatedRowHeight = 60
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.contentInsetAdjustmentBehavior = .never
        table.rowHeight = UITableView.automaticDimension
        table.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        return table
    }()
    
    var onDateChanged: ((writeModel) -> Void)?
    var cancelChanged: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        bindAction()
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
            make.top.equalTo(descLabel.snp.bottom).offset(34.pix())
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(nextBtn.snp.top).offset(-5.pix())
        }
    }
    
    // MARK: - Bind
    private func bindAction() {
        
        nextBtn.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                guard let model = self.selectedModel else {
                    ToastManager.showMessage("Please select a certification item".localized)
                    return
                }
                
                self.onDateChanged?(model)
            }
            .disposed(by: disposeBag)
        
        cancelBtn.rx.tap
            .bind { [weak self] in
                self?.cancelChanged?()
            }
            .disposed(by: disposeBag)
    }
}

extension AppSheetSelectView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        cell.textLabel?.text = model?.jest ?? ""
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        if indexPath == selectedIndex {
            cell.textLabel?.textColor = .white
            cell.contentView.backgroundColor = UIColor(hexString: "#FF8F18")
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.masksToBounds = true
        } else {
            cell.textLabel?.textColor = .black
            cell.contentView.backgroundColor = .clear
            cell.contentView.layer.cornerRadius = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.reloadData()
    }
}
