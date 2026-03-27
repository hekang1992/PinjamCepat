//
//  HomeViewController.swift
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
import AppTrackingTransparency

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    private var viewModel = HomeViewModel()
    
    // MARK: - UI Components
    private lazy var oneView: EnView = {
        let oneView = EnView(frame: .zero)
        oneView.isHidden = true
        return oneView
    }()
    
    private lazy var twoView: EndView = {
        let twoView = EndView(frame: .zero)
        twoView.isHidden = true
        return twoView
    }()
    
    private lazy var errorView: HomeErrorView = {
        let errorView = HomeErrorView(frame: .zero)
        errorView.isHidden = true
        return errorView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHomeInfo()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(oneView)
        view.addSubview(twoView)
        view.addSubview(errorView)
        
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        oneView.tapProductBlock = { [weak self] producuId in
            guard let self = self else { return }
            guard LoginManager.shared.isLoggedIn() else {
                self.toLoginVc()
                return
            }
            self.clickProductInfo(productId: producuId)
        }
        
        oneView.policyBlock = { [weak self] in
            guard let self = self else { return }
            guard LoginManager.shared.isLoggedIn() else {
                self.toLoginVc()
                return
            }
            let pageUrl = UserDefaults.standard.string(forKey: "loan_url") ?? ""
            self.goH5WebVc(pageUrl: pageUrl)
        }
        
        self.errorView.tapBlock = { [weak self] in
            guard let self = self else { return }
            self.getHomeInfo()
        }
        
        self.oneView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getHomeInfo()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestIDFADelayed()
    }
}

// MARK: - Binding
extension HomeViewController {
    
    func requestIDFADelayed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            ATTrackingManager.requestTrackingAuthorization { _ in }
        }
    }
    
    private func updateViewVisibility(with model: BaseModel) {
        var listArray = model.gloves?.preached ?? []
        
        let hasWhoseb = listArray.contains { model in
            (model.led ?? "") == "whoseb"
        }
        
        oneView.isHidden = !hasWhoseb
        
        twoView.isHidden = hasWhoseb
        
        errorView.isHidden = true
        
        if let index = listArray.firstIndex(where: { $0.led == "whosea" }) {
            listArray.remove(at: index)
        }
        
        if hasWhoseb {
            self.oneView.model = listArray.first?.yielded?.first
        }else {
            
        }
        
    }
}

extension HomeViewController {
    
    private func getHomeInfo() {
        viewModel.homeInfo()
    }
    
    private func clickProductInfo(productId: String) {
        let parameters = ["despondency": productId, "dull": "1"]
        viewModel.clickProductInfo(parameters: parameters)
    }
    
    private func bindViewModel() {
        viewModel.$homeModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self = self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    if let loanModel = model.gloves?.cherish {
                        let loanUrl = loanModel.efficacy ?? ""
                        UserDefaults.standard.set(loanUrl, forKey: "loan_url")
                        UserDefaults.standard.synchronize()
                    }else {
                        UserDefaults.standard.removeObject(forKey: "loan_url")
                    }
                    self.updateViewVisibility(with: model)
                }
                self.oneView.endRefresh()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                if UIDevice.current.model == "iPad" {
                    self?.oneView.isHidden = true
                    self?.twoView.isHidden = true
                    self?.errorView.isHidden = false
                }else {
                    self?.oneView.endRefresh()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$clickModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self = self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    let pageUrl = model.gloves?.ugly ?? ""
                    self.goH5WebVc(pageUrl: pageUrl)
                }else {
                    if portent == "-2" {
                        self.toLoginVc()
                    }
                    ToastManager.showMessage(model.henceforward ?? "")
                }
            }
            .store(in: &cancellables)
        
    }
}
