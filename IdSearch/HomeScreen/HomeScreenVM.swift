//
//  InputVM.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class HomeScreenVM: ObservableObject {
    
    let titleLabelText = "Displaying users matching the name: "
    let textFieldPlaceholderText = "Enter MRZ"
    let MRZLabelText = "MRZ Code"
    
    var inputValue = ""
    @Published var displayName = ""
    @Published var users = [User]()
    
    /**
     Parses MRZ input to extract user's first and last name. Initiates a search of GitHub database for user data.
     
     - Throws: 'MRZParsingError.noInputProvided' if an empty string is submitted.
     - Throws: 'MRZParsingError.invalidInput' if input string is not properly formatted.
     */
    func parseInput() throws {
        
        do {
            let parsedInput = try inputValue.parseName()
            let username = Username(first: parsedInput.first, last: parsedInput.last)
            displayName = ("\(username.first) \(username.last)")
            do {
                try fetchUsers(forName: username)
            } catch {
                throw(error)
            }
            
        } catch {
            throw(error)
        }
    }
    
    /**
     Triggers network call to fetch users matching provided input.
     
     - Parameter name: Name of users to search database for.
     
     - Throws: 'NetworkError.failedToFetchData' if network call fails.
     - Throws: 'NetworkError.FailedToParseData' if data is not correctly formatted.
     */
    func fetchUsers(forName name: Username) throws {
        
        NetworkManager.sharedInstance.fetchUsers(withName: name) { (result) in
            
            switch result {
            case .success(let usersData):
                print("UserData: \(usersData)")
                self.users = usersData
                return
            case .failure(let error):
                print(error)
                break
            }
            
        }
    }
}
