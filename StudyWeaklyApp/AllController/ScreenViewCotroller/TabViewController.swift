//
//  TabViewController.swift
//  StudiesWeekly
//
//  Created by Man Singh on 12/24/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class TabViewController: UIViewController
{
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnPlay : UIButton!

    //Mark: - UIView Life Cycle
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
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    //MARK: - UIButton Method
    @IBAction func addNewTabBtnClick(_ sender: UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func tabBtnClick(_ sender: UIButton)
    {
    }
    
    @IBAction func historyBtnClick(_ sender: UIButton)
    {
        let screenViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.ScreenViewControllerID) as! ScreenViewController
        self.navigationController?.pushViewController(screenViewController, animated: false)
      }
    
    //MARK: - UIButton Method
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
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
