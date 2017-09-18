//
//  AGArtistSubjectView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-28.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistSubjectView: UIView {

    
    let margin_gap = CGFloat(22)
    let middle_gap = CGFloat(30)
    let top_gap = CGFloat(12)
    let itemHeight = CGFloat(35)
    
    var dataList = [AGSubject]()
    
    var views: [AGArtistFieldItemView] = [AGArtistFieldItemView]()
    
    convenience init(frame: CGRect, list: [AGSubject]){
        
        self.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.dataList = list
        
        var nameList = [String]()
        for element in list{
            nameList.append(element.subjectName)
        }
        
        setupSubView(list: nameList)
        
        let remainder = list.count % 2
        var quotient = list.count / 2
        if remainder != 0{
            quotient = quotient + 1
        }
        
        let suitableH = CGFloat( quotient ) * (top_gap + itemHeight) + top_gap * 2 + 20
        
        self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: suitableH)
        
        
    }
    
    func setupSubView(list: [String]){
        // set up title -- SUBJECTS
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 9, width: GlobalValue.SCREENBOUND.width, height: 18))
        titleLabel.font = UIFont.init(name: "OpenSans-Bold" , size: 13)
        titleLabel.text = String.localizedString("AGArtistFieldSelctVC-subject")
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        let itemWidth = (GlobalValue.SCREENBOUND.width - margin_gap * 2 - middle_gap ) / 2

        for i in 0..<list.count{
            let remainder = i % 2
            let quotient = i / 2
            let x_offset = CGFloat((middle_gap + itemWidth) * CGFloat(remainder) + margin_gap)
            let y_offset = CGFloat( ( CGFloat(quotient) * (top_gap + itemHeight) + top_gap))
            
            let fieldItem = AGArtistFieldItemView.init(frame: CGRect.init(x: x_offset, y: y_offset + titleLabel.bottom, width: itemWidth, height: itemHeight), title: list[i])
            self.addSubview(fieldItem)
            self.views.append(fieldItem)
        }
        
    }
    
    func summary() -> [String]{
        var selected = [String]()
        for view in self.views{
            if view.isSelected{
                selected.append(view.title)
            }
        }
        
        return selected
        
    }
    
    // 随机产生 选择
    func randomDistribution(){
        let num = Int( arc4random()) % self.dataList.count
        let list = [self.dataList[num]]
        self.setSelectedList(list: list)
    }
    
    func setSelectedList(list: [AGSubject]){
        for view in self.views{
            view.isSelected = false
        }
        for target in list{
            for element in self.dataList{
                if element.isEqual(object: target){
                    let view = self.views[self.dataList.index(of: element)!]
                    view.isSelected = true
                }
            }
        }
    }
    
    func getSelectedList()-> [Int]{
        var selected = [Int]()
        for view in self.views{
            if view.isSelected{
                let subject = self.dataList[self.views.index(of: view)!]
                selected.append(subject.subjectId)
            }
        }
        return selected
        
    }

}
