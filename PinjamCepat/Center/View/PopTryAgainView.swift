//
//  PopTryAgainView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum AgainViewType: String {
    case logout = "1"
    case delete = "2"
}

class PopTryAgainView: BaseView {
    
    var outBlock: (() -> Void)?
    
    var cancelBlock: (() -> Void)?
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        return bgImageView
    }()
    
    lazy var outBtn: UIButton = {
        let outBtn = UIButton(type: .custom)
        return outBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.adjustsImageWhenHighlighted = false
        sureBtn.setBackgroundImage(UIImage(named: "po_nor_image"), for: .normal)
        sureBtn.setBackgroundImage(UIImage(named: "po_sel_image"), for: .selected)
        return sureBtn
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.text = "I confirm deletion"
        oneLabel.textColor = UIColor.init(hexString: "#F70000")
        oneLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return oneLabel
    }()
    
    init(frame: CGRect, type: AgainViewType) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(375.pix())
            make.height.equalTo(316.pix())
        }
        
        bgImageView.addSubview(outBtn)
        bgImageView.addSubview(cancelBtn)
        
        outBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(68.pix())
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(outBtn.snp.top)
            make.height.equalTo(56.pix())
        }
        
        if type == .logout {
            bgImageView.image = UIImage(named: "en_out_bg_image".localized)
        }else {
            bgImageView.image = UIImage(named: "en_del_bg_image")
            bgImageView.addSubview(sureBtn)
            bgImageView.addSubview(oneLabel)
            sureBtn.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(162.pix())
                make.left.equalToSuperview().offset(110.pix())
                make.width.height.equalTo(12)
            }
            oneLabel.snp.makeConstraints { make in
                make.centerY.equalTo(sureBtn)
                make.left.equalTo(sureBtn.snp.right).offset(5)
                make.height.equalTo(20)
            }
        }
        
        outBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.outBlock?()
            })
            .disposed(by: disposeBag)
        
        cancelBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.cancelBlock?()
            })
            .disposed(by: disposeBag)
        
        sureBtn
            .rx
            .tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.sureBtn.isSelected.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CGFloat {
    func pix() -> CGFloat {
        return self / 375.0 * UIScreen.main.bounds.width
    }
}

extension Double {
    func pix() -> CGFloat {
        return CGFloat(self) / 375.0 * UIScreen.main.bounds.width
    }
}

extension Int {
    func pix() -> CGFloat {
        return CGFloat(self) / 375.0 * UIScreen.main.bounds.width
    }
}
