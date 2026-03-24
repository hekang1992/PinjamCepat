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

class LoginViewController: BaseViewController {
    
    private var countdownTimer: Timer?
    
    private var remainingSeconds: Int = 0
    
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
            
            self.startCountdown()
            
        }
        
        loginView.loginBlock = { [weak self] in
            guard let self else { return }
            let phone = self.loginView.phoneFiled.text ?? ""
            let code = self.loginView.codeFiled.text ?? ""
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
        }
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
                self.loginView.codeBtn.setTitle("Get Code".localized, for: .normal)
            }
        }
    }
}

extension LoginViewController {
    
}
