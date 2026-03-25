//
//  SettingsViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit

class SettingsViewController: BaseViewController {
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            headView.nameLabel.text = name
        }
    }
    
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
    }
    
    
    
}
