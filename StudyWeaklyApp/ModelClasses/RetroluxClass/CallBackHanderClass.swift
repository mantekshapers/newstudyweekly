//
//  CallBackHanderClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/2/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import UIKit
typealias AsyncCallback = () -> ()

typealias AsyncCallbackAndError = (_ error: Error?) -> ()

//typealias PublicationsCallback = ([Publication], _ error: Error?) -> ()
//
//typealias PublicationUnitsCallback = ([Unit], _ error: Error?) -> ()
//
//typealias ArticlesCallback = ([Article], _ error: Error?) -> ()
//
//typealias RedeemPointsCallback = (RedeemArticleResponse?, _ error: Error?) -> ()
//
//typealias PodMediaCallback = ([PodMedia], _ error: Error?) -> ()
//
//typealias QuestionsCallback = ([Question], _ error: Error?) -> ()
//
//typealias ClassroomsCallback = ([Classroom], _ error: Error?) -> ()
//
//typealias ClassroomCallback = (Classroom?, _ error: Error?) -> ()

typealias UsersCallback = ([User], _ error: Error?) -> ()

typealias UserCallback = (User?, _ error: Error?) -> ()

//typealias SearchCallback = (SearchResults, _ error: Error?) -> ()
//
//typealias AssessmentCallback = ([RealmAssessmentQuestion], _ error: Error?) -> ()

// MARK: Realm

typealias UpToDateCallback = (Bool) -> ()

typealias GetCallback<T> = ([T], _ error: Error?) -> ()
