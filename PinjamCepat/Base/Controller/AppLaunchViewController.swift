//
//  AppLaunchViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import Alamofire
import Combine
import RxSwift
import RxCocoa
import FBSDKCoreKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

class AppLaunchViewController: BaseViewController {
    
    private lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "app_launch_image")
        return imageView
    }()
    
    lazy var tryBtn: UIButton = {
        let tryBtn = UIButton(type: .custom)
        tryBtn.isHidden = true
        tryBtn.setBackgroundImage(UIImage(named: "try_again_image"), for: .normal)
        return tryBtn
    }()
    
    private let viewModel = LaunchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNetworkMonitoring()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
    
    private func setupUI() {
        view.addSubview(bgImageView)
        view.addSubview(tryBtn)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tryBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.size.equalTo(CGSize(width: 219, height: 58))
        }
    }
    
    private func setupNetworkMonitoring() {
        NetworkMonitor.shared.statusChanged = { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .notReachable:
                AppNetworkConfig.shared.saveNetworkType(type: "Bad Network")
                
            case .reachable(.ethernetOrWiFi):
                self.appInitInfo()
                AppNetworkConfig.shared.saveNetworkType(type: "WIFI")
                NetworkMonitor.shared.stopListening()
                
            case .reachable(.cellular):
                self.appInitInfo()
                AppNetworkConfig.shared.saveNetworkType(type: "5G")
                NetworkMonitor.shared.stopListening()
                
            case .unknown:
                AppNetworkConfig.shared.saveNetworkType(type: "Unknown Network")
                
            @unknown default:
                break
            }
        }
        
        bindViewModel()
        
        NetworkMonitor.shared.startListening()
    }
    
    @MainActor
    deinit {
        NetworkMonitor.shared.statusChanged = nil
        NetworkMonitor.shared.stopListening()
    }
}

extension AppLaunchViewController {
    
    private func bindViewModel() {
        
        tryBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.appInitInfo()
            })
            .disposed(by: disposeBag)
        
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    if let stealModel = model.gloves?.steal {
                        self.uploadFBSDKInfo(with: stealModel)
                    }
                    if let serverCode = model.gloves?.handle {
                        self.setupLanguageCode(with: serverCode)
                    }
                    self.switchRootVc()
                }else {
                    self.tryBtn.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let self else { return }
                self.tryBtn.isHidden = false
            }
            .store(in: &cancellables)
        
    }
    
    private func appInitInfo() {
        let parameters = NetworkEnvManager.shared.getAllInfo()
        viewModel.appLaunchInfo(parameters: parameters)
    }
}

extension AppLaunchViewController {
    
    private func uploadFBSDKInfo(with model: stealModel) {
        Settings.shared.displayName = model.confused ?? ""
        Settings.shared.appURLSchemeSuffix = model.seems ?? ""
        Settings.shared.appID = model.remembrance ?? ""
        Settings.shared.clientToken = model.gravely ?? ""
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            didFinishLaunchingWithOptions: nil
        )
    }
    
    private func setupLanguageCode(with serverCode: String) {
        LanguageManager.shared.setLanguageFromServerCode(serverCode)
    }
    
}
