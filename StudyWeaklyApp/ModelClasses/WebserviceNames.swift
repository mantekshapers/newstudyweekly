//
//  WebserviceNames.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/6/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
struct WebserviceName {
    
    static let userWebName = "user"
    static let userPassReset = "user/password_reset?"
    static let user_publication_ids = "user/publication_ids?"
    static let pulications = "publications?"
    static let students = "students?"
    static let searchStandard = "search/standard"
    static let searchMedia = "search/media"
    static let searchArticles = "search/article"
    static let unitsName = "units?"
    static let collectCointsName = "articles/redeem?"
    static let testAvailable = "assessments/available?"
    static let article_assessment = "articles/assessment"
    static let assessment_info = "assessments/info"
    static let quesAns_mc = "assessments/answer_mc"
    static let assessment_userScore = "assessments/user_scores"
}

