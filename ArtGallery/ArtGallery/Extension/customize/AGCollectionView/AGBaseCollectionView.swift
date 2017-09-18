//
//  AGBaseCollectionView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-26.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import MJRefresh

// 描述：
// 初始化函数：
// 参数： frame， header 的操作， footer的操作
// note: 只有当传进的block 不为空时，才会 添加 header 或者footer。因为有些页面并不是两者都需要。

class AGBaseCollectionView: UICollectionView {

    init(frame: CGRect,  layout:UICollectionViewFlowLayout, headerBlock: (()->Void)? ){
        super.init(frame: frame, collectionViewLayout: layout)
        
        if let headerBlk = headerBlock{
            let header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
                if let weakSelf = self{
                    headerBlk()
                    weakSelf.mj_header.endRefreshing()
                }
            })
            // header 被拉动时显示的内容
            header?.setTitle(String.localizedString("TableHeaderRefresh-Idle"), for: .idle)
            header?.setTitle(String.localizedString("TableHeaderRefresh-Pulling"), for: .pulling)
            header?.setTitle(String.localizedString("TableHeaderRefresh-Loading"), for: .refreshing)
            
            self.mj_header = header
        }
        
//        if let footerBlk = footerBlock{
//            // 初始化 footer
//            let footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
//                footerBlk()
//                self.mj_footer.endRefreshing()
//            })
//            footer?.setTitle(String.localizedString("TableFooterRefresh-Idle"), for: .idle)
//            footer?.setTitle(String.localizedString("TableFooterRefresh-Pulling"), for: .pulling)
//            footer?.setTitle(String.localizedString("TableFooterRefresh-Loading"), for: .refreshing)
//            
//            self.mj_footer = footer
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
