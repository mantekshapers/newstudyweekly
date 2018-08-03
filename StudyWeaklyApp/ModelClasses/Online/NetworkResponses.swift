//
//  NetworkResponses.swift
//  Studies Weekly
//
//  Created by Mitchell Tenney on 2/1/17.
//  Copyright © 2017 studiesweekly. All rights reserved.
//

import Foundation
import Retrolux


class LoginResponse: Reflection {
    
    class LoginSuccessResponse: Reflection {
        var user_id = ""
        var role = ""
    }
    
    var success: LoginSuccessResponse?
    var error: String?
}

// MARK: Content

//class PublicationsResponse: Reflection {
//    var success: [Publication]?
//    var error: String?
//}
//
//class ArticlesResponse: Reflection {
//    var success: [Article]?
//    var error: String?
//}
//
//class RedeemArticleResponse: Reflection {
//    var success: NSNumber? = nil
//    var error: String?
//}
//
//// MARK: Users
//
//class StudentsResponse: Reflection {
//    var success: [Classroom]?
//    var error: String?
//}
//
 class UserResponse: Reflection {
    var success: User?
    var error: String?
 }
//
//class UsersResponse: Reflection {
//    var success: [User]?
//    var error: String?
//}
//
//// MARK: Search
//
//class SearchArticlesResponse: Reflection {
//    var success: [SearchArticleResponseData]?
//    var error: String?
//}
//
//class SearchMediaResponse: Reflection {
//    var success: [SearchMediaResponseData]?
//    var error: String?
//}
//
//class SearchStandardsResponse: Reflection {
//    var success: [SearchStandardsResponseData]?
//    var error: String?
//}
//
//// MARK: Assessment
//
//class AssessmentResponse: Reflection {
//    var questions: [AssessmentQuestion]?
//}
//
//class AssessmentInfoResponse: Reflection {
//    var success: AssessmentInfo?
//    var error: String?
//}
//
//class AssessmentScoresResponse: Reflection {
//    var success: AssessmentScores?
//    var error: String?
//}
//
//class AssessmentAttemptResponse: Reflection {
//    var success: AssessmentAttempt?
//    var error: String?
//}
//
//class MCAnswerSubmitResponse: Reflection {
//    var correct: NSNumber = true
//    var points: NSNumber?
//}
//
//class SuccessResponse: Reflection {
//    var success: NSNumber?
//    var error: String?
//}
//
//class AssessmentSubmitResponse: Reflection {
//    var success: AssessmentSubmission?
//    var error: String?
//}
//
//class PasswordResetResponse: Reflection {
//    var success: NSNumber?
//    var message: String?
//}

