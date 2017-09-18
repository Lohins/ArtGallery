//
//  AGExhibitionViewCell.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-09.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGExhibitionViewCell: UITableViewCell {

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
    
    @IBOutlet weak var viewExiLabel: UILabel!
    
    @IBOutlet weak var abstractLabel: UILabel!
    func updateData(title: String , type:WorksType){
        // 在updatedata 的时候需要先 reset 每一个button的图标
        self.titleLabel.text = title
        print(String.localizedString("AGExhibitionView-button"))
        print(String.localizedString("AGNewsView-button"))
        self.viewExiLabel.text=String.localizedString("AGExhibitionView-button")
    }
    
    func updateData(exhibition: AGExhibition){
        self.titleLabel.text = exhibition.title!
        self.abstractLabel.text = exhibition.abstract!
        
        guard let str = exhibition.imagePath, let url = URL.init(string: str) else{
            return
        }
        self.picView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "exb-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
    }
    
}
