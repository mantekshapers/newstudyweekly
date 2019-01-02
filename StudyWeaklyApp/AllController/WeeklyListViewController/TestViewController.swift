//
//  TestViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/9/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import DropDown

class TestViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,TestDelegate,QTrueFalseDelegate,QrfibDelegate,CheckAllDelegate,SortDelegateClass,QuestionMatchingDelegate,SwapDelegateClass,UIGestureRecognizerDelegate,UITextFieldDelegate{
   
    
    
    var qSwapCellHeight:Int? = 60
    var dropDown:DropDown? = nil
     var cellTitle:UIButton? = nil
    var getUnitId:String?
    @IBOutlet weak var tbleView: UITableView!
    var testQuestionArr = [AnyObject]()
    var player:AVPlayer?
    var dragCGPoint: CGPoint?
    var multipleSelectArr = [AnyObject]()
    var selectCellIndex: Int? = -1
     let customAlertController = CustomController() 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.tbleView.delegate = self
        self.tbleView.dataSource = self
        self.tbleView.estimatedRowHeight = 50
        self.tbleView.rowHeight = UITableViewAutomaticDimension
         player = AVPlayer()
        customAlertController.showActivityIndicatory(uiView: self.view)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
        //getUnitId
        //128061
        
        let postDict = ["unit_id":"128061"]
        CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.assessment_info, postString: postDict as! [String : String], httpMethodName: "GET") { (respose, boolTrue) in
            
            if boolTrue == false{
                //let getDict = respose as! [String:AnyObject]
                DispatchQueue.main.async {
                    self.customAlertController.hideActivityIndicator(uiView: self.view)
                    //                    self.customAlertController.showCustomAlert3(getMesage: getDict["responseError"] as! String, getView: self)
                    //                    appdelegate?.hideLoader()
                }
                return
            }
            let getDataDict = respose as? [String: AnyObject]
            
            let getDataSuccess = getDataDict!["success"] as! [String: AnyObject]
            
            let getDataArr = getDataSuccess["questions"] as? [AnyObject]
            print("---------\(getDataArr)")
            if (getDataArr?.count)!>0{
                //self.testQuestionArr = getDataArr!
                // let qSArr = getUnitDetailDict?["standards"] as? [AnyObject]
                for data in getDataArr!{
                    var dataDict = [String:AnyObject]()
                    dataDict = data as! [String : AnyObject]
                    dataDict["selectAns"] = "unselect" as AnyObject
                    self.testQuestionArr.append(dataDict as AnyObject)
                }
            }
            
            DispatchQueue.main.async {
                self.customAlertController.hideActivityIndicator(uiView: self.view)
                self.tbleView.reloadData()
                print("test Question_response =\(getDataArr!)")
            }
            
        }
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // let getUserId    = NetworkAPI.userID()
       // let postDict = ["unit_id":getUnitId] as! [String:String]
       // getUnitId
        // FOR TEST UNIT_ID = 128061
        // article_assessment
      // replace  article_assessment with assessment_info
        
      
    }
    
    // UITableViewAutomaticDimension calculates height of label contents/text
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.1 and below
        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
        let typeStr = getDICT!["type"] as! String
        if typeStr == "questions_labeling"{
            return 370//UITableViewAutomaticDimension
        }else if typeStr == "questions_true_false"{
            //Q_open_Cell
            return 150
        }else if typeStr == "questions_open"{
            //Q_open_Cell
            return UITableViewAutomaticDimension
        }else if typeStr == "questions_check_all"{
            return UITableViewAutomaticDimension
        }else if typeStr == "questions_rfib"{
            return 120
        }else if typeStr == "questions_sorting"{
            return 164
           
        }else if typeStr == "questions_matching"{
            return CGFloat(qSwapCellHeight!)
           // return 410
        }
       // questions_check_all
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testQuestionArr.count
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///let cell = UITableViewCell()
        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
                let typeStr = getDICT!["type"] as! String
                if typeStr == "questions_labeling" {
                    
                    var cell: TestLblingCell! = tbleView.dequeueReusableCell(withIdentifier: "TestLblingCell") as? TestLblingCell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "TestLblingCell", bundle: nil), forCellReuseIdentifier: "TestLblingCell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "TestLblingCell") as? TestLblingCell
                      }
                    
                   // let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_question.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let imgDict = getDICT!["questions_labeling_q_data"] as? [String: AnyObject]
                    
                    let imgUrl = imgDict!["url"] as? String
                    
                     let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgUrl! )
                   // let imgeUrl = "https://" + urlDtr
                    CommonWebserviceClass.downloadImgFromServer(url:URL(string: urlStr ?? "0")!) { (DATA, RESPOSE, error) in
                        if DATA != nil {
                            DispatchQueue.main.async { // Correct
                                cell.img_imgView.image = UIImage(data: DATA!)
                                cell.imageView?.backgroundColor = UIColor.green
                            }
                        }
                    }
                    cell.btn_play.tag = indexPath.row
