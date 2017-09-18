//
//  AGUploadWorkTypeSelectionVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-13.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGUploadWorkTypeSelectionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavBar()
        setupUI()
        
    }
    
    func setupNavBar(){
        self.edgesForExtendedLayout = UIRectEdge()
        
        // 设置 bar 的背景色
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = String.localizedString("AGUploadWorkTypeSelectionVC-select")
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
    }

    func setupUI(){
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        let Icon_width = CGFloat(150)
        let Icon_gap = CGFloat(85)
        
        let contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Icon_width, height: Icon_width * 2 + Icon_gap))
        contentView.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 2, y: (GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT) / 2)
        
        
        // 添加 image icon
        let imgIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: Icon_width, height: Icon_width))
        imgIcon.image = UIImage.init(named: "UL_typeselection_imgicon")
        imgIcon.contentMode = .scaleAspectFit
        contentView.addSubview(imgIcon)
        
        // 添加 image 的 button
        let imgBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: Icon_width, height: Icon_width))
        imgBtn.addTarget(self, action: #selector(imageSelected), for: .touchUpInside)
        contentView.addSubview(imgBtn)
        
        // 添加 video icon
        let videoIcon = UIImageView.init(frame: CGRect.init(x: 0, y: imgIcon.bottom + Icon_gap, width: Icon_width, height: Icon_width))
        videoIcon.image = UIImage.init(named: "UL_typeselection_videoicon")
        videoIcon.contentMode = .scaleAspectFit
        contentView.addSubview(videoIcon)
        
        // 添加 video 的 button
        let videoBtn = UIButton.init(frame: CGRect.init(x: 0, y: imgIcon.bottom + Icon_gap, width: Icon_width, height: Icon_width))
        videoBtn.addTarget(self, action: #selector(videoSelected), for: .touchUpInside)
        contentView.addSubview(videoBtn)
        
        self.view.addSubview(contentView)
        
    }
    
    func imageSelected(){
        let vc = AGUploadPhotoWorkVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func videoSelected(){
        let vc = AGUploadVideoWorkVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension AGUploadWorkTypeSelectionVC: SlideNavigationControllerDelegate{
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return false
    }
}
