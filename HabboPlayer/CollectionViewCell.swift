//
//  CollectionViewCell.swift
//  HabboPlayer
//
//  Created by Admin User on 5/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let IDENTIFIER = "COLLECTION_VIEW_CELL"
    
    @IBOutlet weak var imageView: UIImageView!
    
    var model:Model!
    
    override func awakeFromNib() {
        backgroundColor = UIColor.white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
    func updateData(_ model:Model){
        self.model = model
        if model.text != nil {
            selectedStatus()
            imageView.image = UIImage(named: model.imageName!)
        }else{
            nomoralStatus()
            imageView.image = nil
        }
    }
    
    func hasContent() -> Bool {
        return model.text != nil
    }
    
    func playingPosition(){
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 2
    }
    
    func notPlayingPosition(){
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
    func moveOverStatus(){
        notPlayingPosition()
        backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    func nomoralStatus(){
        notPlayingPosition()
        backgroundColor = UIColor.white
    }
    
    func selectedStatus(){
        notPlayingPosition()
        backgroundColor = UIColor.blue.withAlphaComponent(0.5)
    }
    
    func playingStatus(){
        playingPosition()
        layer.borderColor = UIColor.blue.cgColor
    }
    

}
