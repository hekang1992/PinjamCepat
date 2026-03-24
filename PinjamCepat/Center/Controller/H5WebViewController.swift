//
//  H5WebViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit
import StoreKit

class H5WebViewController: BaseViewController {
    
    var pageUrl: String = ""
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        config.userContentController.add(self, name: "JellyfishIts")
        config.userContentController.add(self, name: "LargerShe")
        config.userContentController.add(self, name: "SheHad")
        config.userContentController.add(self, name: "ItShe")
        config.userContentController.add(self, name: "HeartTo")
        let view = WKWebView(frame: .zero, configuration: config)
        return view
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.init(hexString: "#B5DAFA")
        progressView.trackTintColor = .clear
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindRx()
        loadPage()
    }
}

extension H5WebViewController {
    
    private func setupUI() {
        
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(webView)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        headView.backBlock = { [weak self] in
            guard let self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            }else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension H5WebViewController {
    
    private func bindRx() {
        
        webView.rx.observe(String.self, "title")
            .map { $0 ?? "" }
            .bind(to: self.headView.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        webView.rx.observe(Double.self, "estimatedProgress")
            .map { $0 ?? 0 }
            .subscribe(onNext: { [weak self] progress in
                self?.progressView.progress = Float(progress)
                self?.progressView.isHidden = progress >= 1.0
            })
            .disposed(by: disposeBag)
    }
}

extension H5WebViewController {
    
    private func loadPage() {
        guard let url = URL(string: DeviceParamsManager.getURLWithParams(baseURL: pageUrl)) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension H5WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        switch message.name {
        case "JellyfishIts":
            JellyfishIts()
            
        case "LargerShe":
            let listArray = message.body as? [String] ?? []
            self.LargerShe(pageUrl: listArray.first ?? "")
            print("pageUrl====\(listArray.first ?? "")")
            
        case "SheHad":
            SheHad()
            
        case "ItShe":
            ItShe()
            
        case "HeartTo":
            HeartTo()
            
        default:
            break
        }
    }
}

extension H5WebViewController {
    
    @objc func JellyfishIts() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func LargerShe(pageUrl: String) {
        
    }
    
    @objc func SheHad() {
        self.switchRootVc()
    }
    
    @objc func ItShe() {
        guard #available(iOS 14.0, *),
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    @objc func HeartTo() {
        
    }
}
