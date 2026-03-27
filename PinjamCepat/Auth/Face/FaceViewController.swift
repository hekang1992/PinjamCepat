//
//  FaceViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import Combine
import MJRefresh
import RxSwift
import RxCocoa
import TYAlertController

class FaceViewController: BaseViewController {
    
    private var viewModel = FaceViewModel()
    
    private var entertime: String = ""
    
    var photoModel: BaseModel? {
        didSet {
            guard let photoModel = photoModel else { return }
            headView.nameLabel.text = photoModel.gloves?.contemplative?.first?.vowed ?? ""
        }
    }
    
    lazy var headImageView: UIImageView = {
        let headImageView = UIImageView()
        headImageView.image = UIImage(named: "en_one_image".localized)
        return headImageView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "idc_5_image".localized)
        return oneImageView
    }()
    
    lazy var photoBtn: UIButton = {
        let photoBtn = UIButton()
        photoBtn.setImage(UIImage(named: "idc_7_image".localized), for: .normal)
        photoBtn.adjustsImageWhenHighlighted = false
        return photoBtn
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle("Next".localized, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        nextBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
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
            self?.toProductVc()
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 293.pix(), height: 58.pix()))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10.pix())
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        contentView.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 58.pix()))
        }
        
        contentView.addSubview(oneImageView)
        contentView.addSubview(photoBtn)
        
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headImageView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 317.pix(), height: 16.pix()))
        }
        photoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(oneImageView.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 335.pix(), height: 405.pix()))
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
        self.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getDetailInfo()
        })
        
        photoBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let discovers = viewModel.model?.gloves?.yielded?.discovers ?? ""
                if discovers.isEmpty {
                    self.takeFrontPhoto()
                }else {
                    return
                }
            })
            .disposed(by: disposeBag)
        
        nextBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                let discovers = viewModel.model?.gloves?.yielded?.discovers ?? ""
                if discovers.isEmpty {
                    self.takeFrontPhoto()
                }else {
                    
                }
            })
            .disposed(by: disposeBag)
        
        getDetailInfo()
        
        bindViewModel()
        
        locationManager.startLocation { _ in }
        
        entertime = String(Int(Date().timeIntervalSince1970))
    }
    
}

extension FaceViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    
                }
                self.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$errorMsg
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.scrollView.mj_header?.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$pModel
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    self.appTcInfo()
                    self.toProductDetailInfo(cardModel: photoModel?.gloves?.lines ?? linesModel())
                }else {
                    ToastManager.showMessage(model.henceforward ?? "")
                }
            }
            .store(in: &cancellables)
        
        
    }
    
}

extension FaceViewController {
    
    private func getDetailInfo() {
        let parameters = ["despondency": photoModel?.gloves?.lines?.whimseys ?? ""]
        viewModel.getAuthIDInfo(parameters: parameters)
    }
    
    private func takeFrontPhoto() {
        CameraManager.shared.openCamera(from: self, useFront: true) { [weak self] data in
            guard let self, let data else { return }
            let parameters = ["led": "10", "strictness": "1"]
            viewModel.uploadRearInfo(parameters: parameters, imageData: data)
        }
    }
    
    private func appTcInfo() {
        self.trackAppInfo(step: "3", entertime: entertime, orderID: "")
    }
    
}
