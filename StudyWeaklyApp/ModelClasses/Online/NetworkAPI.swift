//
//  NetworkAPI.swift
//  Studies Weekly
//
//  Created by Mitchell Tenney on 12/12/16.
//  Copyright © 2017 studiesweekly. All rights reserved.
//

import Foundation
import Retrolux
import CommonCrypto
//import SwiftHash
//import Crashlytics

extension Response {
    var dataString: String? {
        if let data = data {
            return String(data: data, encoding: .ascii)
        }
        return nil
    }
}

class NetworkAPI {
    // MARK: Connect
    static let connect = builder.makeRequest(
        method: .get,
        endpoint: "",
        args: (),
        response: Void.self
    )
    // MARK: Login
    private static let loginEndpoint = "login"
    static let login = builder.makeRequest(
        method: .post,
        endpoint: loginEndpoint,
        args: LoginParameters(username: Field("username"),
                              password: Field("password")),
        response: LoginResponse.self
    )
    
    // MARK: Articles
    
//    static let getArticles = builder.makeRequest(
//        method: .get,
//        endpoint: "articles",
//        args: Query("unit_id"),
//        response: ArticlesResponse.self
//    )
//
//    static let redeemArticlePoints = builder.makeRequest(
//        method: .get,
//        endpoint: "articles/redeem",
//        args: RedeemArticleArgs(
//            articleID: "article_id",
//            pointless: "pointless"
//        ),
//        response: RedeemArticleResponse.self
//    )
//
//    // MARK: Publications
//
//    static let getPublications = builder.makeRequest(
//        method: .get,
//        endpoint: "publications",
//        args: (),
//        response: PublicationsResponse.self
//    )
//
//    // MARK: Unit Panels
//
//    static let getUnitPanels = builder.makeRequest(
//        method: .get,
//        endpoint: "units/panels",
//        args: Query("unit_id"),
//        response: UnitPanels.self
//    )
//
//    static let getUnitStandards = builder.makeRequest(
//        method: .get,
//        endpoint: "units/standards",
//        args: Query("unit_id"),
//        response: [UnitStandard].self
//    )
//
//    // MARK: Search
//
//    static let searchArticles = builder.makeRequest(
//        method: .get,
//        endpoint: "search/article",
//        args: Query("term"),
//        response: [SearchArticleResponseData].self)
//
//    static let searchMedia = builder.makeRequest(
//        method: .get,
//        endpoint: "search/media",
//        args: Query("term"),
//        response: SearchMediaResponseData.self)
//
//    static let searchStandards = builder.makeRequest(
//        method: .get,
//        endpoint: "search/standard",
//        args: Query("term"),
//        response: [SearchStandardsResponseData].self)
//
//    // MARK: Students
//
//    static let getStudents = builder.makeRequest(
//        method: .get,
//        endpoint: "students",
//        args: (),
//        response: StudentsResponse.self
//    )
//
    // MARK: Users

