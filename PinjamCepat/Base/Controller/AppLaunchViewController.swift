//
//  AppLaunchViewController.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import SnapKit
import Alamofire

class AppLaunchViewController: UIViewController {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_launch_image")
        bgImageView.contentMode = .scaleAspectFit
        return bgImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NetworkMonitor.shared.statusChanged = { status in
            switch status {
            case .notReachable:
                AppNetworkConfig.shared.saveNetworkType(type: "Bad Network")

            case .reachable(.ethernetOrWiFi):
                print("📶 WiFi")
                AppNetworkConfig.shared.saveNetworkType(type: "WIFI")

            case .reachable(.cellular):
                AppNetworkConfig.shared.saveNetworkType(type: "5G")

            case .unknown:
                AppNetworkConfig.shared.saveNetworkType(type: "Unknown Network")
            }
        }

        NetworkMonitor.shared.startListening()
        
    }

}
