//
//  AGArtistMPWorksItemCell.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-04.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGArtistMPWorksItemCell: UITableViewCell  {
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var picView: UIImageView!
    
    @IBOutlet weak var videoIcon: UIImageView!
    
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var likes:Int = 0
    var comments:Int = 0
    
    var deleteBlk: (() -> Void)?
    var editBlk: (() -> Void)?
    
    
    var editable: Bool = false{
        didSet{
            if self.editable == true{
                self.actionView.isHidden = false
            }
            else{
                self.actionView.isHidden = true
            }
        }
    }
    
    func updateData(title: String){
        self.titleLabel.text = title
    }
    
    func updateData(artwork: AGArtwork){
        self.titleLabel.text = artwork.caption
        self.subjectLabel.text = artwork.subjectName
        likes = artwork.likeNum
        comments = artwork.commentNum
        self.dataLabel.text = "\(likes) Likes | \(comments) Comments"
        
        if artwork.worksType == .Photo{
            self.videoIcon.isHidden = true
        }
        else{
            self.videoIcon.isHidden = false
        }
        
        guard let str = artwork.imagePath, let url = URL.init(string: str) else{
            self.picView.image = UIImage.init(named:"work-pic")
            return
        }
        self.picView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "work-pic"), options: SDWebImageOptions.allowInvalidSSLCertificates)
    }
    
    func deleteData(artworkId: Int, finish: @escaping ((_ status: Int, _ id: Int) -> Void)){

        let service = AGArtworkService()
        // warning
        service.deleteArtwork(artworkid: artworkId, finish: { [weak self]
            (result, error) in
            if let weakSelf = self{
                if error != nil || result == false{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateFail"))
                    finish (0, 0)
                }
                if result{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf.getCurrentViewController()!, title: String.localizedString("Notice"), message: String.localizedString("UpdateSuccess"))
                    finish (1, artworkId)
                }
            }

            
        })
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 这个是 edit button
    @IBAction func seeAction(_ sender: AnyObject) {
        
        if let blk = self.editBlk{
            blk()
        }
    }
    
    @IBAction func deleteAction(_ sender: AnyObject) {
        if let blk = self.deleteBlk{
            blk()
        }
    }
    
    
}
