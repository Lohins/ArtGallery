//
//  AGExhibitionDetailVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-20.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGExhibitionDetailVC: UIViewController {
    
    let collection_cell_identifier = "AGWorksCollectionViewCell"
    
    var exhibitionsCollectionView: UICollectionView!

    var exhibition: AGExhibition
    
    var idList = [Int]()
    var urlList = [String]()
    
    var cellHeight = CGFloat(0)
    
    var service = AGNewsService()
    
    init(exhibition: AGExhibition){
        self.exhibition = exhibition
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        self.setupNavBar()
        
        self.updateData()
        
        
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
        service.getExhibitList(exbid: self.exhibition.id!) { (IDList, UrlList, error) in
            if error != nil{
                return
            }
            
            
            self.idList = IDList!
            self.urlList = UrlList!
            
            self.exhibitionsCollectionView.reloadData()
            
        }
    }
    
    
    func setupUI(){
        let bgView = UIImageView()
        bgView.image = UIImage(named:"welcome_bk")
        bgView.contentMode = .scaleToFill
        
        self.edgesForExtendedLayout = UIRectEdge()
        // 初始化 collection view
        
        let cell_width = ( GlobalValue.SCREENBOUND.width - CGFloat(23 + 15 + 15 + 23) ) / 3
        self.cellHeight = cell_width

        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: cell_width, height: cell_width)
        layout.minimumInteritemSpacing = CGFloat(15)
        layout.minimumLineSpacing = CGFloat(15)
        layout.footerReferenceSize = CGSize.init(width: GlobalValue.SCREENBOUND.width, height: 0)
        layout.scrollDirection = .vertical
        
        // collection view
        let collectionHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }

        self.exhibitionsCollectionView = AGBaseCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.NVBAR_HEIGHT - GlobalValue.STATUSBAR_HEIGHT ), layout: layout, headerBlock:collectionHeaderBlk)
        self.exhibitionsCollectionView.backgroundView = bgView
        self.exhibitionsCollectionView.delegate = self
        self.exhibitionsCollectionView.dataSource = self
        self.exhibitionsCollectionView.register(UINib.init(nibName: collection_cell_identifier, bundle: Bundle.main), forCellWithReuseIdentifier: collection_cell_identifier)
        
        self.view.addSubview(self.exhibitionsCollectionView)
    }

}



extension AGExhibitionDetailVC: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.idList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = self.idList[indexPath.row]
        
        let exhibitVC = AGExhibitDetailVC.init(id: id)
        self.navigationController?.pushViewController(exhibitVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: collection_cell_identifier , for: indexPath) as! AGWorksCollectionViewCell
        let imageurl = urlList[indexPath.row]
        cell.updateData(type: .Photo)
        cell.updateData(url: imageurl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: self.cellHeight, height: self.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: 23, bottom: 15, right: 23)
    }
}

