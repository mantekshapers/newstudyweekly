//
//  ConstantClass.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation
import UIKit

public struct storyBoardRefrence
{
    static let storyBoard = UIStoryboard(name: "Main", bundle: nil)
}

public struct StoryBoardId
{
    static let ViewControllerID = "ViewController"
    
    static let ForgotPasswordVCID = "ForgotPasswordVC"

    static let HomeFileViewControllerID = "HomeFileViewController"

    static let WeeklyListViewControllerID = "WeeklyListViewController"

    static let ScoreViewControllerID = "ScoreViewController"

    static let TestViewControllerID = "TestViewController"

    static let SwapViewControllerID = "SwapViewController"

    static let DemoTestViewControllerID = "DemoTestViewController"

    static let SearchMediaViewControllerID = "SearchMediaViewController"

    static let WeeklyUnitListVCID = "WeeklyUnitListVC"
    
    static let WeeklyDetailVCID = "WeeklyDetailVC"

    static let BonusViewControllerID = "BonusViewController"
    
    static let BonusDetailsVCID = "BonusDetailsVC"

    static let SearchViewControllerID = "SearchViewController"

    static let PlayViewControllerID = "PlayViewController"
    
    static let MoreViewControllerID = "MoreViewController"

    static let SettingsViewControllerID = "SettingsViewController"

    static let ContentOptionViewControllerID = "ContentOptionViewController"

    static let ClassViewControllerID = "ClassViewController"

    static let ScreenViewControllerID = "ScreenViewController"

    static let TabViewControllerID = "TabViewController"
}

struct BASEURL
{
    static let MerchantID = "XXX"
    static let MerchantUsername = "XXXXX"
    static let ImageBaseURL = "XXXXXXX"
    static let baseURL = "https://app.studiesweekly.com/online/api/v2/app/login"
  }

 struct BaseUrlOther
 {
    static let baseURLOther = "https://app.studiesweekly.com/online/api/v2/app/"
 }

public struct WSKeyValues
{
    static let StatusCode = "status"
    static let result = "result"
    static let content = "content"
    static let message = "message"
    static let success = "success"
    static let error = "error"
    
    //Change List
    static let date = "date"
    static let articles = "articles"
    static let publications = "publications"
    static let units = "units"
    
    //Unit Change List
    static let media = "media"
    static let panels = "panels"
    static let questions = "questions"
    static let standards = "standards"

    //---Login
    static let user_id = "user_id"
    static let username = "username"
    static let password = "password"
    static let role = "role"
    
    //---User
    static let name = "name"
    static let updated = "updated"
    static let email = "email"
    static let state = "state"
    static let points = "points"
    static let redeemed_points = "redeemed_points"
    static let crosswords = "crosswords"
    static let tests = "tests"
    static let publication_ids = "publication_ids"
    
    //---Pwd reset
    static let Email = "Email"
    
    //---Students
    static let id = "id"
    static let grade = "grade"
    static let school_year = "school_year"
    static let students = "students"
    static let student_password = "student_password"
    static let password_hash = "password_hash"

    //---Publications
    static let publication_id = "publication_id"
    static let body = "body"
    static let sku = "sku"
    static let cover_url = "cover_url"
    static let title = "title"
    static let description = "description"
    static let unit_id = "unit_id"
    static let test_id = "test_id"
    static let week_num = "week_num"
    
    //---Weekly
    static let article_id = "article_id"
    static let article_order = "article_order"
    static let article_title = "article_title"
    static let audio_link = "audio_link"
    static let audio_times = "audio_times"
    static let time = "time"
    static let word = "word"
    static let pod_media = "pod_media"
    static let container_id = "container_id"
    static let filesize = "filesize"
    static let language_code = "language_code"
    static let media_id = "media_id"
    static let order = "order"
    static let answer = "answer"
    static let difficulty = "difficulty"
    static let has_answered = "has_answered"
    static let points_possible = "points_possible"
    static let question = "question"
    static let question_id = "question_id"
    static let type = "type"
    static let source_info = "source_info"
    static let url = "url"
    
    //---Article
    static let pointless = "pointless"
    static let blackline_masters = "blackline_masters"
    static let code = "code"
    static let text = "text"
    static let splash_url = "splash_url"
    static let subject = "subject"
    static let standard_id = "standard_id"
    static let value = "value"
    static let replaces = "replaces"
    