//                     cell.btn_drag.tag = indexPath.row
//                    cell.btn_drag1.tag = indexPath.row
                    cell.btn_play.addTarget(self, action: #selector(qmcPlayClick1(_:)), for: .touchUpInside)
                  
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler(panGesture:)))
                   // panGesture1.minimumNumberOfTouches = 1
                    panGesture.delegate = self
                    cell.lbl_drag.tag = indexPath.row
                    cell.lbl_drag.isUserInteractionEnabled = true
                    cell.lbl_drag.addGestureRecognizer(panGesture)
                    let panGesture1 = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandler1(panGesture:)))
                    // panGesture1.minimumNumberOfTouches = 1
                    panGesture1.delegate = self
                    cell.lbl_drag1.tag = indexPath.row
                    cell.lbl_drag1.isUserInteractionEnabled = true
                    cell.lbl_drag1.addGestureRecognizer(panGesture1)
                    
                    return cell
                }else if typeStr == "questions_mc" {
                    var cell: Q_mc_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_mc_Cell") as? Q_mc_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_mc_Cell", bundle: nil), forCellReuseIdentifier: "Q_mc_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_mc_Cell") as? Q_mc_Cell
                    }
                  //  let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
                    cell.testDelegateCall = self
                    cell.btn_a.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_b.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_c.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_d.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_a.tag = indexPath.row
                    cell.btn_b.tag = indexPath.row
                    cell.btn_c.tag = indexPath.row
                    cell.btn_d.tag = indexPath.row
                    cell.btn_play.tag = indexPath.row
                    cell.btn_play.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_qTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let selectAnswer = getDICT?["selectAns"] as? String
                    let getQAswerDict = getDICT!["questions_mc_correct_answer"] as? [String: AnyObject]
                    let qAndA_a = "A. \(getQAswerDict?["a"] as? String ?? "")"
                    let qAndA_b = "B. \(getQAswerDict?["b"] as? String ?? "")"
                    let qAndA_c = "C. \(getQAswerDict?["c"] as? String ?? "")"
                    let qAndA_d = "D. \(getQAswerDict?["d"] as? String ?? "")"
                    cell.btn_a.setTitle(qAndA_a, for: .normal)
                    cell.btn_b.setTitle(qAndA_b, for: .normal)
                    cell.btn_c.setTitle(qAndA_c, for: .normal)
                    cell.btn_d.setTitle(qAndA_d, for: .normal)
                    if selectAnswer == "a"{
                      cell.btn_a.backgroundColor = UIColor.green
                    }else if selectAnswer == "b"{
                        cell.btn_b.backgroundColor = UIColor.green
                    }else if selectAnswer == "c"{
                         cell.btn_c.backgroundColor = UIColor.green
                       
                    }else if selectAnswer == "d" {
                         cell.btn_d.backgroundColor = UIColor.green
                      }
                   
                    return cell
                  
                }else if typeStr == "questions_true_false"{
                    //questions_true_false
                    var cell: Q_true_false_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_true_false_Cell") as? Q_true_false_Cell
                if cell == nil {
                        tbleView.register(UINib(nibName: "Q_true_false_Cell", bundle: nil), forCellReuseIdentifier: "Q_true_false_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_true_false_Cell") as? Q_true_false_Cell
                    }
                    
                    cell.qTrueFalseDelegate = self
                    cell.btn_yes.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_no.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_play.tag = indexPath.row
                    cell.btn_yes.tag = indexPath.row
                    cell.btn_no.tag = indexPath.row
                    cell.btn_play.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_qTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let selectAnswer = getDICT?["selectAns"] as? String
//                    let getQAswerDict = getDICT!["questions_mc_correct_answer"] as? [String: AnyObject]
                    let qAndA_a = "A. True"
                    let qAndA_b = "B. False"
                  
                    cell.btn_yes.setTitle(qAndA_a, for: .normal)
                    cell.btn_no.setTitle(qAndA_b, for: .normal)
                   
                     if selectAnswer == "Yes"{
                        cell.btn_yes.backgroundColor = UIColor.green
                     }else if selectAnswer == "No"{
                        cell.btn_no.backgroundColor = UIColor.green
                      }
                    
                    return cell
                }else if typeStr == "questions_rfib"{
                    //questions_true_false
                    var cell: Q_rfib_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_rfib_Cell", bundle: nil), forCellReuseIdentifier: "Q_rfib_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    }
                      cell.qrfibDelegate = self
                    cell.btn_qrPlay.tag = indexPath.row
                    cell.btn_down.tag = indexPath.row
                    cell.btn_qrPlay.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                  
                    let questStr = getDICT!["question"]  as? String
                    cell.txtView.attributedText = CustomController.stringFromHtml(string: questStr!)
                    
                    var txtView =  cell.txtView
                    let dictGet = getDICT!["questions_rfib_correct_answer"] as! [String: AnyObject]
                    let arr = dictGet["question_array"] as! [AnyObject]
                    
                    let array = ["Public","private"]
                    for var i in 0..<arr.count {
                        let wordDict = arr[i] as? [String: AnyObject]
                        let wordStr = wordDict!["blank"] as? String
                
                        let answerStr = wordDict!["word"] as? String
                        if wordStr == "true" {
                            let optionArr = wordDict!["options"] as! [AnyObject]
                            let range: NSRange = (txtView!.text as NSString).range(of: answerStr!)
                        let beginning: UITextPosition? = txtView?.beginningOfDocument
                        let start: UITextPosition? = txtView?.position(from: beginning!, offset: range.location)
                        let end: UITextPosition? = txtView?.position(from: start!, offset: range.length)
                        let textRange: UITextRange? = txtView?.textRange(from: start!, to: end!)
                        let rect: CGRect = txtView!.firstRect(for: textRange!)
                       
                        let btn = UIButton()
                            btn.frame = rect
                           btn.titleLabel?.font =  .systemFont(ofSize: 9)
                          //  btn.titleLabel?.textColor = UIColor.red
                          btn.backgroundColor = UIColor.lightGray
                       // btn.tag = range.location
                            btn.tag = i
                           btn.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
                
                           txtView?.addSubview(btn)
                            print("frame of button ==\(btn.frame)")
                            let x = btn.frame.origin.x
                             let y  = btn.frame.origin.y
                            dropDown = DropDown()
                            // The view to which the drop down will appear on
                            // UIView or UIBarButtonItem
                            // The list of items to display. Can be changed dynamically
                           // dropDown?.dataSource = optionArr as! [String]//["Car", "Motorcycle", "Truck"]
                            /*** IMPORTANT PART FOR CUSTOM CELLS ***/
                            dropDown?.cellNib = UINib(nibName: "MyCell", bundle: nil)
                            
                            dropDown?.customCellConfiguration = { (index: Index, item: String, cell1: DropDownCell) -> Void in
                                guard let cell2 = cell1 as? MyCell else { return }
                                // Setup your custom UI components
                                // cell2.logoImageView.image = UIImage(named: "logo_\(index)")
                                cell2.lbl_title.text = item
                              }
                            dropDown?.selectionAction = { [weak self] (index, item) in
                                print("====\(item)")
                                self?.cellTitle?.setTitle(item, for: .normal)
                            
                               }
                            dropDown?.hide()
                           // cell.dropDownMethod(dropDown: dropDown!)
                          }
                      }
                    
                    return cell
                 }else if typeStr == "questions_open"{
                    //questions_true_false
                    var cell: Q_open_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_open_Cell") as? Q_open_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_open_Cell", bundle: nil), forCellReuseIdentifier: "Q_open_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_open_Cell") as? Q_open_Cell
                    }
                    cell.txtField_open.delegate = self
                    let questStr = getDICT!["actual_question"]  as? String
                    cell.lbl_openQ.attributedText = CustomController.stringFromHtml(string: questStr!)
                    cell.txtField_open.tag = indexPath.row
                    cell.txtField_open.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
                    return cell
                    
                }else if typeStr == "questions_check_all"{
                    //questions_true_false
                    var cell: Q_check_all_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_check_all_Cell") as? Q_check_all_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_check_all_Cell", bundle: nil), forCellReuseIdentifier: "Q_check_all_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_check_all_Cell") as? Q_check_all_Cell
                    }
                    cell.checkAllDelegate = self
                    
                    cell.btn_a.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_b.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_c.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_d.backgroundColor = CustomBGColor.questionBGColor
                    cell.btn_a.tag = indexPath.row
                    cell.btn_b.tag = indexPath.row
                    cell.btn_c.tag = indexPath.row
                    cell.btn_d.tag = indexPath.row
                    cell.btn_playCheck.tag = indexPath.row
                    cell.btn_playCheck.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_checkTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    let getQAswerDict = getDICT!["questions_check_all_answers"] as? [String: AnyObject]
                    let qAndA_a = "A. \(getQAswerDict?["a"] as? String ?? "")"
                    let qAndA_b = "B. \(getQAswerDict?["b"] as? String ?? "")"
                    let qAndA_c = "C. \(getQAswerDict?["c"] as? String ?? "")"
                    let qAndA_d = "D. \(getQAswerDict?["d"] as? String ?? "")"
                    cell.btn_a.setTitle(qAndA_a, for: .normal)
                    cell.btn_b.setTitle(qAndA_b, for: .normal)
                    cell.btn_c.setTitle(qAndA_c, for: .normal)
                    cell.btn_d.setTitle(qAndA_d, for: .normal)
                    
                    if let selectArr = getDICT?["selectAns"] as? [AnyObject] {
                        
                     for var i in 0..<selectArr.count {
                    let selectAnswer = selectArr[i] as? String
                    if selectAnswer == "a"{
                        
                        cell.btn_a.backgroundColor = UIColor.green
                        
                     }else if selectAnswer == "b"{
                        
                        cell.btn_b.backgroundColor = UIColor.green
                        
                     }else if selectAnswer == "c"{
                        
                        cell.btn_c.backgroundColor = UIColor.green
                        
                     }else if selectAnswer == "d" {
                        
                        cell.btn_d.backgroundColor = UIColor.green
                        
                        }
                      }
                  }
                    //CheckAllDelegate
                    return cell
        }else if typeStr == "questions_sorting"{
                    
                    //questions_true_false
                    var cell: Q_sorting_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_sorting_Cell") as? Q_sorting_Cell
                    if cell == nil {
                        tbleView.register(UINib(nibName: "Q_sorting_Cell", bundle: nil), forCellReuseIdentifier: "Q_sorting_Cell")
                        cell = tbleView.dequeueReusableCell(withIdentifier: "Q_sorting_Cell") as? Q_sorting_Cell
                        
                      }
                    cell.sortDelegateClass = self
                    cell.btn_sortPlay.tag = indexPath.row
                    cell.btn_sortPlay.addTarget(self, action: #selector(btn_sortPlayMethod(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_qSortTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    
                    let getSortDict = getDICT!["questions_sorting_correct_answer"]  as? [String: AnyObject]
                    let getSortArr = getSortDict!["options_array"]  as? [AnyObject]
                    cell.sendCollectionMethod(getOptionArr: getSortArr!,index:indexPath.row)
                    return cell
                    
         }else if typeStr == "questions_matching"{
                    
                    //questions_true_false
                    /*
                    var cell: Q_match_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_match_Cell") as? Q_match_Cell
                    if cell == nil {
                    tbleView.register(UINib(nibName: "Q_match_Cell", bundle: nil), forCellReuseIdentifier: "Q_match_Cell")
                    cell = tbleView.dequeueReusableCell(withIdentifier: "Q_match_Cell") as? Q_match_Cell
                    }
                    */
                    
                     var cell: QSwapCell! = tbleView.dequeueReusableCell(withIdentifier: "QSwapCell") as? QSwapCell
                    
                    if cell == nil {
                        tbleView.register(UINib(nibName: "QSwapCell", bundle: nil), forCellReuseIdentifier: "QSwapCell")
                      cell = tbleView.dequeueReusableCell(withIdentifier: "QSwapCell") as? QSwapCell
                        let getSortDict = getDICT!["questions_matching_correct_answer"]  as? [String: AnyObject]
                        let getSetsArr = getSortDict!["sets"]  as? [AnyObject]
                         var rx_axix:Int = 130
                         var y_axix:Int = 74
                        for var i in 0..<getSetsArr!.count {
                             let lbl_match = UILabel()
                            lbl_match.frame = CGRect(x: rx_axix + 110, y: y_axix, width: Int(self.view.frame.size.width - CGFloat(rx_axix + 120)), height: 100)
                            lbl_match.tag = (1000  + i)
                            lbl_match.numberOfLines = 0
                            cell.contentView.addSubview(lbl_match)
                            y_axix = y_axix + 120
                        }
                    }
                    
                        /*
                        let getSortDict = getDICT!["questions_matching_correct_answer"]  as? [String: AnyObject]
                        let getSetsArr = getSortDict!["sets"]  as? [AnyObject]
                        
                        var x_axix:Int = 16
                        var y_axix:Int = 74
                        var Rx_axix:Int = 130
                        var yView_axix:Int = 74
                        for var i in 0..<getSetsArr!.count {
                            print("print==\(i)")
                            let commonDict = getSetsArr![i] as? [String: AnyObject]
                            let leftDict = commonDict!["left"] as? [String: AnyObject]
                            let rightDict = commonDict!["right"] as? [String: AnyObject]
                            
                            let imgTmp = leftDict!["image"] as? String
                            let txtTmp = leftDict!["text"] as? String
                            
                            let imgRight = rightDict!["image"] as? String
                            let txtRightStr = rightDict!["text"] as? String
                            
                            
                            let lbl_match = UILabel()
                            let img_rightView = UIImageView()
                            let imgView = UIImageView()
                            let imgView1 = UIImageView()
                            imgView1.backgroundColor = UIColor.red
                            imgView.tag = i
                            imgView1.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
                            imgView.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
                            
                            img_rightView.frame = CGRect(x: Rx_axix, y: y_axix, width: 100, height: 100)
                            lbl_match.frame = CGRect(x: Rx_axix + 110, y: y_axix, width: Int(self.view.frame.size.width - CGFloat(Rx_axix + 120)), height: 100)
                            lbl_match.backgroundColor = UIColor.red
                            img_rightView.backgroundColor = UIColor.yellow
                            //panRec.addTarget(self, action: "draggedView:")
                            lbl_match.numberOfLines = 0
                            lbl_match.text = txtRightStr
                            self.view.addSubview(lbl_match)
                            self.view.addSubview(img_rightView)
                            
                            imgView.backgroundColor = UIColor.green
                            //panRec.addTarget(self, action: "draggedView:")
                            imgView.tag = i
                            self.view.addSubview(imgView1)
                            self.view.addSubview(imgView)
                            // self.view?.bringSubview(toFront: imgView!)
                            y_axix = y_axix + 120
                        }
 */
                 //   }
                    /*
                    cell.img_dropOnView.isHidden = true
                    cell.img_drop1OnView.isHidden = true
                    cell.img_drop2OnView.isHidden = true
                    
                    cell.questionMatchingDelegate = self
                    cell.btn_matchPlay.tag = indexPath.row
                    cell.btn_matchPlay.addTarget(self, action: #selector(btn_matchPlayMethod(_:)), for: .touchUpInside)
                    
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_matchQTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    */
                    qSwapCellHeight = 60
                    cell.btn_edit.tag = indexPath.row
                    cell.btn_edit.addTarget(self,action:#selector(editBtnClick(_:)),for: .touchUpInside)
                    cell.btn_q_swapPlay.tag = indexPath.row
                    cell.btn_q_swapPlay.addTarget(self, action: #selector(qmcPlayClick(_:)), for: .touchUpInside)
                    let questStr = getDICT!["question"]  as? String
                    cell.lbl_q_swapTitle.attributedText = CustomController.stringFromHtml(string: questStr!)
                    print("ROW PATH INDEX=\(indexPath.row)")
                    let getSortDict = getDICT!["questions_matching_correct_answer"]  as? [String: AnyObject]
                    let getSetsArr = getSortDict!["sets"]  as? [AnyObject]
     
                    var x_axix:Int = 16
                    var y_axix:Int = 74
                    var Rx_axix:Int = 130
                    var yView_axix:Int = 74
                    for var i in 0..<getSetsArr!.count {
                        print("print==\(i)")
                        qSwapCellHeight = qSwapCellHeight! + 120
                        let commonDict = getSetsArr![i] as? [String: AnyObject]
                        let leftDict = commonDict!["left"] as? [String: AnyObject]
                        let rightDict = commonDict!["right"] as? [String: AnyObject]
                        
                        let imgTmp = leftDict!["image"] as? String
                        let txtTmp = leftDict!["text"] as? String
                        
                         let imgRight = rightDict!["image"] as? String
                        let txtRightStr = rightDict!["text"] as? String
                        

                          let lbl_matchTitle:UILabel = cell.viewWithTag((1000  + i)) as! UILabel
                            lbl_matchTitle.text = txtRightStr
                          //.  let lbl_match = UILabel()
                            let img_rightView = UIImageView()
                            let imgView = UIImageView()
                            let imgView1 = UIImageView()
                           // imgView1.backgroundColor = UIColor.red
                            imgView.tag = i
                            imgView1.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
                            imgView.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
                        
                           img_rightView.frame = CGRect(x: Rx_axix, y: y_axix, width: 100, height: 100)
                         // lbl_match.frame = CGRect(x: Rx_axix + 110, y: y_axix, width: Int(self.view.frame.size.width - CGFloat(Rx_axix + 120)), height: 100)
                       // lbl_match.backgroundColor = UIColor.red
                       // img_rightView.backgroundColor = UIColor.yellow
                        //panRec.addTarget(self, action: "draggedView:")
//                        lbl_match.numberOfLines = 0
//                        lbl_match.textAlignment = .center
//                        lbl_match.text = txtRightStr
//                        cell.addSubview(lbl_match)
                        cell.addSubview(img_rightView)
                            
                           // imgView.backgroundColor = UIColor.green
                            //panRec.addTarget(self, action: "draggedView:")
                            imgView.tag = i
                            cell.addSubview(imgView1)
                            cell.addSubview(imgView)
                            // self.view?.bringSubview(toFront: imgView!)
                            y_axix = y_axix + 120
                       
                        DispatchQueue.main.async { // Correct
                            img_rightView.image = UIImage(named: "drop_image.png")
                            imgView.image = UIImage(named: "drag_icon")
                        }
                        if imgRight == "" || imgRight == nil {
                           
                            if imgTmp != "" {
                            let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgTmp! )
                            let url = URL(string: urlStr) as? URL
                            // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                               // DispatchQueue.global(qos: .background).async {
                            CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                                if DATA != nil {
                                    DispatchQueue.main.async { // Correct
                                        imgView.image = UIImage(data: DATA!)
                                    }
                                }else{
                                    
                                    imgView.image = nil
                                  }
                              }
                       // }
                          }else {
                           
                          }
                         }else {
                            img_rightView.image = nil
                            imgView.image = nil
                            if imgRight != "" {
                               
                                let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgRight!)
                                let url = URL(string: urlStr) as? URL
                                // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                               // DispatchQueue.global(qos: .background).async {
                                    CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                                        if DATA != nil {
                                            DispatchQueue.main.async { // Correct
                                                 imgView.image =  UIImage(named: "")
                                                img_rightView.image = UIImage(data: DATA!)
                                            }
                                        }else{
                                            imgView.image =  UIImage(named: "")
                                            img_rightView.image = nil
                                        }
                                    }
                                }
                           // }
                            
                        }
                        
                        /*
                        if i == 0 {
                            cell.lbl_matchTitle1.text = txtRightStr
                        if (imgTmp == nil || imgTmp == "") && (imgRight == "" || imgRight == nil) {
                            var lbl_drag = UILabel()
                             lbl_drag.text = txtTmp
                             lbl_drag.font = UIFont.systemFont(ofSize: 10)
                             lbl_drag.numberOfLines = 0
                             lbl_drag.textAlignment = NSTextAlignment.center
                             lbl_drag.frame =  cell.view_drag1.frame//CGRect(x: 0, y: 0, width: 76, height: 100)
                           // cell.view_drag1.addSubview(lbl_drag)
                               lbl_drag.tag = i
                            cell.contentView.addSubview(lbl_drag)
                        lbl_drag.bringSubview(toFront: cell.contentView)
                            lbl_drag.backgroundColor = UIColor.green
                            lbl_drag.isUserInteractionEnabled = true
                         
                            cell.gestureAddOnAnyViewMethod(view: lbl_drag, cellIndex: indexPath.row)
                          
                          //  cell.gestureAddOnAnyViewMethod(view: lbl_drag)
                            
                        }else if (imgTmp != nil || imgTmp != "") && (imgRight == "" || imgRight == nil){
                            
                            let img_drag = UIImageView()
                            img_drag.frame =  cell.view_drag1.frame//CGRect(x: 0, y: 0, width: 76, height: 100)
                            // cell.view_drag2.addSubview(img_drag)
                            cell.addSubview(img_drag)
                           // img_drag.bringSubview(toFront: cell.view_drag1)
                             img_drag.isUserInteractionEnabled = true
                             img_drag.tag = i
                            cell.gestureAddOnAnyViewMethod(view: img_drag, cellIndex: indexPath.row)
                            
                            let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgTmp!)
                            let url = URL(string: urlStr) as? URL
                           // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                            CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                                if DATA != nil {
                                    DispatchQueue.main.async { // Correct
                                       img_drag.image = UIImage(data: DATA!)
                                    }
                                }else{
                                     img_drag.image = nil
                                }
                            }
                        }else if (imgTmp == nil || imgTmp == "") && (imgRight != "" || imgRight != nil) {
                            
                            let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgRight!)
                            let url = URL(string: urlStr) as? URL
                            // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                            CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                                if DATA != nil {
                                    DispatchQueue.main.async { // Correct
                                        cell.img_dropOnView.isHidden = false
//                                        cell.img_drop1OnView.isHidden = true
//                                        cell.img_drop2OnView.isHidden = true
                                        cell.img_dropOnView.image = UIImage(data: DATA!)
                                      }
                                }else{
                                      cell.img_dropOnView.image = UIImage()
                                  }
                            }
                            
                            }
                        }else if i == 1 {
                              cell.lbl_matchTitle2.text = txtRightStr
                            if (imgTmp == nil || imgTmp == "") && (imgRight == "" || imgRight == nil) {
                                let lbl_drag = UILabel()
                                lbl_drag.text = txtTmp
                                lbl_drag.numberOfLines = 0
                                lbl_drag.textAlignment = NSTextAlignment.center
                                lbl_drag.font = UIFont.systemFont(ofSize: 10)
//                                lbl_drag.frame = CGRect(x: 0, y: 0, width: 76, height: 100)
                               lbl_drag.backgroundColor = UIColor.green
//                                cell.view_drag2.addSubview(lbl_drag)
                                lbl_drag.frame =  cell.view_drag2.frame//CGRect(x: 0, y: 0, width: 76, height: 100)
                                // cell.view_drag1.addSubview(lbl_drag)
                                cell.addSubview(lbl_drag)
                                lbl_drag.tag = i
                                lbl_drag.isUserInteractionEnabled = true
                                lbl_drag.bringSubview(toFront: cell.contentView)
                                cell.gestureAddOnAnyViewMethod(view: lbl_drag, cellIndex: indexPath.row)
                                
                            }else if (imgTmp != nil || imgTmp != "") && (imgRight == "" || imgRight == nil) {
                                let img_drag = UIImageView()
                                img_drag.frame =  cell.view_drag2.frame//CGRect(x: 0, y: 0, width: 76, height: 100)
                               // cell.view_drag2.addSubview(img_drag)
                                cell.contentView.addSubview(img_drag)
                                img_drag.bringSubview(toFront: cell.view_drag2)
                                img_drag.isUserInteractionEnabled = true
                                   img_drag.tag = i
                                cell.gestureAddOnAnyViewMethod(view: img_drag, cellIndex: indexPath.row)
                                 let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgTmp!)
            CommonWebserviceClass.downloadImgFromServer(url:URL(string: urlStr as? String ?? "0")!) { (DATA, RESPOSE, error) in
                                    if DATA != nil {
                                        DispatchQueue.main.async { // Correct
                                            img_drag.image = UIImage(data: DATA!)
                                          }
                                    }else{
                                         img_drag.image = UIImage()
                                    }
                                  }
                            }else if (imgTmp == nil || imgTmp == "") && (imgRight != "" || imgRight != nil){
                                let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgRight!)
                                let url = URL(string: urlStr) as? URL
                                // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                                CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                                    if DATA != nil {
                                        DispatchQueue.main.async { // Correct
                                            cell.img_drop1OnView.isHidden = false
                                            cell.img_drop1OnView.image = UIImage(data: DATA!)
                                        }
                                    }else{
                                        cell.img_drop1OnView.image = nil
                                    }
                                }
                            }
                        }else if i == 2 {
                            cell.lbl_matchTitle.text = txtRightStr
                            if (imgTmp == nil || imgTmp == "") && (imgRight == "" || imgRight == nil) {
                                let lbl_drag = UILabel()
                                lbl_drag.text = txtTmp
                                lbl_drag.numberOfLines = 0
                                 lbl_drag.textAlignment = NSTextAlignment.center
                                lbl_drag.font = UIFont.systemFont(ofSize: 10)
//                                lbl_drag.frame = CGRect(x: 0, y: 0, width: 76, height: 100)
                                 lbl_drag.backgroundColor = UIColor.green
//                                cell.view_drag3.addSubview(lbl_drag)
                                lbl_drag.frame =  cell.view_drag3.frame//CGRect(x: 0, y: 0, width: 76, height: 100)
                                // cell.view_drag1.addSubview(lbl_drag)
                                cell.contentView.addSubview(lbl_drag)
                                lbl_drag.tag = i
                                lbl_drag.bringSubview(toFront: cell.contentView)
                                lbl_drag.isUserInteractionEnabled = true
                                cell.gestureAddOnAnyViewMethod(view: lbl_drag, cellIndex: indexPath.row)
                            }else if (imgTmp != nil || imgTmp != "") && (imgRight == "" || imgRight == nil){
                                let img_drag = UIImageView()
                                img_drag.frame =  cell.view_drag2.frame//CGRect(x: 0, y: 0, width: 76, height: 100)
                                // cell.view_drag2.addSubview(img_drag)
                                cell.contentView.addSubview(img_drag)
                                img_drag.bringSubview(toFront: cell.view_drag2)
                                img_drag.isUserInteractionEnabled = true
                                img_drag.tag = i
                                cell.gestureAddOnAnyViewMethod(view: img_drag, cellIndex: indexPath.row)
                                let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgTmp!)
                         CommonWebserviceClass.downloadImgFromServer(url:URL(string: urlStr as? String ?? "0")!) { (DATA, RESPOSE, error) in
                                    if DATA != nil {
                                        DispatchQueue.main.async { // Correct
                                            img_drag.image = UIImage(data: DATA!)
                                        }
                                    }else {
                                          img_drag.image = nil
                                 }
                                }
                            }else if (imgTmp == nil || imgTmp == "") && (imgRight != "" || imgRight != nil){
                                
                                let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgRight!)
                                let url = URL(string: urlStr) as? URL
                                // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                                CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                                    if DATA != nil {
                                        DispatchQueue.main.async { // Correct
                                            cell.img_drop2OnView.isHidden = false
                                            cell.img_drop2OnView.image = UIImage(data: DATA!)
                                              }
                                        }else{
                                        cell.img_drop2OnView.image = nil
                                      }
                                   }
                                
                                }
                            
                            }
                        */
                       
                        }
                    
                    return cell
                }
        /*else if typeStr == "questions_rfib"{
                    //questions_true_false
                    var cell: Q_rfib_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    if cell == nil {
                    tbleView.register(UINib(nibName: "Q_rfib_Cell", bundle: nil), forCellReuseIdentifier: "Q_rfib_Cell")
                    cell = tbleView.dequeueReusableCell(withIdentifier: "Q_rfib_Cell") as? Q_rfib_Cell
                    }
                    return cell
                }else if typeStr == "questions_check_all"{
                    //questions_true_false
                    var cell: Q_check_all_Cell! = tbleView.dequeueReusableCell(withIdentifier: "Q_check_all_Cell") as? Q_check_all_Cell
                    if cell == nil {
                    tbleView.register(UINib(nibName: "Q_check_all_Cell", bundle: nil), forCellReuseIdentifier: "Q_check_all_Cell")
                    cell = tbleView.dequeueReusableCell(withIdentifier: "Q_check_all_Cell") as? Q_check_all_Cell
                    }
                    //CheckAllDelegate
                    return cell
                }
 */
        
        return UITableViewCell()
    }
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let getDICT = testQuestionArr[indexPath.row] as? [String: AnyObject]
        let typeStr = getDICT!["type"] as! String
        
        
        print(" indexPath.row=\(indexPath.row) and its data=\(getDICT)")
        if typeStr == "questions_matching"{
            
          
            print("ROW PATH INDEX=\(indexPath.row)")
            let getSortDict = getDICT!["questions_matching_correct_answer"]  as? [String: AnyObject]
            let getSetsArr = getSortDict!["sets"]  as? [AnyObject]
            
            var x_axix:Int = 16
            var y_axix:Int = 74
            var Rx_axix:Int = 130
            var yView_axix:Int = 74
            for var i in 0..<getSetsArr!.count {
                print("print==\(i)")
                let commonDict = getSetsArr![i] as? [String: AnyObject]
                let leftDict = commonDict!["left"] as? [String: AnyObject]
                let rightDict = commonDict!["right"] as? [String: AnyObject]
                
                let imgTmp = leftDict!["image"] as? String
                let txtTmp = leftDict!["text"] as? String
                
                let imgRight = rightDict!["image"] as? String
                let txtRightStr = rightDict!["text"] as? String
                
                
                let lbl_match = UILabel()
                let img_rightView = UIImageView()
                let imgView = UIImageView()
                let imgView1 = UIImageView()
               // imgView1.backgroundColor = UIColor.red
                imgView.tag = i
                imgView1.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
                imgView.frame = CGRect(x: x_axix, y: y_axix, width: 100, height: 100)
                
                img_rightView.frame = CGRect(x: Rx_axix, y: y_axix, width: 100, height: 100)
                lbl_match.frame = CGRect(x: Rx_axix + 110, y: y_axix, width: Int(self.view.frame.size.width - CGFloat(Rx_axix + 120)), height: 100)
               // lbl_match.backgroundColor = UIColor.red
                // img_rightView.backgroundColor = UIColor.yellow
                //panRec.addTarget(self, action: "draggedView:")
                lbl_match.numberOfLines = 0
                lbl_match.text = txtRightStr
                cell.addSubview(lbl_match)
                cell.addSubview(img_rightView)
                
               // imgView.backgroundColor = UIColor.green
                //panRec.addTarget(self, action: "draggedView:")
                imgView.tag = i
                cell.addSubview(imgView1)
                cell.addSubview(imgView)
                // self.view?.bringSubview(toFront: imgView!)
                y_axix = y_axix + 120
                
                DispatchQueue.main.async { // Correct
                    img_rightView.image = UIImage(named:"drop_image.png")
                    imgView.image = UIImage()
                }
                if imgRight == "" || imgRight == nil {
                    
                    if imgTmp != "" {
                        let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgTmp! )
                        let url = URL(string: urlStr) as? URL
                        // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                        // DispatchQueue.global(qos: .background).async {
                        CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                            if DATA != nil {
                                DispatchQueue.main.async { // Correct
                                    imgView.image = UIImage(data: DATA!)
                                }
                            }else{
                                
                                imgView.image = UIImage(named:"wrong_answer_image.png")
                            }
                        }
                        // }
                    }else {
                        
                    }
                }else {
                   
                    if imgRight != "" {
                        
                        let urlStr = CustomController.backSlaceRemoveFromUrl(urlStr: imgRight!)
                        let url = URL(string: urlStr) as? URL
                        // let coverImage = getMediaDict!["media_splash"] as? String ?? "0"
                        // DispatchQueue.global(qos: .background).async {
                        CommonWebserviceClass.downloadImgFromServer(url:url!) { (DATA, RESPOSE, error) in
                            if DATA != nil {
                                DispatchQueue.main.async { // Correct
                                   
                                    img_rightView.image = UIImage(data: DATA!)
                                }
                            }else{
                               
                            }
                        }
                    }
                    // }
                    
                }
                
            
          }
        }
        
    }
