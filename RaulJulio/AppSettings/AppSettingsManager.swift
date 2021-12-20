//
//  AppSettingsManager.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import Foundation

final class AppSettingsManager {
    static let shared = AppSettingsManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    var preferences: [[String: AnyObject]] {
        guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension:"bundle"),
        let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")),
        let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: AnyObject]] else { return [] }
        return preferences
    }
    
    func updateSettings() {
        var saveSettings = [String: AnyObject]()
        preferences.forEach {
            guard let key = $0["Key"] as? String, let val = $0["DefaultValue"] else { return }
            saveSettings[key] = val
        }
        userDefaults.register(defaults: saveSettings)
        userDefaults.synchronize()
    }
    
    func getIOFValue() -> Double {
        let value = userDefaults.string(forKey: "iof") ?? ""
        return Double(value) ?? 0
    }
    
    func getDolarValue() -> Double {
        let value = userDefaults.string(forKey: "dolar") ?? ""
        return Double(value) ?? 0
    }
}
