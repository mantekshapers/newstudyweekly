//
//  HomeFileViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import Retrolux
class HomeFileViewController: UIViewController {
    
    
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgView: UIImageView!
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        img_profile = circularImage.isCircularImg(imgView: img_profile)
        collectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
   override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(true)
        
        NetworkAPI.getUser(Query("1195643")).enqueue { (response) in
            if response.httpUrlResponse == 200 {
                
                
            }
            if response.isSuccessful, let user = response.body?.success {
                //user.password = password
                // write([user], using: try! Realm())
                //callback(user, nil)
                 print("success message")
            } else {
                //                                Flurry.logEvent("Error getting user info", withParameters: ["Retrolux Error": response.error ?? "", "Server Data": response.dataString ?? ""])
                //                                debug("Unable to get user info", tag: "ERROR")
                //callback(nil, response.error)
                print("error message")
            }
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
              }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
          case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
          case .ended:
            collectionView.endInteractiveMovement()
          default:
            collectionView.cancelInteractiveMovement()
          }
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