    //--Unit Panels
    static let panel_id = "panel_id"
    static let admin_only = "admin_only"
    static let pdf_list = "pdf_list"
    static let text_block = "Publication text_block"
    static let link = "link"
    static let video = "video"
    static let standard = "standard"
    static let pod_videos = "pod_videos"
    
    //---Assessment
    static let bank = "bank"
    static let questions_labeling_q_data = "questions_labeling_q_data"
    static let show_bank = "show_bank"
    static let dots = "dots"
    static let top = "top"
    static let left = "left"
    static let option = "option"
    static let audio_id = "audio_id"
    static let questions_rfib_answers = "questions_rfib_answers"
    static let questions_rfib_q_data = "questions_rfib_q_data"
    static let blank = "blank"
    static let list_mode = "list_mode"
    static let sets = "sets"
    static let image = "image"
    static let right = "right"
    static let display_type = "display_type"
    static let questions_sorting_answers = "questions_sorting_answers"
    static let questions_check_all_answers = "questions_check_all_answers"
    static let long = "long"
    static let fib = "fib"
    static let questions_mc_answers = "questions_mc_answers"
    static let questions_true_false_answers = "questions_true_false_answers"
    
    //---Assessments/Info
    static let created = "created"
    static let amd5 = "amd5"
    static let active = "active"
    static let randomize = "randomize"
    static let questions_updated = "questions_updated"
    static let questions_mc_correct_answer = "questions_mc_correct_answer"
    static let actual_question = "actual_question"
    static let questions_open_correct_answer = "questions_open_correct_answer"
    
    //----Answer_mc
    static let correct = "correct"
    
    //----User Score
    static let num = "num"
    static let den = "den"
    static let score = "score"
    static let allow_retake = "allow_retake"
    static let full_retake = "full_retake"
    static let num_ungraded_questions = "num_ungraded_questions"
    static let user_tests_attempts = "user_tests_attempts"
    static let is_active = "is_active"
    static let attempt_type = "attempt_type"
    static let test_attempt_id = "test_attempt_id"
    static let user_points = "user_points"
    static let num_tests_attempts = "num_tests_attempts"
    static let manual_grade = "manual_grade"
    static let num_open_response_questions = "num_open_response_questions"
    static let last_name = "last_name"
    static let first_name = "first_name"
    
    //---Score
    static let scores = "scores"
    static let q_type = "q_type"
    static let graded_correct = "graded_correct"
    static let og_question = "og_question"
    static let teacher_response = "teacher_response"
    static let suggested_answer = "suggested_answer"
    static let graded = "graded"
    static let student_answer = "student_answer"
    static let question_array = "question_array"
    static let options_array = "options_array"
    static let questions_open = "questions_open"
    static let incorrect = "incorrect"
    static let ungraded = "ungraded"
    static let question_type_abbrev = "question_type_abbrev"
    
    //---Search
    static let resources = "resources"
    static let audio = "audio"
    static let images = "images"
    static let publication_title = "publication_title"
    static let publication_sku = "publication_sku"
    static let unit_title = "unit_title"
    static let unit_week_num = "unit_week_num"

}

 struct CustomBGColor
{
    static let navBGColor =  UIColor.init(red: 0.0/255.0, green: 157.0/255, blue: 220.0/255.0, alpha: 1.0)
    static let profileBGColor =  UIColor.init(red: 0.0/255.0, green: 75.0/255, blue: 117.0/255.0, alpha: 1.0)
    static let qHeaderCellBGColor =  UIColor.init(red: 43.0/255.0, green: 193.0/255, blue: 69.0/255.0, alpha: 1.0)
    static let questionBGColor = UIColor.init(red: 212.0/255.0, green: 212.0/255, blue: 212.0/255.0, alpha: 1.0)
    static let grayCellBGColor =  UIColor.init(red: 212.0/255.0, green: 212.0/255, blue: 212/255.0, alpha: 1.0)
    static let orangeCellBGColor =  "#fdb813"
    static let selectBGColor =  UIColor.red
    static let clearBGColor =  UIColor.clear
}

struct AlertTitle
{
    static let loginTextStr = "Please enter your username"
    static let passwordTextStr = "Please enter your password"
    static let networkStr = "Please check your network"
    static let emailEnterId = "Please enter your valid email Id"
}

  public enum UserDefaultsKey: String
  {
    case userID = "sw.userID"
    case isTeacher = "sw.isTeacher"
    case unitsID = "unitsID"
    case articleID = "article_id"
    case wifiKey = "wifi"
    case notificationKey = "OnOff"
}




