//
//  String+MRZ.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import Foundation


extension String {
    
    /**
    Checks that string is correctly formated to match MRZ standard.
     
     - Returns: Bool value stating whether string is MRZ or not.
     */
    func isMRZ() -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9<]{2}[A-Z<]{3}[A-Z0-9<]{39}")
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    /**
    Parses MRZ string to extract user's first and last names.
     
     - Throws: 'MRZParsingError.noInputProvided' if no string is provided.
     - Throws: 'MRZParsingError.invalidInput' if string format does not match MRZ standard.
     
     - Returns:   A 'Username' object with user's first and last names.
     */
    func parseName() throws -> Username {
        
        guard !self.isEmpty else {
            throw(MRZParsingError.noInputProvided)
        }
        
        guard self.isMRZ() else {
            throw(MRZParsingError.invalidInput)
        }
        
        let dividedInput = self.components(separatedBy: "<<")
        
        let lastName = String(dividedInput[0].replacingOccurrences(of: "<", with: " ").dropFirst(5))
        let firstName = dividedInput[1].replacingOccurrences(of: "<", with: " ")
        
        return Username(first: firstName, last: lastName)
    }
}

enum MRZParsingError: Error {
    case noInputProvided
    case invalidInput
}
