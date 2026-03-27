//
//  OrderViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MJRefresh
import Combine

class OrderViewController: BaseViewController {
    
    private var selectedButton: UIButton?
    
    private var viewModel = OrderViewModel()
    
    private var type: String = "4"
    
    private var modelArray: [preachedModel] = []
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = "Order".localized
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return nameLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.isSelected = true
        oneBtn.setBackgroundImage(UIImage(named: "en_all_nor_image".localized), for: .normal)
        oneBtn.setBackgroundImage(UIImage(named: "en_all_sel_image".localized), for: .selected)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setBackgroundImage(UIImage(named: "en_pro_nor_image".localized), for: .normal)
        twoBtn.setBackgroundImage(UIImage(named: "en_pro_sel_image".localized), for: .selected)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setBackgroundImage(UIImage(named: "en_pay_nor_image".localized), for: .normal)
        threeBtn.setBackgroundImage(UIImage(named: "en_pay_sel_image".localized), for: .selected)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setBackgroundImage(UIImage(named: "en_fic_nor_image".localized), for: .normal)
        fourBtn.setBackgroundImage(UIImage(named: "en_fic_sel_image".localized), for: .selected)
        return fourBtn
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(OrderListViewCell.self, forCellReuseIdentifier: "OrderListViewCell")
        tableView.isHidden = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var emptyView: OrderListEmptyView = {
        let emptyView = OrderListEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedButton = oneBtn
        
        setupUI()
        setupBindings()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getListInfo(type: type)
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 40.pix()))
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView.snp.height)
        }
        
        contentView.addSubview(oneBtn)
        contentView.addSubview(twoBtn)
        contentView.addSubview(threeBtn)
        contentView.addSubview(fourBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 65.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 39.pix(), height: 37.pix()))
            }
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneBtn.snp.right).offset(13)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 105.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 90.pix(), height: 37.pix()))
            }
        }
        
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(twoBtn.snp.right).offset(13)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 97.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 93.pix(), height: 37.pix()))
            }
        }
        
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(threeBtn.snp.right).offset(13)
            make.right.equalToSuperview().offset(-15.pix())
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 58.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 74.pix(), height: 37.pix()))
            }
        }
        
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(2)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)
        }
        
        self.emptyView.tapBlock = { [weak self] in
            guard let self = self else { return }
            self.tabBarController?.selectedIndex = 0
        }
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getListInfo(type: self.type)
        })
    }
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    let modelArray = model.gloves?.preached ?? []
                    self.modelArray = modelArray
                    self.tableView.reloadData()
                    self.emptyView.isHidden = !modelArray.isEmpty
                    self.tableView.isHidden = modelArray.isEmpty
                }
                self.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
    }
    
    private func setupBindings() {
        oneBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.oneBtn)
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.twoBtn)
            })
            .disposed(by: disposeBag)
        
        threeBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.threeBtn)
            })
            .disposed(by: disposeBag)
        
        fourBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.fourBtn)
            })
            .disposed(by: disposeBag)
    }
    
    private func selectButton(_ button: UIButton) {
        guard selectedButton != button else { return }
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedButton = button
        handleButtonSelected(button)
    }
    
    private func handleButtonSelected(_ button: UIButton) {
        switch button {
        case oneBtn:
            self.type = "4"
            self.getListInfo(type: self.type)
            
        case twoBtn:
            self.type = "7"
            self.getListInfo(type: self.type)
            
        case threeBtn:
            self.type = "6"
            self.getListInfo(type: self.type)
            
        case fourBtn:
            self.type = "5"
            self.getListInfo(type: self.type)
            
        default:
            break
        }
    }
}

extension OrderViewController {
    
    private func getListInfo(type: String) {
        let parameters = ["witness": type]
        viewModel.orderListInfo(parameters: parameters)
    }
    
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.pix()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListViewCell", for: indexPath) as! OrderListViewCell
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.modelArray[indexPath.row]
        let pageUrl = model.settlement ?? ""
        self.goH5WebVc(pageUrl: pageUrl)
    }
    
}
