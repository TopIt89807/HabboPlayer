//
//  DragDropView.swift
//  HabboPlayer
//
//  Created by Admin User on 5/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import DragDropiOS

class DragDropView: UIView,Draggable,Droppable{
    
    var label:UILabel!
    var image:UIImageView!
    
    var model:Model!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = UIImageView()
        model = Model()
        self.addSubview(image)
    }
    
    func initImageFrame(width : CGFloat) {
        image.frame = CGRect(x:0, y:0, width:width, height:width)
    }
    
    func initImage() {
        image.image = UIImage(named : model.imageName!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK : Status
    func moveOverStatus(){
        backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    func nomoralStatus(){
        backgroundColor = UIColor.white
    }
    
    func selectedStatus(){
        backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
    
    
    // MARK : Draggable
    func touchBeginAtPoint(_ point : CGPoint) -> Void {
        //clear drag status
        if model != nil {
            selectedStatus()
        }else{
            nomoralStatus()
        }
        
    }
    
    func canDragAtPoint(_ point : CGPoint) -> Bool {
        
        return model != nil
    }
    
    func representationImageAtPoint(_ point : CGPoint) -> UIView? {
        
        var imageView : UIView?
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView = UIImageView(image: img)
        imageView?.frame = CGRect(origin: CGPoint.zero, size: self.bounds.size)
        
        return imageView
    }
    
    func dragInfoAtPoint(_ point : CGPoint) -> AnyObject? {
        return model
    }
    
    
    func dragComplete(_ dragInfo:AnyObject,dropInfo : AnyObject?) -> Void {
        //model = nil
        //label.text = ""
    }
    
    func stopDragging() -> Void {
        nomoralStatus()
    }
    
    
    // MARK : Droppable
    
    func canDropWithDragInfo(_ dragInfo: AnyObject,  inRect rect: CGRect) -> Bool {
        
        if model == nil {
            moveOverStatus()
        }else{
            nomoralStatus()
        }
        return model == nil
    }
    
    func dropOverInfoInRect(_ rect: CGRect) -> AnyObject? {
        
        debugPrint("View：dropOverInfoInRect：\(rect.origin.x),\(rect.origin.y)_|\(rect.width),\(rect.height)")
        return model
    }
    
    func dropOutside(_ dragInfo: AnyObject, inRect rect: CGRect) {
        nomoralStatus()
    }
    
    func dropComplete(_ dragInfo : AnyObject,dropInfo:AnyObject?, atRect rect: CGRect) -> Void{
        model = dragInfo as! Model
        //label.text = model?.text
        image.image = UIImage(named:model.imageName!)
    }
    
    func stopDropping() {
        nomoralStatus()
    }
    
    
}
