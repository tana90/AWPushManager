//
//  File.swift
//  
//
//  Created by Tudor Octavian Ana on 30.07.2021.
//

import Foundation

// MARK: Register user

struct AWRegisterUser: Encodable {
    var method: String = "register_user"
    var content: AWRegisterUserContent
}

struct AWRegisterUserContent: Encodable {
    var token: String
    var region: String
    var language: String
}


struct AWRegisterUserResponse: Decodable {
    var status: String
    var error: String
    var content: AWRegisterUserContentResponse
}

struct AWRegisterUserContentResponse: Decodable {
    var token: String
}

// MARK: Register device

struct AWRegisterDevice: Encodable {
    var method: String = "register_device"
    var content: AWRegisterDeviceContent
}

struct AWRegisterDeviceContent: Encodable {
    var token: String
    var deviceId: String
}
