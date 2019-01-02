//
//  Q_sorting_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol SortDelegateClass:class {
    func sortSendIndexForReloadMethod(dataArr:[AnyObject],cellIndex:Int)
}
class Q_sorting_Cell: UITableViewCell {
    
   weak var sortDelegateClass:SortDelegateClass?
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lbl_qSortTitle: UILabel!
    
    @IBOutlet weak var btn_sortPlay: UIButton!
    
    var sortArr = [AnyObject]()
    var indexTag:Int = -1
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self as? UICollectionViewDelegate
        collectionView.dataSource = self as? UICollectionViewDataSource
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
      //  collectionView.dragInteractionEnabled = true
       // collectionView.drag
       // collectionView.reloadData()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
            }
    func sendCollectionMethod(getOptionArr: [AnyObject],index:Int){
          indexTag = index
         sortArr = getOptionArr
         collectionView.reloadData()
      }
   
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                return
            }
            self.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            self.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            self.collectionView.endInteractiveMovement()
            self.sortDelegateClass?.sortSendIndexForReloadMethod(dataArr: sortArr, cellIndex: indexTag)
           // self.collectionView.reloadData()
        default:
            self.collectionView.cancelInteractiveMovement()
        }
     }
}
extension Q_sorting_Cell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return sortArr.count
        
           }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionSortCell", for: indexPath) as! CollectionSortCell
        cell.lbl_collTitle.text = sortArr[indexPath.item] as? String
        
        return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
      }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Starting Index: \(sourceIndexPath.item)")
        let sourceDict = sortArr[sourceIndexPath.item] as AnyObject
        print("Ending Index: \(destinationIndexPath.item)")
        let desDict = sortArr[destinationIndexPath.item] as AnyObject
        sortArr[sourceIndexPath.item] = desDict
        sortArr[destinationIndexPath.item] = sourceDict
        collectionView.reloadData()
      }
    
    
}