    static let getUser = builder.makeRequest(
        method: .get,
        endpoint: "user",
        args: Query("user_id"),
        response: UserResponse.self
    )
//
//    static let updateUserPassword = builder.makeRequest(
//        method: .post,
//        endpoint: "sync/password",
//        args: UpdateUserPasswordArgs(password: "password", userID: "user_id"),
//        response: SuccessResponse.self
//    )
//
//    static let updateUsername = builder.makeRequest(
//        method: .put,
//        endpoint: "sync/user",
//        args: UpdateUsernameArgs(),
//        response: SuccessResponse.self)
//
//    static let passwordReset = builder.makeRequest(
//        method: .post,
//        endpoint: "user/password_reset",
//        args: Query("email"),
//        response: PasswordResetResponse.self
//    )
//
//    // MARK: Assessment
//    static let getAssessment = builder.makeRequest(
//        method: .get,
//        endpoint: "assessments/info",
//        args: Query("unit_id"),
//        response: AssessmentInfoResponse.self
//    )
//
//    static let postMCAnswer = builder.makeRequest(
//        method: .post,
//        endpoint: "assessments/answer_mc",
//        args: MCAnswerParameters(question_id: Field("question_id"),
//                                 answer: Field("answer")),
//        response: MCAnswerSubmitResponse.self
//    )
//
//    static let getAssessmentScores = builder.makeRequest(
//        method: .get,
//        endpoint: "assessments/class_scores",
//        args: Query("unit_id"),
//        response: AssessmentScoresResponse.self
//    )
//
//    static let getAssessmentAttempt = builder.makeRequest(
//        method: .get,
//        endpoint: "assessments/scores",
//        args: AssessmentAttemptArgs(unitID: "unit_id",
//                                    studentID: "student_id"),
//        response: AssessmentAttemptResponse.self
//    )
//
//    static let studentGetAssessmentAttempt = builder.makeRequest(
//        method: .get,
//        endpoint: "assessments/scores",
//        args: Query("unit_id"),
//        response: AssessmentAttemptResponse.self
//    )
//
//    static let getStudentAssessmentAttempts = builder.makeRequest(
//        method: .get,
//        endpoint: "assessments/user_scores",
//        args: Query("unit_id"),
//        response: StudentAssessmentScore.self
//    )
//
//    static let activateAssessment = builder.makeRequest(
//        method: .put,
//        endpoint: "assessments/activate",
//        args: Query("unit_id"),
//        response: SuccessResponse.self
//    )
//
//    static let deactivateAssessment = builder.makeRequest(
//        method: .put,
//        endpoint: "assessments/deactivate",
//        args: Query("unit_id"),
//        response: SuccessResponse.self
//    )
//
//    static let randomizeAssessment = builder.makeRequest(
//        method: .put,
//        endpoint: "assessments/random",
//        args: RandomizeAssessmentArgs(unit_id: Query("unit_id"),
//                                      random: Query("random")),
//        response: SuccessResponse.self
//    )
//
//    static let swapAssessmentScore = builder.makeRequest(
//        method: .put,
//        endpoint: "assessments/swap_score",
//        args: SwapAssessmentScoresArgs(unitID: "unit_id",
//                                       studentID: "student_id",
//                                       attemptID: "attempt_id"),
//        response: SuccessResponse.self
//    )
//
//    static let checkAssessmentRetake = builder.makeRequest(
//        method: .get,
//        endpoint: "assessments/available",
//        args: AssessmentRetakeCheckArgs(userID: "user_id",
//                                        unitID: "unit_id"),
//        response: String.self
//    )
//
//    static let allowRetake = builder.makeRequest(
//        method: .post,
//        endpoint: "assessments/allow_retake",
//        args: AllowRevokeAssessmentRetakeArgs(unitID: "unit_id",
//                                        studentID: "student_id"),
//        response: SuccessResponse.self
//    )
//
//    static let revokeRetake = builder.makeRequest(
//        method: .post,
//        endpoint: "assessments/revoke_retake",
//        args: AllowRevokeAssessmentRetakeArgs(unitID: "unit_id",
//                                        studentID: "student_id"),
//        response: SuccessResponse.self
//    )
//
//    static let setAssessmentScore = builder.makeRequest(
//        method: .put,
//        endpoint: "assessments/scores",
//        args: SetAssessmentScoreArgs(unitID: "unit_id",
//                                     studentID: "student_id",
//                                     score: "score"),
//        response: SuccessResponse.self
//    )
//
//    static func submitAssessment(with args: SubmitAssessmentArgs) -> (SubmitAssessmentArgs) -> Call<AssessmentSubmitResponse> {
//        let submitAssessment = builder.makeRequest(
//            method: .post,
//            endpoint: "assessments/submit_test",
//            args: args,
//            response: AssessmentSubmitResponse.self
//        )
//
//        return submitAssessment
//    }
//
//    // MARK: Classroom
//
//    static let getClassrooms = builder.makeRequest(
//        method: .get,
//        endpoint: "classroom",
//        args: (),
//        response: [Classroom].self
//    )
//
//    static let getClassroomData = builder.makeRequest(
//        method: .get,
//        endpoint: "classroom/student",
//        args: Query("class_id"),
//        response: Classroom.self
//    )
//
//    // MARK: Update
//    static let syncChangeList = builder.makeRequest(
//        method: .get,
//        endpoint: "sync/change_list",
//        args: Query("date"),
//        response: ChangeList.self)
//
//    static let syncUnitChangeList = builder.makeRequest(
//        method: .get,
//        endpoint: "sync/unit_change_list",
//        args: SyncUnitChangeListArgs(unit_id: "unit_id",
//                                    date: "date"),
//        response: UnitChangeList.self)
//
    // MARK: Offline Sync
	
    
    // MARK: Helpers
    // -----------------
    
