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
    static let change_list = "sync/change_list"
    static let unit_change_list = "sync/unit_change_list"
    static let login = "login"
    static let userWebName = "user"
    static let userPassReset = "user/password_reset?"
    static let user_publication_ids = "user/publication_ids?"
    static let pulications = "publications?"
    static let students = "students?"
    static let unitsName = "units?"
    static let assessmentAvailable = "assessments/available?"
    static let articles = "articles"
    static let articleRedeem = "articles/redeem?"
    static let unitsPanels = "units/panels?"
    static let unitsStandard = "units/standards?"
    static let article_assessment = "articles/assessment?"
    static let assessment_info = "assessments/info?"
    static let assessment_submit = "assessments/submit_test"
    static let assessments_answer_mc = "assessments/answer_mc"
    static let units_redeem = "units/redeem?"
    static let assessment_scores = "assessments/scores"
    static let searchArticles = "search/article"
    static let searchStandard = "search/standard"
    static let searchMedia = "search/media"
    static let assessment_userScore = "assessments/user_scores"
    static let classRoom = "classroom"
    static let classRoom_Student = "classroom/student?"
    static let sync_password = "sync/password"
    static let sync_user = "sync/user"
    static let assessments_activate = "assessments/activate?"
    static let assessments_deactivate = "assessments/deactivate?"
    static let assessments_random = "assessments/random?"
    static let assessments_class_scores = "assessments/class_scores?"
    static let assessments_allow_retake = "assessments/allow_retake?"
    static let assessments_revoke_retake = "assessments/revoke_retake?"
    
    
    // /online/api/v2/app/classroom
}

