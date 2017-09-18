//
//  AGWorksCollectionView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-10-30.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGWorksCollectionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    var collectionLayout: UICollectionViewFlowLayout
    var collectionView: UICollectionView
    
    var dataList: [String]?
    
    let cell_identifier = ""
    
    init(height: CGFloat, data: [String]) {
        self.collectionLayout = UICollectionViewFlowLayout.init()
        self.collectionView = UICollectionView.init()
        
        super.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: height))
        self.collectionView.frame = self.frame
        
        collectionView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellWithReuseIdentifier: cell_identifier)
        
        self.addSubview(collectionView)
        
        self.dataList = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionLayout(){
        let marginGap = CGFloat(25)
        let middleGap = CGFloat(15)

        let itemWidth = (GlobalValue.SCREENBOUND.width - marginGap * 2 - middleGap * 2 ) / 3
        self.collectionLayout.minimumInteritemSpacing = 15
        self.collectionLayout.minimumLineSpacing = 15
        self.collectionLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        self.collectionLayout.estimatedItemSize = CGSize.init(width: itemWidth, height: itemWidth)
        self.collectionLayout.scrollDirection = .vertical
        self.collectionLayout.headerReferenceSize = CGSize.zero
        self.collectionLayout.headerReferenceSize = CGSize.zero
        self.collectionLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
    }

}

extension AGWorksCollectionView: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let list = self.dataList{
            return list.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cell_identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.collectionLayout.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.collectionLayout.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.collectionLayout.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.collectionLayout.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
}
