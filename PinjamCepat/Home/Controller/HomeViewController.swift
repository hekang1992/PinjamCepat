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
        
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Binding
extension HomeViewController {
    
    private func bindViewModel() {
        viewModel.$homeModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self = self else { return }
                self.updateViewVisibility(with: model)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
               
            }
            .store(in: &cancellables)
    }
    
    private func updateViewVisibility(with model: BaseModel) {
        var listArray = model.gloves?.preached ?? []
        
        let hasWhoseb = listArray.contains { model in
            (model.led ?? "") == "whoseb"
        }
        
        
        oneView.isHidden = !hasWhoseb
        
        twoView.isHidden = hasWhoseb
        
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
}
