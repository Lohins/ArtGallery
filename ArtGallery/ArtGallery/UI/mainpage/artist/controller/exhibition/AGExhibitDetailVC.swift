//
//  AGExhibitDetailVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-20.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGExhibitDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var textView: UITextView!
    
    let service = AGNewsService()
    
    var exhibitID: Int
    
    init(id: Int){
        self.exhibitID = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        updateData()

    }
    
    func setupNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        
        // 设置 bar 的背景色
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        // 设置 title view
        let titleImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 32))
        titleImgView.image = UIImage.init(named: "welcome_logo")
        titleImgView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImgView
        self.navigationItem.hidesBackButton = true
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        backButton.setBackgroundImage(UIImage.init(named: "back_arrow_white"), for: UIControlState.normal)
        backButton.bk_(whenTapped: { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.navigationController!.popViewController(animated: true)
            }
            })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        // ----
        let fillButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: fillButton)
        
        self.navigationItem.hidesBackButton = true
    }
    
    func updateData(){
        service.getExhibitDetail(exbitid: self.exhibitID) { (exhibit, error) in
            if error != nil{
                return
            }
            
            self.authorLabel.text = exhibit!.author
            self.titleLabel.text = exhibit!.title
            self.textView.text = exhibit!.content
            
            if let url = exhibit!.fileUrl{
                if let link = URL.init(string: url){
                    self.imageView.sd_setImage(with: link, placeholderImage: UIImage.init(named: "mainpage_myworks_see"), options: SDWebImageOptions.allowInvalidSSLCertificates)
                }
            }
            
        }
    }


}
