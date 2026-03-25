//
//  ProductViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import Combine
import MJRefresh

class ProductViewController: BaseViewController {
    
    private var viewModel = ProductViewModel()
    
    var productID: String = ""
    
    lazy var productView: ProductView = {
        let productView = ProductView()
        return productView
    }()
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.nameLabel.text = name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(productView)
        productView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.productView.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.getProductDetailInfo(productId: productID)
        })
        
        self.productView.nextBlock = { [weak self] stepModel, cardModel in
            guard let self = self else { return }
            let type = stepModel.mental ?? ""
            if type == "noa" {
                let productID = cardModel.whimseys ?? ""
                self.getAuthIDInfo(with: productID)
            }else {
                self.goAuthPageVc(stepModel: stepModel, cardModel: cardModel)
            }
        }
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getProductDetailInfo(productId: productID)
    }
}

extension ProductViewController {
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                let portent = model.portent ?? ""
                if portent == "0" {
                    self?.productView.model = model.gloves
                    self?.productView.tableView.reloadData()
                }
                self?.productView.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.productView.tableView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$idModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                let portent = model.portent ?? ""
                if portent == "0" {
                    
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func getProductDetailInfo(productId: String) {
        let parameters = ["despondency": productId]
        viewModel.getProductDetailInfo(parameters: parameters)
    }
    
    private func getAuthIDInfo(with productId: String) {
        let parameters = ["despondency": productId]
        viewModel.getAuthIDInfo(parameters: parameters)
    }
    
}
