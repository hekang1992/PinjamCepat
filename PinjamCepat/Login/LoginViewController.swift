//
//  LoginViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Combine

class LoginViewController: BaseViewController {
    
    private var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0
    
    private var viewModel = LoginViewModel()
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loginView.backBlock = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        loginView.policyBlock = { [weak self] in
            guard let self else { return }
            ToastManager.showMessage("policy")
        }
        
        loginView.codeBlock = { [weak self] in
            guard let self else { return }
            let phone = self.loginView.phoneFiled.text ?? ""
            guard !phone.isEmpty else {
                ToastManager.showMessage("Enter phone number".localized)
                return
            }
            self.codeInfo(phone: phone)
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self else { return }
            let phone = self.loginView.phoneFiled.text ?? ""
            let code = self.loginView.codeFiled.text ?? ""
            self.resignKeybord()
            guard !phone.isEmpty else {
                ToastManager.showMessage("Enter phone number".localized)
                return
            }
            guard !code.isEmpty else {
                ToastManager.showMessage("Enter verification code".localized)
                return
            }
            guard self.loginView.sureBtn.isSelected else {
                ToastManager.showMessage("Please read and confirm the privacy policy".localized)
                return
            }
            self.loginInfo(phone: phone, code: code)
        }
        
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginView.phoneFiled.becomeFirstResponder()
    }
    
    private func startCountdown(seconds: Int = 60) {
        stopCountdown()
        
        remainingSeconds = seconds
        updateCodeButtonState(isCountdown: true, remaining: remainingSeconds)
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
                self.updateCodeButtonState(isCountdown: true, remaining: self.remainingSeconds)
            } else {
                self.stopCountdown()
            }
        }
        
        if let timer = countdownTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        remainingSeconds = 0
        updateCodeButtonState(isCountdown: false, remaining: 0)
    }
    
    private func updateCodeButtonState(isCountdown: Bool, remaining: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if isCountdown && remaining > 0 {
                self.loginView.codeBtn.isEnabled = false
                let title = String(format: "%ds", remaining)
                self.loginView.codeBtn.setTitle(title, for: .normal)
            } else {
                self.loginView.codeBtn.isEnabled = true
                self.loginView.codeBtn.setTitle("Get code".localized, for: .normal)
            }
        }
    }
}

extension LoginViewController {
    
    private func bindViewModel() {
        viewModel.$codeModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                let portent = model.portent ?? ""
                let henceforward = model.henceforward ?? ""
                if portent == "0" {
                    self?.startCountdown()
                    self?.loginView.phoneFiled.becomeFirstResponder()
                }
                ToastManager.showMessage(henceforward)
            }
            .store(in: &cancellables)
        
        viewModel.$loginModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                let henceforward = model.henceforward ?? ""
                if portent == "0" {
                    let phone = model.gloves?.pure ?? ""
                    let token = model.gloves?.able ?? ""
                    LoginManager.shared.saveLogin(phone: phone, token: token)
                    self.switchRootVc()
                }
                ToastManager.showMessage(henceforward)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { _ in
                
            }
            .store(in: &cancellables)
    }
    
    private func codeInfo(phone: String) {
        let parameters = ["thank": phone]
        viewModel.codeInfo(parameters: parameters)
    }
    
    private func loginInfo(phone: String, code: String) {
        let parameters = ["pure": phone, "foolish": code]
        viewModel.loginInfo(parameters: parameters)
    }
    
    private func resignKeybord() {
        self.loginView.codeFiled.resignFirstResponder()
        self.loginView.phoneFiled.resignFirstResponder()
    }
    
}
