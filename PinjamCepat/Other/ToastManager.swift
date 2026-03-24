//
//  ToastManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import UIKit
import Toast_Swift

final class ToastManager {
    
    private struct Constants {
        static let defaultDuration: TimeInterval = 3.0
        static let defaultPosition: ToastPosition = .center
        static let messageFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        static let backgroundColor = UIColor.black.withAlphaComponent(0.8)
        static let textColor = UIColor.white
    }
    
    static func showMessage(
        _ message: String,
        duration: TimeInterval = Constants.defaultDuration,
        position: ToastPosition = Constants.defaultPosition
    ) {
        guard !message.isEmpty else { return }
        
        DispatchQueue.main.async { [weak window] in
            guard let window = window else {
                return
            }
            
            window.makeToast(
                message,
                duration: duration,
                position: position,
                style: toastStyle
            )
        }
    }
    
    private static var toastStyle: ToastStyle {
        var style = ToastStyle()
        style.messageFont = Constants.messageFont
        style.backgroundColor = Constants.backgroundColor
        style.messageColor = Constants.textColor
        style.cornerRadius = 8
        style.verticalPadding = 10
        style.horizontalPadding = 16
        return style
    }
    
    private static var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

extension UIColor {
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formattedString = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        if formattedString.hasPrefix("#") {
            formattedString = String(formattedString.dropFirst())
        }
        
        guard formattedString.count == 6 else {
            return nil
        }
        
        var hexValue: UInt64 = 0
        guard Scanner(string: formattedString).scanHexInt64(&hexValue) else {
            return nil
        }
        
        let r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hexValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
