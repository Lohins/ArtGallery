//
//  AGNewsDetailViewController.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-24.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGNewsDetailViewController: UIViewController {
    
    let service = AGNewsService()
    
    var news: AGNews
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var picView: UIImageView!
    
    @IBOutlet weak var postdateLabel: UILabel!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    init(news : AGNews){
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        updateData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let id:Int = news.id!
        let posted = String.localizedString("posted")
        let authortitle = String.localizedString("author")
        let date:String = news.postTime!
        self.titleLabel.text = news.title
        self.postdateLabel.text = "\(posted)\(date)"
        if let url = news.imagePath{
            if let link = URL.init(string: url){
                self.picView.sd_setImage(with: link, placeholderImage: UIImage.init(named: "exb-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
            }
        }
        service.getNewsDetail(newsid: id) { (receivednews, error) in
            if error != nil{
                return
            }
            self.contentTextView.text = receivednews?.content
            let Author = receivednews?.author
            self.authorLabel.text = "\(authortitle)\(Author!)"
        }
    }
}
