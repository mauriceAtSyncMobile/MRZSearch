//
//  UserData.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import Foundation


struct UserData: Codable {
    var totalCount: Int
    var incompleteResults: Bool
    var items: [User]
}

struct User: Codable, Identifiable {
    var login: String
    var id: Int
    var nodeId: String
    var avatarUrl: String
    var gravatarId: String?
    var url: String
    var htmlUrl: String
    var followersUrl: String
    var followingUrl: String
    var gistsUrl: String
    var starredUrl: String
    var subscriptionsUrl: String
    var organizationsUrl: String
    var reposUrl: String
    var eventsUrl: String
    var receivedEventsUrl: String
    var type: String
    var siteAdmin: Bool
    var score: Float
}
