//
//  CameraManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/26.
//

import UIKit
import AVFoundation

class CameraManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = CameraManager()
    
    private var completion: ((Data?) -> Void)?
    private weak var presentingVC: UIViewController?
    
    func openCamera(from vc: UIViewController,
                    useFront: Bool,
                    completion: @escaping (Data?) -> Void) {
        
        self.presentingVC = vc
        self.completion = completion
        
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if granted {
                    self.presentCamera(useFront: useFront)
                } else {
                    self.showPermissionAlert()
                }
            }
        }
    }
    
    private func checkCameraPermission(_ result: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            result(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                result(granted)
            }
            
        case .denied, .restricted:
            result(false)
            
        @unknown default:
            result(false)
        }
    }
    
    private func presentCamera(useFront: Bool) {
        guard let vc = presentingVC,
              UIImagePickerController.isSourceTypeAvailable(.camera) else {
            completion?(nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        
        if useFront,
           UIImagePickerController.isCameraDeviceAvailable(.front) {
            picker.cameraDevice = .front
        } else if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            picker.cameraDevice = .rear
        }
        
        vc.present(picker, animated: true)
    }
    
    private func showPermissionAlert() {
        guard let vc = presentingVC else { return }
        
        let alert = UIAlertController(
            title: "Permission Required".localized,
            message: "Camera permission is disabled. Please enable it in Settings to allow your loan application to be processed.".localized,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
        
        alert.addAction(UIAlertAction(title: "Go to Settings".localized, style: .cancel, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        vc.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            completion?(nil)
            return
        }
        
        let data = compressImage(image, maxKB: 700)
        completion?(data)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        completion?(nil)
    }
    
    private func compressImage(_ image: UIImage, maxKB: Int) -> Data? {
        let maxBytes = maxKB * 1024
        
        var compression: CGFloat = 0.9
        guard var data = image.jpegData(compressionQuality: compression) else { return nil }
        
        while data.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            if let newData = image.jpegData(compressionQuality: compression) {
                data = newData
            }
        }
        
        if data.count > maxBytes {
            let ratio = CGFloat(maxBytes) / CGFloat(data.count)
            let scale = sqrt(ratio)
            
            let newSize = CGSize(
                width: image.size.width * scale,
                height: image.size.height * scale
            )
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let resized = resizedImage {
                data = resized.jpegData(compressionQuality: compression) ?? data
            }
        }
        
        return data
    }
}