*/
//    func tableView(_ tableView: UITableView, willcellForRowAt indexPath: IndexPath) -> UITableViewCell{
//
//    }
    func swapBackDataSendMethod(index: Int, swipDict: [String : AnyObject]) {
        // testQuestionArr[index]  = swipDict as AnyObject
        
        print(" swap dict print===\(swipDict) && index== \(index)")
        testQuestionArr[index]  = swipDict as AnyObject
       // testQuestionArr
        print("update array at index=\(index)")
        DispatchQueue.main.async {
            self.tbleView.reloadData()
        }
        
        
        
        
    }
    
    func editBtnClick(_ sender: UIButton){
        
        let sendDict = testQuestionArr[sender.tag] as? [String: AnyObject]
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let swapViewController  =  story.instantiateViewController(withIdentifier: "SwapViewController") as! SwapViewController
        swapViewController.getDict = sendDict
        swapViewController.getIndex = sender.tag
        /// swapViewController.getArticleDetailDict = getArtcleDict
        swapViewController.swapDelegateClass = self
        self.navigationController?.pushViewController(swapViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         let sendDict = testQuestionArr[indexPath.row] as? [String: AnyObject]
      
        let typeStr = sendDict!["type"] as! String
        if typeStr == "questions_matching" {
        
        print("didselect dict==\(sendDict)")
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let swapViewController  =  story.instantiateViewController(withIdentifier: "SwapViewController") as! SwapViewController
         swapViewController.getDict = sendDict
       
         swapViewController.getIndex = indexPath.row
       /// swapViewController.getArticleDetailDict = getArtcleDict
        swapViewController.swapDelegateClass = self
        self.navigationController?.pushViewController(swapViewController, animated: true)
        }
        */
    }
    
    @objc func buttonClicked(sender: UIButton!) {
//         let btn = sender
//        btn?.titleLabel?.textColor = UIColor.green
//        btn?.titleLabel?.text = "coo"
        cellTitle = sender
        dropDown?.anchorView = sender
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tbleView)
        let cellIndexPath = self.tbleView.indexPathForRow(at: pointInTable)
        print(cellIndexPath!.row)
        let dictTemp = testQuestionArr[cellIndexPath!.row] as? [String: AnyObject]
        let answrDict = dictTemp!["questions_rfib_correct_answer"] as! [String:AnyObject]
        let arrTemp =  answrDict["question_array"] as! [AnyObject]
        let qAdict =  arrTemp[sender.tag] as! [String: AnyObject]
         dropDown?.dataSource = qAdict["options"] as! [String]
         dropDown?.show()
//        var alertView = UIAlertView()
//        alertView.addButton(withTitle: "Ok")
//        alertView.title = "title"
//        alertView.message = "message ==\(sender.tag)"
//        alertView.show()
        
    }
    
    @objc func panGestureHandler1(panGesture recognizer: UIPanGestureRecognizer) {
       // let buttonTag = (recognizer.view?.tag)!
       // if let button = view.viewWithTag(buttonTag) as? UILabel {
        let translation = recognizer.translation(in: self.view)
           if let img_drag = recognizer.view as? UILabel{
            if recognizer.state == .began {
              //  wordButtonCenter = button.center // store old button center
                print("Cell Index==\(img_drag.tag)")
                dragCGPoint = img_drag.center
            } else if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
                print("Cell Index==end=\(img_drag.tag)")
                img_drag.center = dragCGPoint!
               // button.center = wordButtonCenter // restore button center
            } else {
               // let location = recognizer.location(in: view) // get pan location
              //  button.center = location // set button to where finger is
                      let translation = recognizer.translation(in: self.view)
                      // if let img_drag = recognizer.view as? UILabel{
                           img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
                       // }
            }
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
        
//        let translation = recognizer.translation(in: self.view)
//        if let img_drag = recognizer.view as? UIImageView{
//            img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    @objc func panGestureHandler(panGesture recognizer: UIPanGestureRecognizer) {
        let buttonTag = (recognizer.view?.tag)!
        
        if let img_drag = recognizer.view as? UILabel {
            
            if recognizer.state == .began {
                //  wordButtonCenter = button.center // store old button center
                 dragCGPoint = img_drag.center
            } else if recognizer.state == .ended || recognizer.state == .failed || recognizer.state == .cancelled {
                // button.center = wordButtonCenter // restore button center
                 img_drag.center = dragCGPoint!
            } else {
                let location = recognizer.location(in: view) // get pan location
                //  button.center = location // set button to where finger is
                let translation = recognizer.translation(in: self.view)
                // if let img_drag = recognizer.view as? UILabel{
                img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
              }
             recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
        
//        let translation = recognizer.translation(in: self.view)
//        if let img_drag = recognizer.view as? UIImageView{
//            img_drag.center = CGPoint(x: img_drag.center.x + translation.x, y: img_drag.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    func qmcPlayClick1(_ sender: UIButton){
        let indexBtn = sender.tag
        let getDICT = testQuestionArr[indexBtn] as? [String: AnyObject]
        let AUDIOuRL = getDICT!["audio_url"] as? String
       // MediaClass().playMPSongMethod(urlMp: "https://" + AUDIOuRL!)
         playMethod(urlMP: AUDIOuRL!)
    }
    func qmcPlayClick(_ sender: UIButton) {
        let indexBtn = sender.tag
        let getDICT = testQuestionArr[indexBtn] as? [String: AnyObject]
        let AUDIOuRL = getDICT!["audio_url"] as? String
         playMethod(urlMP: AUDIOuRL!)
       }
    
    func btn_sortPlayMethod(_ sender: UIButton) {
        let indexBtn = sender.tag
        let getDICT = testQuestionArr[indexBtn] as? [String: AnyObject]
        let AUDIOuRL = getDICT!["audio_url"] as? String
        playMethod(urlMP: AUDIOuRL!)
      }
    
   // btn_matchPlayMethod
    func btn_matchPlayMethod(_ sender: UIButton) {
        let indexBtn = sender.tag
        
        let getDICT = testQuestionArr[indexBtn] as? [String: AnyObject]
        let AUDIOuRL = getDICT!["audio_url"] as? String
        playMethod(urlMP: AUDIOuRL!)
    }
   
    
    func playMethod(urlMP: String){
        let urlMp3 = URL(string: "http://" + urlMP)
        player = AVPlayer(url: urlMp3!)
        player?.play()
       }
    
    func answerSeleckMethod(getAnwr: String, btnTag: Int) {
        
         var getDict = testQuestionArr[btnTag] as? [String: AnyObject]
        
        let qAnserDict = getDict?["questions_mc_correct_answer"] as? [String: AnyObject]
        // let qAnserStr = qAnserDict!["answer"] as? String
        getDict?["selectAns"] = getAnwr as AnyObject
       // let selectAnswer = getDict?["selectAns"] as? String
//        if getAnwr == qAnserStr {
//            getDict?["selectAns"] = getAnwr as AnyObject
//        }else {
//             getDict?["selectAns"] = "unselect" as AnyObject
//        }
        
        testQuestionArr[btnTag] = getDict as AnyObject
        DispatchQueue.main.async {
            self.tbleView.reloadData()
        }
      }
    
    
    func answerSeleckAllMethod(getAnwr: String, btnTag: Int) {
        if selectCellIndex == btnTag {
            let elements = multipleSelectArr
            if let object = elements.filter({ $0 as! String ==  getAnwr}).first {
                print("found")
            } else {
                print("not found")
                multipleSelectArr.append(getAnwr as AnyObject)
              }
           }else {
            selectCellIndex = btnTag
            multipleSelectArr.removeAll()
            multipleSelectArr.append(getAnwr as AnyObject)
             }
          var getDict = testQuestionArr[btnTag] as? [String: AnyObject]
          getDict?["selectAns"] = multipleSelectArr as AnyObject
          testQuestionArr[btnTag] = getDict as AnyObject
          DispatchQueue.main.async {
            self.tbleView.reloadData()
            }
     }
    
    func answerTrueFalseMethod(answr: String, indexTag: Int) {
        
        var getDict = testQuestionArr[indexTag] as? [String: AnyObject]
        let qAnserDict = getDict?["questions_mc_correct_answer"] as? [String: AnyObject]
        // let qAnserStr = qAnserDict!["answer"] as? String
        getDict?["selectAns"] = answr as AnyObject
        // let selectAnswer = getDict?["selectAns"] as? String
        //        if getAnwr == qAnserStr {
        //            getDict?["selectAns"] = getAnwr as AnyObject
        //        }else {
        //             getDict?["selectAns"] = "unselect" as AnyObject
        //        }
         testQuestionArr[indexTag] = getDict as AnyObject
        DispatchQueue.main.async {
            self.tbleView.reloadData()
            }
        
      }
    
    func sortSendIndexForReloadMethod(dataArr: [AnyObject], cellIndex: Int) {
        var getDICT = testQuestionArr[cellIndex] as? [String: AnyObject]
        var getSortDict = getDICT?["questions_sorting_correct_answer"]  as? [String: AnyObject]
      //  let getSortArr = getSortDict?["options_array"]  as? [AnyObject]
        getSortDict?["options_array"] = dataArr as AnyObject
        getDICT?["questions_sorting_correct_answer"] = getSortDict as AnyObject
        testQuestionArr[cellIndex] = getDICT as AnyObject
//        DispatchQueue.main.async {
//          self.tbleView.reloadData()
//         }
    }
    
    /// now i am working match question
    func matchAnsSendMethod(dragIndex: Int, dropIndex: Int, indexPathRow: Int) {
        var getDICT = testQuestionArr[indexPathRow] as? [String: AnyObject]
        var getSortDict = getDICT?["questions_matching_correct_answer"]  as? [String: AnyObject]
        var getSetsArr = getSortDict?["sets"] as? [AnyObject]
        
        var commonLeftDict = getSetsArr?[dragIndex] as? [String: AnyObject]
        var commonRightDict = getSetsArr?[dropIndex] as? [String: AnyObject]
        
        var leftDict = commonLeftDict?["left"] as? [String: AnyObject]
        var rightDict = commonRightDict?["right"] as? [String: AnyObject]
        
        let imgLeftTmp = leftDict?["image"] as? String
       
        rightDict?["image"] = imgLeftTmp as AnyObject//imgLeftTmp as AnyObject
        leftDict?["image"] = "" as AnyObject
        
      //  print("left image==\(leftDict)")
        commonLeftDict?["left"] = leftDict as AnyObject
        
      //  print("commonLeft==\(commonLeftDict)")
        commonRightDict?["right"] = rightDict as AnyObject
        
       // print("commonRight==\(commonRightDict)")
        
        getSetsArr?[dragIndex] = commonLeftDict as AnyObject
        
       // print("--Index=\(dragIndex)---\(getSetsArr)")
        getSetsArr?[dropIndex] = commonRightDict as AnyObject
        
      //  print("--***Index=\(dropIndex)***---\(getSetsArr)")
        getSortDict?["sets"] = getSetsArr as AnyObject
        getDICT?["questions_matching_correct_answer"] = getSortDict as AnyObject
        testQuestionArr[indexPathRow] =  getDICT as AnyObject
        DispatchQueue.main.async {
            self.tbleView.reloadData()
        }
       // print("Change Dict Print==\(testQuestionArr[indexPathRow])")
       // print("dragTag\(dragIndex) == dropTag==\(dropIndex)==indexCell==\(indexPathRow)")
    }
    func textFieldDidChange(_ textField:UITextField) {
        // your code here
         print("====change text value ==\(textField.tag)")
     }
    
    func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tbleView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
           }
    }
    func keyboardWillHide(_ notification:Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tbleView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
      }
    
    func dropDownBtnClickSender(answr: String, indexTag: Int) {
        
      }
    
    @IBAction func finishTestBtnClick(_ sender: UIButton) {
        
       }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
