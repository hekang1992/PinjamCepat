//
//  CenterViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Combine
import MJRefresh

class CenterViewController: BaseViewController {
    
    private var viewModel = CenterViewModel()
    
    lazy var centerView: CenterView = {
        let centerView = CenterView()
        return centerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.centerView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self else { return }
            self.centerInfo()
        })
        
        self.centerView.listTapBlock = { [weak self] model in
            guard let self = self else { return }
            let pageUrl = model.ugly ?? ""
            self.goH5WebVc(pageUrl: pageUrl)
        }
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerInfo()
    }
    
}

extension CenterViewController {
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    let modelArray = model.gloves?.preached ?? []
                    self.centerView.modelArray = modelArray
                }
                self.centerView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.centerView.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
    }
    
    private func centerInfo() {
        let parameters = ["ugly": "1"]
        viewModel.centerInfo(parameters: parameters)
    }
    
}
