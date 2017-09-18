//
//  AGNewsView.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-08.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import HMSegmentedControl

class AGNewsView: UIView {

    
    // 这个 变量表示， 当该页面被第一次创建的时候， 被赋值 为 0，
    // 当 该页面 被初始化界面了之后， 就被赋值为 1，之后就一直是 1
    var onceInitToken: Int = 0
    
    
    var segmentControl: HMSegmentedControl!
    
    var newsView: AGWhatsnewView!
    
    var exhibitionView: AGExhibitionView!
    
    var segTitlesArray:[String]{
        var array = [String]()
        array.append(String.localizedString("AGArtistMainPageViewController-whatsnew-news"))
        array.append(String.localizedString("AGArtistMainPageViewController-whatsnew-exbs"))
        return array
    }

    
    override init(frame: CGRect){
        
        super.init(frame: frame)
    }
    
    // 初始化这个页面的时候， 应该传进 id 参数， 然后到服务器去获取 前沿消息 的数据。
    convenience init(frame: CGRect , id: Int){
        self.init(frame : frame)

//        setupUI(frame: frame)
    }
    
    func firstTimeInit(){
        if self.onceInitToken == 0{
            setupUI(frame: self.frame)
            self.onceInitToken = 1
        }
    }
    
    func setupUI(frame: CGRect){
        
        // 设置Tab
        self.segmentControl = HMSegmentedControl.init(sectionTitles: self.segTitlesArray)
        // 设置字体颜色。 white + opacity: 50%
        self.segmentControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.5) , NSFontAttributeName: UIFont.init(name: "OpenSans-Bold", size: CGFloat(12))!]
        
        self.segmentControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white , NSFontAttributeName: UIFont.init(name: "OpenSans-Bold", size: CGFloat(12))!]

        self.segmentControl.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 45)
        self.segmentControl.segmentEdgeInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)
        
        self.segmentControl.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
        self.segmentControl.backgroundColor = UIColor.init(floatValueRed: 176, green: 79, blue: 77, alpha: 1)
        
        self.segmentControl.selectionIndicatorHeight = 0
        self.segmentControl.isVerticalDividerEnabled = true
        self.segmentControl.verticalDividerWidth = 1
        self.segmentControl.verticalDividerColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.2)
        
        self.addSubview(self.segmentControl)
        

        // 展览
        self.exhibitionView = AGExhibitionView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height))
        self.addSubview(self.exhibitionView)
        
        // 新闻
        self.newsView = AGWhatsnewView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height))
        self.addSubview(self.newsView)
        
        
           }
    
    func segmentValueChanged(sender: HMSegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0{
            self.newsView.isHidden = false
            self.exhibitionView.isHidden = true
        }
        else{
            self.newsView.isHidden = true
            self.exhibitionView.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

