//
//  Q_match_Cell.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol QuestionMatchingDelegate:class {
    func matchAnsSendMethod(dragIndex:Int,dropIndex:Int,indexPathRow:Int)
}
class Q_match_Cell: UITableViewCell {
    weak var questionMatchingDelegate:QuestionMatchingDelegate?
    
    @IBOutlet weak var btn_matchPlay: UIButton!
    @IBOutlet weak var lbl_matchQTitle: UILabel!
    
    @IBOutlet weak var view_drag1: UIView!
    
    @IBOutlet weak var view_drag2: UIView!
    
    @IBOutlet weak var view_drag3: UIView!
    
    @IBOutlet weak var view_drop1: UIView!
    
    @IBOutlet weak var img_dropOnView: UIImageView!
    
    @IBOutlet weak var lbl_matchTitle1: UILabel!
    
    @IBOutlet weak var view_drop2: UIView!
    
    @IBOutlet weak var img_drop1OnView: UIImageView!
    
    @IBOutlet weak var lbl_matchTitle2: UILabel!
    
    @IBOutlet weak var view_drop3: UIView!
    
    
    @IBOutlet weak var img_drop2OnView: UIImageView!
    @IBOutlet weak var lbl_matchTitle: UILabel!
    
    var dragCGPoint: CGPoint?
    var commonCellIndex:Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func gestureAddOnAnyViewMethod(view:AnyObject,cellIndex:Int){
        commonCellIndex = cellIndex
          let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action: #selector(draggedView))
        if let lbl = view as? UILabel {
             lbl.addGestureRecognizer(panRec)
        }else if let img = view as? UIImageView{
              img.addGestureRecognizer(panRec)
         }
       
        
    }
    
    
    @objc func draggedView(sender:UIPanGestureRecognizer){
        print("panning")
        
        let translation = sender.translation(in: self)
       // print("the translation x:\(translation.x) & y:\(translation.y)")
        if let img_drag = sender.view as? UIImageView {
            if sender.state == .began {
                //  wordButtonCenter = button.center // store old button center
                dragCGPoint = img_drag.center
            }else if sender.state == .changed{
                
            } else if sender.state == .ended{
               // img_drag.center = dragCGPoint!
            } else if sender.state == .failed || sender.state == .cancelled {
                // button.center = wordButtonCenter // restore button center
               // img_drag.center = dragCGPoint!
            }
            //sender.view.
            var tmp=sender.view?.center.x  //x translation
            var tmp1=sender.view?.center.y //y translation
            print("x....=\(tmp) && y....=\(tmp1)")
            //set limitation for x and y origin
//            if(translation.x <= 100 && translation.y <= 50 )
//             {
                sender.view?.center = CGPoint(x: tmp!+translation.x, y: tmp1!+translation.y)
                if Int(tmp!) > 100 && Int(tmp!) < 200 && Int(tmp1!) > 50 && Int(tmp1!) < 130 {
                    let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                    sender.view?.center = newPos
                    sender.view?.center = view_drop1.center
                    sender.view?.bringSubview(toFront: view_drop1)
                   // view_drop1.addSubview(sender.view!)
                    questionMatchingDelegate?.matchAnsSendMethod(dragIndex: img_drag.tag, dropIndex: 0, indexPathRow: commonCellIndex)
                }else if Int(tmp!) > 100 && Int(tmp!) < 200 && Int(tmp1!) > 210 && Int(tmp1!) < 280 {
                    let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                    sender.view?.center = newPos
                    sender.view?.center = view_drop2.center
                    //view_drop2.addSubview(sender.view!)
                     sender.view?.bringSubview(toFront: view_drop2)
                      questionMatchingDelegate?.matchAnsSendMethod(dragIndex: img_drag.tag, dropIndex: 1, indexPathRow: commonCellIndex)
                }else if Int(tmp!) > 100 && Int(tmp!) < 200 && Int(tmp1!) > 320 && Int(tmp1!) < 380 {
                    let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                    sender.view?.center = newPos
                    sender.view?.center = view_drop3.center
                   // view_drop3.addSubview(sender.view!)
                     sender.view?.bringSubview(toFront: view_drop3)
                    questionMatchingDelegate?.matchAnsSendMethod(dragIndex: img_drag.tag, dropIndex: 2, indexPathRow: commonCellIndex)
                }
                
                // sender.setTranslation(CGPoint.zero, in: self.view)
           // }
            /*else if translation.x >= 100 && translation.x <= 240 && translation.y > 50 &&  translation.y <= 200 {
             // sender.view?.center = view_drop.center
             // view_drop.center = CGPoint(x: tmp!+translation.x, y: tmp1!+translation.y)
             // sender.setTranslation(CGPoint.zero, in: self.view)
             // imgView?.center  = view_drop.center
             }*/
            
            /*
             // let translation = recognizer.translationInView(self)
             let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
             
             if  insideDraggableArea(point: newPos) {
             sender.view?.center =  newPos
             sender.view?.center = view_drop.center
             // view_drop.addSubview(sender.view!)
             //  sender.setTranslation(CGPoint.zero, in: self.view)
             }
             */
            sender.setTranslation(CGPoint.zero, in: self)
        }else if let lbl_drag = sender.view as? UILabel{
            //sender.view.
            var tmp=sender.view?.center.x  //x translation
            var tmp1=sender.view?.center.y //y translation
            print("x....=\(tmp) && y....=\(tmp1)")
            //set limitation for x and y origin
            //            if(translation.x <= 100 && translation.y <= 50 )
            //             {
            sender.view?.center = CGPoint(x: tmp!+translation.x, y: tmp1!+translation.y)
            if Int(tmp!) > 100 && Int(tmp!) < 200 && Int(tmp1!) > 50 && Int(tmp1!) < 130 {
                let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                sender.view?.center = newPos
                sender.view?.center = view_drop1.center
                sender.view?.bringSubview(toFront: view_drop1)
                questionMatchingDelegate?.matchAnsSendMethod(dragIndex: lbl_drag.tag, dropIndex: 0, indexPathRow: commonCellIndex)
                // view_drop1.addSubview(sender.view!)
            }else if Int(tmp!) > 100 && Int(tmp!) < 200 && Int(tmp1!) > 210 && Int(tmp1!) < 280 {
                let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                sender.view?.center = newPos
                sender.view?.center = view_drop2.center
                //view_drop2.addSubview(sender.view!)
                sender.view?.bringSubview(toFront: view_drop2)
                questionMatchingDelegate?.matchAnsSendMethod(dragIndex: lbl_drag.tag, dropIndex: 1, indexPathRow: commonCellIndex)
            }else if Int(tmp!) > 100 && Int(tmp!) < 200 && Int(tmp1!) > 320 && Int(tmp1!) < 380 {
                let newPos = CGPoint(x:sender.view!.center.x + translation.x, y:sender.view!.center.y + translation.y)
                sender.view?.center = newPos
                sender.view?.center = view_drop3.center
                // view_drop3.addSubview(sender.view!)
                sender.view?.bringSubview(toFront: view_drop3)
                questionMatchingDelegate?.matchAnsSendMethod(dragIndex: lbl_drag.tag, dropIndex: 2, indexPathRow: commonCellIndex)
            }
             sender.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    
    
    
}
