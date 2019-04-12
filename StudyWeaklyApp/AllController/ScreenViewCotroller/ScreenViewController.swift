//
//  ScreenViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 8/16/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class ScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ScreenCellDelegate
{
    @IBOutlet weak var lbl_select: UILabel!
    @IBOutlet weak var lbl_setting: UILabel!
    @IBOutlet weak var tblView_screen: UITableView!
    
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnPlay : UIButton!

    var dataScreenArr = [AnyObject]()
    
    //MARK: - UIView Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        //Bottom Bar
        btnBack.isEnabled = true
        btnNext.isEnabled = false
        btnCopy.isEnabled = true
        btnSearch.isEnabled = true
        btnPlay.isEnabled = false

        lbl_setting.backgroundColor =  CustomBGColor.selectBGColor
        
        var mediaStoreTimeArr = [String]()
        let dataFetch  =  CDBManager().getSearchMedia(getSearchDict: [:],searchKey: "AllFetch")
        var boolMatch:Bool = false
        for data1 in dataFetch
        {
            let dateCreateStr = data1["dateCreate"] as? String
            if !mediaStoreTimeArr.contains(dateCreateStr!)
            {
                mediaStoreTimeArr.append(dateCreateStr!)
            }
        }
        
        for data in mediaStoreTimeArr
        {
            let dateCreateStr = data
            var dateTimeSubArr = [AnyObject]()
            for i in 0..<dataFetch.count
            {
                let dateData = dataFetch[i] as! [String:AnyObject]
                let dateTime = dateData["dateCreate"] as! String
                // mediaStoreTimeArr.append(dateCreateStr!)
                if dateCreateStr == dateTime
                {
                    dateTimeSubArr.append(dateData as AnyObject)
                }
            }
            
            var mainDict = [String:AnyObject]()
            mainDict["dateCreate"] = dateCreateStr as AnyObject
            mainDict["dateAccArr"] = dateTimeSubArr as AnyObject
            dataScreenArr.append(mainDict as AnyObject)
        }
        dataScreenArr = Array(dataScreenArr.reversed())
        DispatchQueue.main.async {
            self.tblView_screen.reloadData()
        }
    }
    
    //MARK: - UIButton Method
    @IBAction func tabAsettingBtnClick(_ sender: UIButton)
    {
        lbl_select.backgroundColor = CustomBGColor.clearBGColor
        lbl_setting.backgroundColor = CustomBGColor.clearBGColor
        if sender.tag == 0
        {
            self.navigationController?.popViewController(animated: false)
        }
        else if sender.tag == 1
        {
             lbl_setting.backgroundColor =  CustomBGColor.selectBGColor
        }
    }
    
    func btnIndex(send:String)
    {
        print("cell index")
        dataScreenArr[Int(send)!] = "select" as AnyObject
        print(dataScreenArr)
        DispatchQueue.main.async {
            self.tblView_screen.reloadData()
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func fileBtnClick(_ sender: UIButton)
    {
        let tabViewController  =  self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.TabViewControllerID) as! TabViewController
        self.navigationController?.pushViewController(tabViewController, animated: true)
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton)
    {
        let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.SearchViewControllerID) as! SearchViewController
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
    
    @IBAction func homeBtnClick(_ sender: UIButton)
    {
        DispatchQueue.main.async {
            
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is HomeFileViewController {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        }
    }
    //MARK: - UITableView Method
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return dataScreenArr.count
     }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
       return 50
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dateAccTmp = dataScreenArr[section] as! [String:AnyObject]
        let dataArr = dateAccTmp["dateAccArr"] as! [AnyObject]
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: SearchCell! = tblView_screen.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell
        if cell == nil {
            tblView_screen.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
            cell = tblView_screen.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell
         }
        
        let dateAccTmp = dataScreenArr[indexPath.section] as! [String:AnyObject]
        let dataArr = dateAccTmp["dateAccArr"] as! [AnyObject]
        let getDictTmp = dataArr[indexPath.row]
        let titleStr = getDictTmp["media_name"] as? String
        
        cell.activity_cellView.isHidden = true
        cell.imgView_search.image = UIImage(named: "")
        cell.imgView_search.backgroundColor = UIColor.clear
        cell.lbl_searchTitle.text = "  " + titleStr!
       // let dataDict = mediaArr[indexPath.row] as? [String:AnyObject]
        let string = getDictTmp["media_source"] as? String ?? " "
        let downloadData = getDictTmp["download"] as? String
        
        if (string.range(of: ".mp4")) != nil
        {
            if downloadData == "download"
            {
                cell.imgView_search.image = UIImage(named: "video_selecetd.png")
            }
            else
            {
                cell.imgView_search.image = UIImage(named: "video.png")
            }
        }
        else if (string.range(of: ".mp3")) != nil
        {
            if downloadData == "download"
            {
                cell.imgView_search.image = UIImage(named: "music_icon_selected.png")
            }
            else
            {
                cell.imgView_search.image = UIImage(named: "music.png")
            }
        }
        else
        {
            if downloadData == "download"
            {
                cell.imgView_search.image = UIImage(named: "image_selected.png")
            }
            else
            {
                cell.imgView_search.image = UIImage(named: "image.png")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
         let dateAccTmp = dataScreenArr[section] as! [String:AnyObject]
        let dateCreateTitle = dateAccTmp["dateCreate"] as? String
        let dateTmp = DateModel().getCurrentDate(getStoreDate: dateCreateTitle!)
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
         headerView.backgroundColor = UIColor.lightGray
        let lbl_titleHeader = UILabel.init(frame: CGRect(x: 20, y: 0, width: headerView.frame.width - 20, height: 50))
        lbl_titleHeader.text = dateTmp
        headerView.addSubview(lbl_titleHeader)
        return headerView
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