    // MARK: Login Cookie
    
    private static let loginCookieKey = "NetworkAPI.login.cookie"
    static func setLoginCookie<T>(using response: Response<T>, user: User? = nil) {
        let cookie = response.headers["Set-Cookie"]
        UserDefaults.standard.set(cookie, forKey: loginCookieKey)
        UserDefaults.standard.synchronize()
    }

    static func setUserID(_ id: String?) {
        if let id = id {
            UserDefaults.standard.set(id, forKey: UserDefaultsKey.userID.rawValue)
        } else {
             UserDefaults.standard.removeObject(forKey: loginCookieKey)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userID.rawValue)
        }
        UserDefaults.standard.synchronize()
    }

    static func userID() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsKey.userID.rawValue)
    }

    static func isTeacher() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.isTeacher.rawValue)
    }
    
    private static func applyDigestAuth(to request: inout URLRequest) {
        func md5(_ string: String) -> String {
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            
            let data = string.data(using: .utf8)!
            _ = data.withUnsafeBytes { bytes in
                CC_MD5(bytes, CC_LONG(data.count), &digest)
            }
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return digestHex
        }
        // Algorithm for RFC 2069 taken from:
        // https://en.wikipedia.org/wiki/Digest_access_authentication
        let username = "swApiUser"
        let realm = "REST API"
        //let password = "j9fw28rv6TUdtVxr"
      // let password = "rxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxr"
         let password = "eromrxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxrmore"
        let ha1 = md5("\(username):\(realm):\(password)")

        let method = "\(request.httpMethod ?? "")"
        let digestURI: String = {
            var url = "/"
            url += request.url!.absoluteString
            url = url.replacingOccurrences(of: builder.base.absoluteString, with: "")
            url = url.removingPercentEncoding!
            return url
        }()
        let ha2 = md5("\(method):\(digestURI)")
        let nonce = "1"
        let response = md5("\(ha1):\(nonce):\(ha2)")
        let responseStr = String(response)?.lowercased()
    
    let headerValue = "Digest username=\"\(username)\", realm=\"\(realm)\", nonce=\"\(nonce)\", uri=\"\(digestURI)\", response=\"\(responseStr ?? "")\", opaque=\"\""
        request.addValue(headerValue, forHTTPHeaderField: "Authorization")
    }
    
    private static func applyCookie(to request: inout URLRequest) {
       if let cookie: String = UserDefaults.standard.value(forKey: loginCookieKey) as? String {
            
            // This removes duplicate cookies.
            // If the server sends us too many duplicate cookies, we may get a HTTP 400 saying that the
            // cookies header is too long! What happens is the server sends us 4-5 Set-Cookie headers, and
            // when iOS sends the cookies back it lumps them into one header (no way around this without
            // ditching NSURLSession).
            //
            // To be clear, this is a hack. It's the server's fault. ;-)
            let cookies = Set(cookie.components(separatedBy: ", "))
        
            for cookie in cookies {
                request.addValue(cookie, forHTTPHeaderField: "Cookie")
            }
        }
    }
    
    static func requestInterceptor(_ request: inout URLRequest) {
        applyDigestAuth(to: &request)
        applyCookie(to: &request)
    }
    private static func printRequestData(_ request: inout URLRequest) {
        let httpMethod = request.httpMethod ?? "(null)"
        let bodyString: String?
        if let data = request.httpBody {
            bodyString = String(data: data, encoding: .ascii)
        } else {
            bodyString = nil
        }
        
        let url = request.url?.absoluteString ?? ""
       // debug("\(httpMethod) \(url)", tag: "NETWORK")
        if let bodyString = bodyString {
           // debug("\(bodyString)")
        }
        if let headers = request.allHTTPHeaderFields {
           // debug("\(headers)")
        }
    }
    
    static func responseInterceptor(_ response: inout ClientResponse) {
        let statusCode: Any = response.status ?? "(null)"
        let url = response.response?.url?.absoluteString ?? "(?)"
       // debug("\(statusCode)\t\t\(url)", tag: "NETWORK")
    }
    
    private static let builder: Builder = {
        enum ZeroOrOneSerializerError: Error {
            case unrecognizedDataResponse
        }
        
        class NumberResponseSerializer: InboundSerializer {
            public func supports(inboundType: Any.Type) -> Bool {
                return inboundType == NSNumber.self
            }
            
            public func makeValue<T>(from clientResponse: Retrolux.ClientResponse, type: T.Type) throws -> T {
                if let data = clientResponse.data, let string = String(data: data, encoding: .utf8) {
                    let sanitized = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    if let double = Double(sanitized) {
                        return NSNumber(value: double) as! T
                    }
                }
                throw ZeroOrOneSerializerError.unrecognizedDataResponse
            }
        }
		
		class StringResponseSerializer: InboundSerializer {
			public func supports(inboundType: Any.Type) -> Bool {
				return inboundType == String.self
			}
			
			public func makeValue<T>(from clientResponse: Retrolux.ClientResponse, type: T.Type) throws -> T {
				if let data = clientResponse.data, let string = String(data: data, encoding: .utf8) {
					return string as! T
				}
				throw ZeroOrOneSerializerError.unrecognizedDataResponse
			}
		}
		
        class Builder: Retrolux.Builder {
            override func log(request: URLRequest) {
                if let url = request.url?.absoluteString {
                   // debug("\(request.httpMethod ?? "(?)")\t\(url) at \(Date())", tag: "REQUEST")
                     print(("\(request.httpMethod ?? "(?)")\t\(url) at \(Date())", tag: "REQUEST"))
                }
                // print("\(request.httpMethod ?? "(?)")\t\(url) at \(Date())", tag: "REQUEST")
            }
            
            override func log<T>(response: Response<T>) {
                if let url = response.urlResponse?.url?.absoluteString {
                  //  debug("\(response.status ?? 0)\t\t\(url) at \(Date())", tag: "RESPONSE")
                    print(("\(response.status ?? 0)\t\t\(url) at \(Date())", tag: "RESPONSE"))
                }
                
                guard let data = response.data, let dataString = String(data: data, encoding: .ascii) else {
                    return
                }
                
                switch response.interpreted {
                case .success: break
                case .failure(let error):
                    if case BuilderResponseError.deserializationError(serializer: _, error: let retroluxError, clientResponse: _) = error {
//                        Flurry.logEvent(
//                            "Data_Error", withParameters: [
//                                "Retrolux Error": retroluxError.localizedDescription,
//                                "Data from Server": dataString
//                            ]
//                        )
                    }
                }
            }
        }
		
        let builder = Builder(base: URL(string: "https://app.studiesweekly.com/online/api/v2/app/")!)
		builder.client = SWHTTPClient()
        builder.requestInterceptor = requestInterceptor
        builder.responseInterceptor = responseInterceptor
        builder.serializers.append(NumberResponseSerializer())
		builder.serializers.append(StringResponseSerializer())
        return builder
    }()
}

class SWHTTPClient: HTTPClient {
	 func makeSessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 120
		return configuration
	}
}
