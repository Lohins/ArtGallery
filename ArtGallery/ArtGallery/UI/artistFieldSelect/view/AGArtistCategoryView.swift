//
//  AGArtistCategoryView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-28.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGArtistCategoryView: UIView {
    
    let margin_gap = CGFloat(22)
    let middle_gap = CGFloat(15)
    let top_gap = CGFloat(10)
    let itemHeight = CGFloat(35)
    
    var titleLabel: UILabel!
    
    var title: String = ""
    
    var views:[AGArtistFieldItemView] = [AGArtistFieldItemView]()
    
    var dataList = [AGTag]()
    
    convenience init(frame: CGRect, list: [AGTag] , title: String){
        
        self.init(frame: frame)
        
        self.title = title
        
        self.backgroundColor = UIColor.clear
        
        self.dataList = list
        
        var nameList = [String]()
        for element in list{
            nameList.append(element.tagName)
        }
        
        setupSubView(list: nameList , title: title)
        
        let remainder = list.count % 3
        var quotient = list.count / 3
        if remainder != 0{
            quotient = quotient + 1
        }
        
        let suitableH = CGFloat( quotient ) * (top_gap + itemHeight) + top_gap + self.titleLabel.bottom
        
        self.frame = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: suitableH)
    }
    
    func setupSubView(list: [String] , title: String){
        let itemWidth = ( GlobalValue.SCREENBOUND.width - (margin_gap + middle_gap) * 2 ) / 3
        
        // title
        titleLabel = UILabel.init(frame: CGRect.init(x: margin_gap, y: 0, width: GlobalValue.SCREENBOUND.width, height: itemHeight))
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        self.addSubview(titleLabel)
        
        for i in 0..<list.count{
            let remainder = i % 3
            let quotient = i / 3
            
            let x_offset = CGFloat((middle_gap + itemWidth) * CGFloat(remainder) + margin_gap)
            let y_offset = CGFloat( ( CGFloat(quotient) * (top_gap + itemHeight) + top_gap))
            
            let fieldItem = AGArtistFieldItemView.init(frame: CGRect.init(x: x_offset, y: y_offset + titleLabel.bottom, width: itemWidth, height: itemHeight), title: list[i])
            self.addSubview(fieldItem)
            
            self.views.append(fieldItem)
        }
        
        
    }
    
    func summary() -> Dictionary<String , [String]>{
        var selected = [String]()
        for view in self.views{
            if view.isSelected{
                selected.append(view.title)
            }
        }
        
        return [self.title : selected]
        
    }
    
    func setSelectedList(list:[AGTag]){
        for view in self.views{
            view.isSelected = false
        }
        
        for target in list{
            for element in self.dataList{
                if target.isEqual(object: element){
                    let view = self.views[self.dataList.index(of: element)!]
                    view.isSelected = true
                }
            }
        }
    }
    
    // 随机产生 选择
    func randomDistribution(){
        let num = Int( arc4random()) % self.dataList.count
        let list = [self.dataList[num]]
        self.setSelectedList(list: list)
    }
    
    func getSelectedList()-> [Int]{
        var selected = [Int]()
        for view in self.views{
            if view.isSelected{
                let tag = self.dataList[self.views.index(of: view)!]
                selected.append(tag.tagId)
            }
        }
        
        return selected
        
    }


}
