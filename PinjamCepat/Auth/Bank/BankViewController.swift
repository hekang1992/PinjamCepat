//
//  BankViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import Combine
import MJRefresh
import RxSwift
import RxCocoa
import TYAlertController

class BankViewController: BaseViewController {
    
    private var viewModel = BankViewModel()
    
    var modelArray: [favouriteModel] = []
    
    private var entertime: String = ""
    
    var stepModel: recordModel? {
        didSet {
            guard let stepModel = stepModel else { return }
            headView.nameLabel.text = stepModel.vowed ?? ""
            
        }
    }
    
    var cardModel: linesModel? {
        didSet {
            
        }
    }
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "en_fv_image".localized)
        return headImageView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle("Next".localized, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        nextBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.backBlock = { [weak self] in
            self?.toProductVc()
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10.pix())
        }
        
        
        view.addSubview(headImageView)
        
        
        headImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 58.pix()))
        }
        
        nextBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                var parameters = ["despondency": cardModel?.whimseys ?? ""]
                for model in modelArray {
                    let type = model.belief ?? ""
                    let key = model.portent ?? ""
                    var value: String
                    if type == "wickednessb" {
                        value = model.aware ?? ""
                    }else {
                        value = model.led ?? ""
                    }
                    parameters[key] = value
                }
                viewModel.saveListInfo(parameters: parameters)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        bindViewModel()
        
        getListInfo()
        
        entertime = String(Int(Date().timeIntervalSince1970))
        
        locationManager.startLocation { _ in }
    }
    
}

extension BankViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    self.modelArray = model.gloves?.favourite ?? []
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
                
            }
            .store(in: &cancellables)
        
        viewModel.$saveModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    self.trackAppInfo(step: "7", entertime: entertime, orderID: "")
                    self.toProductDetailInfo(cardModel: cardModel ?? linesModel())
                }else {
                    ToastManager.showMessage(model.henceforward ?? "")
                }
            }
            .store(in: &cancellables)
    }
    
    private func getListInfo() {
        if let cardModel = cardModel {
            let parameters = ["despondency": cardModel.whimseys ?? ""]
            viewModel.listInfo(parameters: parameters)
        }
        
    }
    
}

extension BankViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.modelArray[indexPath.row]
        
        let cellType: CellType
        
        if model.belief == "wickednessb" {
            cellType = .text
        }else {
            cellType = .click
        }
        
        let cell = SureListViewCell(style: .default,
                                    reuseIdentifier: "SureListViewCell_\(cellType.rawValue)",
                                    type: cellType)
        cell.listModel = model
        
        if cellType == .text {
            
            cell.textChangeBlock = { text in
                model.led = text
                model.aware = text
            }
            
        }else {
            
            cell.tapBlock = { [weak self] text in
                guard let self = self else { return }
                self.view.endEditing(true)
                
                let popView = AppSheetSelectView(frame: self.view.bounds)
                
                popView.nameStr = model.vowed ?? ""
                
                let modelArray = model.write ?? []
                
                popView.modelArray = modelArray
                
                for (index, model) in modelArray.enumerated() {
                    if model.jest == text {
                        popView.selectedIndex = IndexPath(row: index, section: 0)
                    }
                }
                
                let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
                
                self.present(alertVc!, animated: true)
                
                popView.cancelChanged = { [weak self] in
                    self?.dismiss(animated: true)
                }
                
                popView.onDateChanged = { [weak self] writeModel in
                    guard let self else { return }
                    self.dismiss(animated: true)
                    cell.nameFiled.text = writeModel.jest ?? ""
                    model.led = writeModel.led ?? ""
                    model.aware = writeModel.jest ?? ""
                }
                
            }
            
        }
        
        return cell
        
    }
    
}

