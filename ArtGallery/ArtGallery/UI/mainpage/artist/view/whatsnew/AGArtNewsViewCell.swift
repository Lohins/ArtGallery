//
//  AGArtNewsViewCell.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-08.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGArtNewsViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var picView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var postdateLabel: UILabel!
    
    @IBOutlet weak var readMoreLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    func updateData(title: String , type:WorksType){
        // 在updatedata 的时候需要先 reset 每一个button的图标
        self.titleLabel.text = title
        self.readMoreLabel.text = String.localizedString("AGNewsView-button")
       
    }
    
    func updateData(news: AGNews){
        let posted:String = String.localizedString("posted")
        self.titleLabel.text = news.title!
        self.postdateLabel.text = "\(posted) \(news.postTime!)"
        if let abstract = news.abstract{
            self.contentLabel.text = abstract
        }
        guard let str = news.imagePath, let url = URL.init(string: str) else{
            return
        }
        self.picView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "work-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
    }
 }
