import Foundation

enum UserDataKeys: String {
    case isFirstLaunch
}

final class UserDataService: UserDefaultBase<UserDataKeys> {
    private let standard = UserDefaults.standard
    
    override init() {
        standard.register(defaults: [UserDataKeys.isFirstLaunch.rawValue: true])
    }
    
    var isFirstLaunch: Bool {
        get {
            return getBool(for: .isFirstLaunch)
        } set {
            setBool(value: newValue, key: .isFirstLaunch)
        }
    }
}
