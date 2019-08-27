//
//  NetworkManager.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import Foundation
import Moya


class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private let provider = MoyaProvider<UserRepo>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private var userData: UserData?
    
    /**
     Fetches an array of users for a given name.
     
     - Parameter name: first and last name of users queried.
     - Parameter completion: completion block returning  array or User objects or an error if applicable.
     */
    func fetchUsers(withName name: Username, completion: @escaping (Result<[User], Error>) -> Void) {
        
        provider.request(.getUser(name)) { response in
            switch response {
            case .success(let result):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = try decoder.decode(UserData.self, from: result.data)
                    completion(Result.success(data.items))
                } catch {
                    completion(Result.failure(NetworkError.failedToParseData))
                }
                
            case .failure:
                completion(Result.failure(NetworkError.failedToFetchData))
            }
        }
    }
}

enum NetworkError: Error {
    case failedToFetchData
    case failedToParseData
}
