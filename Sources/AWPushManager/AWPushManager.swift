import Foundation
import AWNetworkManager

public struct AWPushManager {
    
    static var apiURL: String = ""
    
    static var token: String? {
        if let token = KeyChain.load(string: "AWPUSHREGISTERTOKEN"),
           token.count > 0 { } else {
            KeyChain.save(UUID().uuidString.data(using: .utf8)!, forkey: "AWPUSHREGISTERTOKEN")
           }
        
        return KeyChain.load(string: "AWPUSHREGISTERTOKEN")
    }
    
    // MARK: Register user

    static func registerUser(_ completion: @escaping (Bool) -> Void) {
        
        guard let token = token else {
            completion(false)
            return
        }
        
        let registerContent = AWRegisterUserContent(token: token,
                                                region: Locale.current.regionCode ?? "Unknown",
                                                language: Locale.current.languageCode ?? "Unknown")
        let register = AWRegisterUser(content: registerContent)
        
        guard let url = URL(string: apiURL),
              let body = try? JSONEncoder().encode(register) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.httpBody = body
        AWNetworkManager.begin(request) { result in
            
            switch result {
            case .success(let data):
                guard let response = try? JSONDecoder().decode(AWRegisterUserResponse.self, from: data),
                      response.status == "0" else {
                    completion(false)
                    return
                }
                
                completion(true)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    // MARK: Register Device Id
    
    static func register(device id: String,
                         _ completion: @escaping () -> Void) {
        
        guard let token = token else { return }
        
        let registerContent = AWRegisterDeviceContent(token: token, deviceId: id)
        let register = AWRegisterDevice(content: registerContent)
        
        guard let url = URL(string: apiURL),
              let body = try? JSONEncoder().encode(register) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.httpBody = body
        
        AWNetworkManager.begin(request) { result in
            
            defer {
                completion()
            }
            
            switch result {
            case .success(let data):
                print("Register device response: \(String(data: data, encoding: .utf8))")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
