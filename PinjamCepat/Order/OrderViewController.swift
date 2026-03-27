//
//  OrderViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OrderViewController: BaseViewController {
    
    private var selectedButton: UIButton?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = "Order".localized
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return nameLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.isSelected = true
        oneBtn.setBackgroundImage(UIImage(named: "en_all_nor_image".localized), for: .normal)
        oneBtn.setBackgroundImage(UIImage(named: "en_all_sel_image".localized), for: .selected)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setBackgroundImage(UIImage(named: "en_pro_nor_image".localized), for: .normal)
        twoBtn.setBackgroundImage(UIImage(named: "en_pro_sel_image".localized), for: .selected)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setBackgroundImage(UIImage(named: "en_pay_nor_image".localized), for: .normal)
        threeBtn.setBackgroundImage(UIImage(named: "en_pay_sel_image".localized), for: .selected)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setBackgroundImage(UIImage(named: "en_fic_nor_image".localized), for: .normal)
        fourBtn.setBackgroundImage(UIImage(named: "en_fic_sel_image".localized), for: .selected)
        return fourBtn
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedButton = oneBtn
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 375.pix(), height: 40.pix()))
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(scrollView.snp.height)
        }
        
        contentView.addSubview(oneBtn)
        contentView.addSubview(twoBtn)
        contentView.addSubview(threeBtn)
        contentView.addSubview(fourBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(13)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 65.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 39.pix(), height: 37.pix()))
            }
        }
        
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneBtn.snp.right).offset(13)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 105.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 90.pix(), height: 37.pix()))
            }
        }
        
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(twoBtn.snp.right).offset(13)
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 97.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 93.pix(), height: 37.pix()))
            }
        }
        
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(threeBtn.snp.right).offset(13)
            make.right.equalToSuperview().offset(-15.pix())
            if LanguageManager.shared.getCurrentLanguage() == .indonesian {
                make.size.equalTo(CGSize(width: 58.pix(), height: 37.pix()))
            }else {
                make.size.equalTo(CGSize(width: 74.pix(), height: 37.pix()))
            }
        }
    }
    
    private func setupBindings() {
        oneBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.oneBtn)
            })
            .disposed(by: disposeBag)
        
        twoBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.twoBtn)
            })
            .disposed(by: disposeBag)
        
        threeBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.threeBtn)
            })
            .disposed(by: disposeBag)
        
        fourBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectButton(self.fourBtn)
            })
            .disposed(by: disposeBag)
    }
    
    private func selectButton(_ button: UIButton) {
        guard selectedButton != button else { return }
        selectedButton?.isSelected = false
        button.isSelected = true
        selectedButton = button
        handleButtonSelected(button)
    }
    
    private func handleButtonSelected(_ button: UIButton) {
        switch button {
        case oneBtn:
            print("选中了全部订单")
            
        case twoBtn:
            print("选中了进行中的订单")
            
        case threeBtn:
            print("选中了待支付的订单")
            
        case fourBtn:
            print("选中了已完成/其他订单")
            
        default:
            break
        }
    }
}
