//
//  ViewController.swift
//  HabboPlayer
//
//  Created by Admin User on 5/16/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import DragDropiOS
import AVFoundation
import CZPicker

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,DragDropCollectionViewDelegate {
    @IBOutlet weak var dragDropCollectionView: DragDropCollectionView!
    var models:[Model] = [Model]()
    var dragDropManager:DragDropManager!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    
    @IBOutlet weak var con1: NSLayoutConstraint!
    @IBOutlet weak var con2: NSLayoutConstraint!
    @IBOutlet weak var con3: NSLayoutConstraint!
    @IBOutlet weak var con4: NSLayoutConstraint!
    let playBoxLength : Int = 80
    var sound : AVAudioPlayer!
    
    var sound1 : AVAudioPlayer!
    var sound2 : AVAudioPlayer!
    var sound3 : AVAudioPlayer!
    var sound4 : AVAudioPlayer!
    
    var isPlaying : Bool = false
    var indexPlaying : Int = 0
    
    var mTimer : Timer?

    var box1 : [DragDropView] = []
    var box2 : [DragDropView] = []
    var box3 : [DragDropView] = []
    var box4 : [DragDropView] = []
    
    var types = [String]()
    var typeImages = [UIImage]()
    var pickerView1: CZPickerView?
    var pickerView2: CZPickerView?
    var pickerView3: CZPickerView?
    var pickerView4: CZPickerView?

    
    var views : [UIView] = []
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        for i in 0 ..< 4*playBoxLength {
            let model = Model()
            model.index = i
            models.append(model)
        }
        let screenSize: CGRect = UIScreen.main.bounds
        let h1 = screenSize.height/2 - 10 - 20
        let h2 = (screenSize.width - 20*5) / 4
        let height = min(h1, h2)
        
        con1.constant = height
        con2.constant = height
        con3.constant = height
        con4.constant = height
        
        views.append(dragDropCollectionView)
        
        
        for j in 0 ..< 4 {
            for i in 0 ..< 9 {
                
                let view = DragDropView()
                view.backgroundColor = UIColor.clear
                let width = (height - 12) / 3
                let ii = CGFloat(i%3)
                let jj = CGFloat(i/3)
                view.frame = CGRect(x: (3 + width)*ii + 3, y: (3 + width)*jj + 3, width:width, height:width)
                view.initImageFrame(width:width)


                let path = String(format: "sounds/sounds%d/%d_%d", j+1, j+1, i+1)
                let mp3file = Bundle.main.path(forResource: path, ofType: "wav")
                let url = URL(fileURLWithPath: mp3file!)
                let asset = AVURLAsset(url: url, options: nil)
                let audioDuration = asset.duration
                let audioDurationSeconds = Int(CMTimeGetSeconds(audioDuration))

                let name = String(format: "img%d_%d",j+1, i+1)
                let textname = String(format: "%d", i+1)
                view.model.imageName = name
                view.model.text = textname
                view.model.index = i
                view.model.package = j+1
                view.model.length = audioDurationSeconds/2
                view.model.currentPos = 0
                view.model.isSelectable = true
                view.initImage()
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
                view.addGestureRecognizer(gesture)
                switch j {
                case 0:
                    viewOne.addSubview(view)
                case 1:
                    viewTwo.addSubview(view)
                case 2:
                    viewThree.addSubview(view)
                case 3: 
                    viewFour.addSubview(view)
                default: break
                }

                views.append(view)
            }
        }
        types = ["Grape", "Banana", "Apple", "Peach", "Lychee", "Strawberry", "Mango", "Watermelon"]
        typeImages = [UIImage(named: "img1_1")!, UIImage(named: "img2_1")!, UIImage(named: "img3_1")!, UIImage(named: "img4_1")!, UIImage(named: "img5_1")!, UIImage(named: "img6_1")!, UIImage(named: "img7_1")!, UIImage(named: "img8_1")!]
        self.title = "CZPicker"

        dragDropCollectionView.backgroundColor = UIColor.white
        dragDropCollectionView.bounces = false
        dragDropCollectionView.dragDropDelegate = self
        
        dragDropManager = DragDropManager(canvas: self.view, views: views)
    }
    
    func someAction(_ sender:UITapGestureRecognizer){
        // do other task
        let view = sender.view as! DragDropView
        let num = Int(view.model.text!)!
        let packagenum = view.model.package

        let path = String(format: "sounds/sounds%d/%d_%d",packagenum!, packagenum!, num)
        let mp3file = Bundle.main.path(forResource: path, ofType: "wav")
        let url = URL(fileURLWithPath: mp3file!)
        
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            
            if let audioPlayerUW = sound {
                audioPlayerUW.play()
            }
        } catch {
            // couldn't load file :(
            print("Error")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        //let tSize = collectionView.contentSize

        let screenSize: CGRect = UIScreen.main.bounds
        let cellSize = (screenSize.height*0.4 - 12) / 4
        //let cellSize = (tSize.height-12) / 4
        return CGSize.init(width: cellSize, height:cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        sound1 = nil
        sound2 = nil
        sound3 = nil
        sound4 = nil
        
        let customIndexPath = IndexPath(row: indexPath.item, section: indexPath.section)
        let cell = collectionView.cellForItem(at: customIndexPath) as! CollectionViewCell
        if cell.model.currentPos == 0 {
            for i in 0 ..< Int(cell.model.length!) {
                models[indexPath.item+i*4].text = nil
                models[indexPath.item+i*4].imageName = nil
                models[indexPath.item+i*4].package = nil
                models[indexPath.item+i*4].length = nil
                models[indexPath.item+i*4].isSelectable = nil
                models[indexPath.item+i*4].currentPos = nil

            }
        } else {
            indexPlaying = (indexPath.item/4)*200
        }
        
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var model : Model

        model = models[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.IDENTIFIER, for: indexPath) as! CollectionViewCell
        
        cell.updateData(model)

        let colnum = indexPlaying / 200
        if indexPath.item >= colnum*4 && indexPath.item <= colnum*4+3 {
            cell.playingStatus()
        }
        return cell
    }
    
    // MARK : DragDropCollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, touchBeginAtIndexPath indexPath: IndexPath) {
        clearCellsDrogStatus()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, representationImageAtIndexPath indexPath: IndexPath) -> UIImage? {
        
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0)
            cell.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
        
        return nil
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canDragAtIndexPath indexPath: IndexPath) -> Bool {
        
        return models[indexPath.item].text != nil
        
    }
    func collectionView(_ collectionView: UICollectionView, dragInfoForIndexPath indexPath: IndexPath) -> AnyObject {
        let dragInfo = Model()
        dragInfo.index = indexPath.item
        dragInfo.text = models[indexPath.item].text
        dragInfo.imageName = models[indexPath.item].imageName
        dragInfo.package = models[indexPath.item].package
        dragInfo.currentPos = models[indexPath.item].currentPos
        dragInfo.isSelectable = models[indexPath.item].isSelectable
        dragInfo.length = models[indexPath.item].length
        
        return dragInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, canDropWithDragInfo dataItem: AnyObject, AtIndexPath indexPath: IndexPath) -> Bool {
        var max = 0
        for index in collectionView.indexPathsForVisibleItems {
            if max < index.last! {
                max = index.last!
            }
        }
        
        clearCellsDrogStatus()
        let dragInfo = dataItem as! Model
        if(!dragInfo.isSelectable!) {
            return false
        }
        let total = Int(dragInfo.length!)
        if indexPath.row + 4*(total-1) >= 4*playBoxLength {
            return false
        }
        
        //collectionView.setContentOffset(collectionView.contentOffset, animated:false)

        for i in 1..<total {
            if(models[indexPath.row+4*i].text != nil) {
                return false
            }
            
        }
        debugPrint("can drop in . index = \(indexPath.item)")
        
        let overInfo = models[indexPath.item]
        
        debugPrint("move over index: \(indexPath.item)")
        
        //drag source is mouse over item（self）
        if indexPath.item == dragInfo.index && dragInfo.text == overInfo.text {
            return false
        }
        
        clearCellsDrogStatus()
        
        for cell in collectionView.visibleCells{
            
            //update move over cell status
            if overInfo.index == (cell as! CollectionViewCell).model.index {
                
                if overInfo.text == nil {
                    var cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
                    cell.moveOverStatus()

                    let total = Int(dragInfo.length!)
                    for i in 1..<total {
                        
                        if(indexPath.row + 4*i > max) {
                            //clearCellsDrogStatus()
                            //return false
                        }else {
                            let customIndexPath = IndexPath(row: indexPath.row + 4*i, section: indexPath.section)
                            
                            cell = collectionView.cellForItem(at: customIndexPath) as! CollectionViewCell
                            cell.moveOverStatus()
                        }
                        
                    }
                    debugPrint("can drop in . index = \(indexPath.item)")
                    
                    return true
                }else{
                    debugPrint("can't drop in. index = \(indexPath.item)")
                }
                
            }
            
        }
        
        return false
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropOutsideWithDragInfo info: AnyObject) {
        clearCellsDrogStatus()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, dragCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath,withDropInfo dropInfo:AnyObject?) -> Void{
        if (dropInfo != nil){
            let len = models[dragIndexPath.item].length!
            for i in 0..<len {
                models[dragIndexPath.item+i*4].text = (dropInfo as! Model).text
                models[dragIndexPath.item+i*4].imageName = (dropInfo as! Model).imageName
                models[dragIndexPath.item+i*4].package = (dropInfo as! Model).package
                models[dragIndexPath.item+i*4].length = (dropInfo as! Model).length
                models[dragIndexPath.item+i*4].isSelectable = (dropInfo as! Model).isSelectable
                models[dragIndexPath.item+i*4].currentPos = (dropInfo as! Model).currentPos
            }
            
        }else{
            let len = models[dragIndexPath.item].length!
            
            for i in 0..<len {
                models[dragIndexPath.item+i*4].text = nil
                models[dragIndexPath.item+i*4].imageName = nil
                models[dragIndexPath.item+i*4].package = nil
                models[dragIndexPath.item+i*4].length = nil
                models[dragIndexPath.item+i*4].isSelectable = nil
                models[dragIndexPath.item+i*4].currentPos = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropCompleteWithDragInfo dragInfo:AnyObject, atDragIndexPath dragIndexPath: IndexPath?,withDropInfo dropInfo:AnyObject?,atDropIndexPath dropIndexPath:IndexPath) -> Void{
        
        models[dropIndexPath.item].text = (dragInfo as! Model).text
        models[dropIndexPath.item].imageName = (dragInfo as! Model).imageName
        models[dropIndexPath.item].package = (dragInfo as! Model).package
        models[dropIndexPath.item].length = (dragInfo as! Model).length
        models[dropIndexPath.item].isSelectable = (dragInfo as! Model).isSelectable
        models[dropIndexPath.item].currentPos = (dragInfo as! Model).currentPos
        
        let len = Int(models[dropIndexPath.item].length!)
        for i in 1..<len {
            models[dropIndexPath.item+4*i].text = (dragInfo as! Model).text
            models[dropIndexPath.item+4*i].imageName = (dragInfo as! Model).imageName
            models[dropIndexPath.item+4*i].package = (dragInfo as! Model).package
            models[dropIndexPath.item+4*i].length = (dragInfo as! Model).length
            models[dropIndexPath.item+4*i].isSelectable = false
            models[dropIndexPath.item+4*i].currentPos = i
        }
    }
    
    
    func collectionViewStopDropping(_ collectionView: UICollectionView) {
        
        clearCellsDrogStatus()
        
        collectionView.reloadData()
    }
    
    func collectionViewStopDragging(_ collectionView: UICollectionView) {
        
        clearCellsDrogStatus()
        
        collectionView.reloadData()
        
    }
    
    
    func clearCellsDrogStatus(){
        
        for cell in dragDropCollectionView.visibleCells{
            
            if (cell as! CollectionViewCell).hasContent() {
                (cell as! CollectionViewCell).selectedStatus()
                continue
            }
            
            (cell as! CollectionViewCell).nomoralStatus()
            
            
        }
        
    }
    
    @IBAction func onPlayPause(_ sender: UIButton) {
        isPlaying = !isPlaying
        if(isPlaying) {
            sound = nil
            mTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateDisplay), userInfo: nil, repeats: true)
            mTimer?.fire()
            sender.setTitle("Pause", for: UIControlState.normal)
        } else {
            mTimer?.invalidate()
            mTimer = nil
            updateDisplay()
            sender.setTitle("Play", for: UIControlState.normal)
        }
    }
    
    func updateDisplay() {
        clearCellsDrogStatus()
        var colnum = indexPlaying / 200
        if colnum >= 80 {
            indexPlaying = 0
            colnum = 0
            let currentRect : CGRect = CGRect(x: 0, y: dragDropCollectionView.contentOffset.y, width: dragDropCollectionView.bounds.size.width, height: dragDropCollectionView.bounds.size.height)
            
            dragDropCollectionView.scrollRectToVisible(currentRect, animated: false)
            return
        }
        
        var max = 0, min = 1000
        for index in dragDropCollectionView.indexPathsForVisibleItems {
            if max < index.last! {
                max = index.last!
            }
            if min > index.last! {
                min = index.last!
            }
        }
 
        if(colnum*4 >= max) {
            var currentRect : CGRect = CGRect(x: dragDropCollectionView.contentOffset.x, y: dragDropCollectionView.contentOffset.y, width: dragDropCollectionView.bounds.size.width, height: dragDropCollectionView.bounds.size.height)
            currentRect.origin.x = currentRect.origin.x + currentRect.width/4*3
            
            dragDropCollectionView.scrollRectToVisible(currentRect, animated: false)
            return
        }
        
        if(colnum*4 < min) {
            var currentRect : CGRect = CGRect(x: dragDropCollectionView.contentOffset.x, y: dragDropCollectionView.contentOffset.y, width: dragDropCollectionView.bounds.size.width, height: dragDropCollectionView.bounds.size.height)
            currentRect.origin.x = currentRect.origin.x - currentRect.width/4*3
            
            dragDropCollectionView.scrollRectToVisible(currentRect, animated: false)
            return
        }
        for i in 0..<4 {
            let customIndexPath = IndexPath(row: colnum*4 + i, section: 0)
            
            let cell = dragDropCollectionView.cellForItem(at: customIndexPath) as! CollectionViewCell
            cell.playingStatus()
        }
        
        if indexPlaying % 200 == 0 {
            for i in 0..<4 {
                let customIndexPath = IndexPath(row: colnum*4+i, section: 0)
                let cell = dragDropCollectionView.cellForItem(at: customIndexPath) as! CollectionViewCell
                if cell.model.text == nil {
                    switch i {
                    case 0: sound1 = nil
                    case 1: sound2 = nil
                    case 2: sound3 = nil
                    case 3: sound4 = nil
                    default: break
                    }
                }
                
                if cell.model.currentPos == 0 {
                    let num = Int(cell.model.text!)!
                    let packagenum = cell.model.package
                    
                    let path = String(format: "sounds/sounds%d/%d_%d",packagenum!, packagenum!, num)
                    let mp3file = Bundle.main.path(forResource: path, ofType: "wav")
                    let url = URL(fileURLWithPath: mp3file!)
                    
                    do {
                        switch i {
                        case 0: sound1 = try AVAudioPlayer(contentsOf: url)
                        case 1: sound2 = try AVAudioPlayer(contentsOf: url)
                        case 2: sound3 = try AVAudioPlayer(contentsOf: url)
                        case 3: sound4 = try AVAudioPlayer(contentsOf: url)
                        default: break
                        }
                    } catch {
                        // couldn't load file :(
                        print("Error")
                    }
                }
            }
            
        }
        if isPlaying {
            if sound1 != nil {sound1.play()}
            if sound2 != nil {sound2.play()}
            if sound3 != nil {sound3.play()}
            if sound4 != nil {sound4.play()}
            
        } else {
            if sound1 != nil {sound1.pause()}
            if sound2 != nil {sound2.pause()}
            if sound3 != nil {sound3.pause()}
            if sound4 != nil {sound4.pause()}
        }
        if isPlaying {
            indexPlaying = indexPlaying + 1
        }
       
    }
    
    @IBAction func onType1(_ sender: UIButton) {
        pickerView1 = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        pickerView1?.delegate = self
        pickerView1?.dataSource = self
        pickerView1?.needFooterView = false
        pickerView1?.show()

    }

    @IBAction func onType2(_ sender: UIButton) {
        pickerView2 = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        pickerView2?.delegate = self
        pickerView2?.dataSource = self
        pickerView2?.needFooterView = false
        pickerView2?.show()
    }
    
    @IBAction func onType3(_ sender: UIButton) {
        pickerView3 = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        pickerView3?.delegate = self
        pickerView3?.dataSource = self
        pickerView3?.needFooterView = false
        pickerView3?.show()
    }
    
    @IBAction func onType4(_ sender: UIButton) {
        pickerView4 = CZPickerView(headerTitle: "Fruits", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        pickerView4?.delegate = self
        pickerView4?.dataSource = self
        pickerView4?.needFooterView = false
        pickerView4?.show()
    }
    
    func initMusicSet(numDest:Int, numSrc:Int) {
        var views : UIView
        switch(numDest) {
        case 0: views = viewOne
        case 1: views = viewTwo
        case 2: views = viewThree
        case 3: views = viewFour
        default: views = UIView()
        }
        
        var index : Int = -1
        for case let view as DragDropView in views.subviews {
            index = index + 1
            let path = String(format: "sounds/sounds%d/%d_%d", numSrc, numSrc, index+1)
            let mp3file = Bundle.main.path(forResource: path, ofType: "wav")
            let url = URL(fileURLWithPath: mp3file!)
            let asset = AVURLAsset(url: url, options: nil)
            let audioDuration = asset.duration
            let audioDurationSeconds = Int(CMTimeGetSeconds(audioDuration))
            
            let name = String(format: "img%d_%d",numSrc, index+1)
            let textname = String(format: "%d", index+1)
            view.model.imageName = name
            view.model.text = textname
            view.model.index = index+1
            view.model.package = numSrc
            view.model.length = audioDurationSeconds/2
            view.model.currentPos = 0
            view.model.isSelectable = true
            view.initImage()
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
            view.addGestureRecognizer(gesture)
        }
    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

extension ViewController: CZPickerViewDelegate, CZPickerViewDataSource {
    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
        return typeImages[row]
    }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return types.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return types[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        if pickerView == pickerView1 {
            initMusicSet(numDest: 0, numSrc: row + 1)
        } else if pickerView == pickerView2 {
            initMusicSet(numDest: 1, numSrc: row + 1)
        } else if pickerView == pickerView3 {
            initMusicSet(numDest: 2, numSrc: row + 1)
        } else if pickerView == pickerView4 {
            initMusicSet(numDest: 3, numSrc: row + 1)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /*func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        for row in rows {
            if let row = row as? Int {
                print(types[row])
            }
        }
    }*/
}


