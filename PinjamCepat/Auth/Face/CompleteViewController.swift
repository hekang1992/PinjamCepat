//
//  CompleteViewController.swift
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

class CompleteViewController: BaseViewController {
    
    private var viewModel = FaceViewModel()
    
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
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.setTitle("Next".localized, for: .normal)
        nextBtn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        nextBtn.setBackgroundImage(UIImage(named: "app_btn_bg_image"), for: .normal)
        nextBtn.adjustsImageWhenHighlighted = false
        return nextBtn
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "cco_desc_en_image".localized)
        descImageView.contentMode = .scaleAspectFit
        return descImageView
    }()
    
    lazy var contentImageView: UIImageView = {
        let contentImageView = UIImageView()
        contentImageView.image = UIImage(named: "cco_en_image".localized)
        contentImageView.contentMode = .scaleAspectFit
        return contentImageView
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
    
    lazy var oneListView: OrderListView = {
        let oneListView = OrderListView()
        oneListView.oneLabel.text = "Full name:".localized
        oneListView.bgView.backgroundColor = .white
        return oneListView
    }()
    
    lazy var twoListView: OrderListView = {
        let twoListView = OrderListView()
        twoListView.oneLabel.text = "ID number:".localized
        twoListView.bgView.backgroundColor = .white
        return twoListView
    }()
    
    lazy var threeListView: OrderListView = {
        let threeListView = OrderListView()
        threeListView.oneLabel.text = "Date of birth:".localized
        threeListView.bgView.backgroundColor = .white
        return threeListView
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
        
        
        view.addSubview(headImageView)
        headImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 58.pix()))
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(descImageView)
        contentView.addSubview(contentImageView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-5)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        descImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.size.equalTo(CGSize(width: 174.pix(), height: 196.pix()))
        }
        
        contentImageView.snp.makeConstraints { make in
            make.top.equalTo(descImageView.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 335.pix(), height: 212.pix()))
            make.bottom.equalToSuperview().offset(-20.pix())
        }
        
        contentImageView.addSubview(oneListView)
        contentImageView.addSubview(twoListView)
        contentImageView.addSubview(threeListView)
        
        oneListView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(53.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 311.pix(), height: 36.pix()))
        }
        twoListView.snp.makeConstraints { make in
            make.top.equalTo(oneListView.snp.bottom).offset(14.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 311.pix(), height: 36.pix()))
        }
        threeListView.snp.makeConstraints { make in
            make.top.equalTo(twoListView.snp.bottom).offset(14.pix())
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 311.pix(), height: 36.pix()))
        }
        
        nextBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.toProductDetailInfo(cardModel: photoModel?.gloves?.lines ?? linesModel())
            })
            .disposed(by: disposeBag)
        
        self.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getDetailInfo()
        })
        
        bindViewModel()
        
        getDetailInfo()
    }
    
}

extension CompleteViewController {
    
    private func bindViewModel() {
        viewModel.$model
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] model in
                guard let self else { return }
                let portent = model.portent ?? ""
                if portent == "0" {
                    if let userModel = model.gloves?.yielded?.user_info {
                        oneListView.twoLabel.text = userModel.blind ?? ""
                        twoListView.twoLabel.text = userModel.forefathers ?? ""
                        threeListView.twoLabel.text = userModel.betokening ?? ""
                        
                        oneListView.twoLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                        twoListView.twoLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                        threeListView.twoLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
                    }
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
    }
    
    private func getDetailInfo() {
        let parameters = ["despondency": photoModel?.gloves?.lines?.whimseys ?? ""]
        viewModel.getAuthIDInfo(parameters: parameters)
    }
    
}
