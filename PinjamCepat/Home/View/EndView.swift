//
//  EndView.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/25.
//

import UIKit
import SnapKit

class EndView: BaseView {
    
    var tapProductBlock: ((String) -> Void)?
    
    var modelArray: [preachedModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HomeCardViewCell.self, forCellReuseIdentifier: "HomeCardViewCell")
        tableView.register(HomeProductListViewCell.self, forCellReuseIdentifier: "HomeProductListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EndView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?[section].yielded?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bigmodel = self.modelArray?[indexPath.section]
        let listmodel = bigmodel?.yielded?[indexPath.row]
        let type = bigmodel?.led ?? ""
        
        if type == "whosec" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCardViewCell", for: indexPath) as! HomeCardViewCell
            cell.model = listmodel
            cell.tapProductBlock = { [weak self] productId in
                guard let self = self else { return }
                self.tapProductBlock?(productId)
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductListViewCell", for: indexPath) as! HomeProductListViewCell
            cell.model = listmodel
            cell.tapProductBlock = { [weak self] productId in
                guard let self = self else { return }
                self.tapProductBlock?(productId)
            }
            return cell
        }
    }
    
}
