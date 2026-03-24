//
//  LanguageManager.swift
//  PinjamCepat
//
//  Created by hekang on 2026/3/24.
//

import Foundation

final class LanguageManager {
    
    static let shared = LanguageManager()
    
    private let userDefaultsKey = "AppLanguage"
    
    private var currentBundle: Bundle = .main
    
    enum Language: String {
        case english = "en"
        case indonesian = "id"
        
        var serverCode: String {
            return Language.serverCodeMap[self] ?? "1"
        }
        
        static func fromServerCode(_ code: String) -> Language {
            return serverCodeMap.first(where: { $0.value == code })?.key ?? .english
        }
        
        private static let serverCodeMap: [Language: String] = [
            .english: "1",
            .indonesian: "2"
        ]
    }
    
    private init() {
        let savedCode = UserDefaults.standard.string(forKey: userDefaultsKey)
        let language = Language(rawValue: savedCode ?? "") ?? .english
        apply(language)
    }
    
    func getCurrentLanguage() -> Language {
        let code = UserDefaults.standard.string(forKey: userDefaultsKey)
        return Language(rawValue: code ?? "") ?? .english
    }
    
    func getCurrentLanguageCode() -> String {
        return getCurrentLanguage().serverCode
    }
    
    func setLanguageFromServerCode(_ code: String) {
        let language = Language.fromServerCode(code)
        apply(language)
    }
    
    private func apply(_ language: Language) {
        UserDefaults.standard.set(language.rawValue, forKey: userDefaultsKey)
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        updateBundle(for: language)
    }
    
    private func updateBundle(for language: Language) {
        guard let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            currentBundle = .main
            return
        }
        currentBundle = bundle
    }
    
    func localizedString(for key: String) -> String {
        return currentBundle.localizedString(forKey: key, value: nil, table: nil)
    }
}

extension String {
    var localized: String {
        return LanguageManager.shared.localizedString(for: self)
    }
}
