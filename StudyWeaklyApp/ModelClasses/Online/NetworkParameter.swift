//
//  NetworkParameter.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/25/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import Retrolux
struct LoginParameters {
    let username: Field
    let password: Field
}

struct QuestionSendParameter {
    let question_id: Field
    let answer: Field
}


struct ForgotResetParameters {
    let emailId: Field
  
}

