//
//  ContactManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/27.
//

import UIKit
import Contacts
import ContactsUI

class ContactManager: NSObject {
    
    static let shared = ContactManager()
    
    private let store = CNContactStore()
    
    private weak var currentVC: UIViewController?
    
    private var singleSelectCallback: (([String: String]) -> Void)?
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized, .limited:
            completion(true)
            
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
    private func showSettingAlert() {
        let alert = UIAlertController(
            title: "Permission Required".localized,
            message: "Contact permission is disabled. Please enable it in Settings to allow your loan application to be processed.".localized,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Go to Settings".localized, style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }))
        
        currentVC?.present(alert, animated: true)
    }
    
    func pickSingleContact(from vc: UIViewController,
                           completion: @escaping ([String: String]) -> Void) {
        
        self.currentVC = vc
        self.singleSelectCallback = completion
        
        requestPermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                let picker = CNContactPickerViewController()
                picker.delegate = self
                picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                vc.present(picker, animated: true)
            } else {
                self.showSettingAlert()
            }
        }
    }
    
    func fetchAllContacts(completion: @escaping ([[String: String]]) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var result: [[String: String]] = []
            
            let keys = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey
            ] as [CNKeyDescriptor]
            
            let request = CNContactFetchRequest(keysToFetch: keys)
            
            do {
                try self.store.enumerateContacts(with: request) { contact, _ in
                    
                    let given = contact.givenName
                    let family = contact.familyName
                    let fullName = "\(given) \(family)".trimmingCharacters(in: .whitespaces)
                    
                    let phones = contact.phoneNumbers.map {
                        $0.value.stringValue.replacingOccurrences(of: " ", with: "")
                    }
                    
                    if phones.isEmpty { return }
                    
                    let phoneString = phones.joined(separator: ",")
                    
                    let dict: [String: String] = [
                        "thank": phoneString,
                        "jest": fullName
                    ]
                    
                    result.append(dict)
                }
                
            } catch {
                print("error--: \(error)")
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
}

extension ContactManager: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        
        let given = contact.givenName
        let family = contact.familyName
        let fullName = "\(given) \(family)".trimmingCharacters(in: .whitespaces)
        
        guard let phone = contact.phoneNumbers.first?.value.stringValue else {
            return
        }
        
        let cleanedPhone = phone.replacingOccurrences(of: " ", with: "")
        
        let result: [String: String] = [
            "thank": cleanedPhone,
            "jest": fullName
        ]
        
        singleSelectCallback?(result)
    }
}
