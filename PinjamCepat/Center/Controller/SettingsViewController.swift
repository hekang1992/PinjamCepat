//
//  SettingsViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import TYAlertController
import Combine

class SettingsViewController: BaseViewController {
    
    private var viewModel = CenterViewModel()
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.nameLabel.text = name
        }
    }
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.adjustsImageWhenHighlighted = false
        oneBtn.setBackgroundImage(UIImage(named: "otc_btn_image".localized), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.adjustsImageWhenHighlighted = false
        twoBtn.setBackgroundImage(UIImage(named: "otcd_btn_image".localized), for: .normal)
        return twoBtn
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
            self?.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        oneBtn.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 46))
        }
        twoBtn.snp.makeConstraints { make in
            make.top.equalTo(oneBtn.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335, height: 46))
        }
        
        oneBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.logoutInfo()
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.deleteInfo()
            })
            .disposed(by: disposeBag)
        
        twoBtn.isHidden = LanguageManager.shared.getCurrentLanguage() == .indonesian ? true : false
        
        bindViewModel()
    }
    
}

extension SettingsViewController {
    
    private func bindViewModel() {
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                let portent = model.portent ?? ""
                if portent == "0" {
                    self?.dismiss(animated: true)
                    LoginManager.shared.logout()
                    self?.switchRootVc()
                }
                ToastManager.showMessage(model.henceforward ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
                
            }
            .store(in: &cancellables)
        
        
    }
    
    private func logoutInfo() {
        let popView = PopTryAgainView(frame: self.view.bounds, type: .logout)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        popView.outBlock = { [weak self] in
            guard let self else { return }
            let phone = LoginManager.shared.getPhone() ?? ""
            let parameters = ["gloves": phone]
            viewModel.logoutInfo(parameters: parameters)
        }
    }
    
    private func deleteInfo() {
        let popView = PopTryAgainView(frame: self.view.bounds, type: .delete)
        let alertVc = TYAlertController(alert: popView, preferredStyle: .actionSheet)
        self.present(alertVc!, animated: true)
        popView.cancelBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        popView.outBlock = { [weak self] in
            guard let self else { return }
            guard popView.sureBtn.isSelected else {
                ToastManager.showMessage("Please read and agree to the above content")
                return
            }
            let phone = LoginManager.shared.getPhone() ?? ""
            let parameters = ["gloves": phone]
            viewModel.deleteInfo(parameters: parameters)
        }
    }
    
}
