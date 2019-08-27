//
//  UserRepo.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import Moya

public enum UserRepo {
    case getUser (Username)
}

extension UserRepo: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://api.github.com/search")!
    }
    
    public var path: String {
        switch self {
        case .getUser: return "/users"
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var method: Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .getUser(let username):
            return .requestParameters(parameters: ["q": "\(username.first)+\(username.last)"], encoding: NOURLEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var headers: [String: String]? {
        return nil
    }
}


