//
//  CustomBottomBar.swift
//  StudiesWeekly
//
//  Created by Abha Parihar on 3/20/19.
//  Copyright © 2019 TekShapers. All rights reserved.
//

import UIKit

protocol CustomBottomBarDelegate:class
{
    func backBtnClicked()
    func nextBtnClicked()
    func copyBtnClicked()
    func searchBtnClicked()
    func playBtnClicked()
}

class CustomBottomBar: UIView
{
    weak var customBottomBarDelegate:CustomBottomBarDelegate?
    
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var btnNext : UIButton!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnPlay : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - UIButton Methods
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.customBottomBarDelegate?.backBtnClicked()
    }
    
    @IBAction func btnNextClicked(_ sender: UIButton)
    {
        self.customBottomBarDelegate?.nextBtnClicked()
    }

    @IBAction func btnCopyClicked(_ sender: UIButton)
    {
        self.customBottomBarDelegate?.copyBtnClicked()
    }

    @IBAction func btnSearchClicked(_ sender: UIButton)
    {
        self.customBottomBarDelegate?.searchBtnClicked()
    }

    @IBAction func btnPlayClicked(_ sender: UIButton)
    {
        self.customBottomBarDelegate?.playBtnClicked()
    }

}
