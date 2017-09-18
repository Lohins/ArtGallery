//
//  AGWhatsnewView.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-08.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGWhatsnewView: UIView {

    var scrollView: UIScrollView!
    
    //Place Holder for now, need change
    let cell_identifier = "AGArtNewsViewCell"
    
    var newsList = [String]()
    
    var globalNewsList = [AGNews]()
    var regionNewsList = [AGNews]()
    
    var globalNewsTBView: AGBaseTableView!
    
    var regionNewsTBView: AGBaseTableView!

    var service = AGNewsService()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI(frame: frame)
        
        updateGlobalData()
        // 登录的用户 才有 region id
        
        updateRegionData()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(frame: CGRect){
  
        let bottom_height = CGFloat(45)
        
        // 初始化 global news 的表格
        let globalTBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateGlobalData()
            }
        }

        self.globalNewsTBView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottom_height), headerRefreshBlk: globalTBHeaderBlk)
        self.globalNewsTBView.delegate = self
        self.globalNewsTBView.dataSource = self
        self.globalNewsTBView.separatorStyle = .none
        self.globalNewsTBView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        self.globalNewsTBView.isHidden = true
        self.addSubview(globalNewsTBView)
        
        // 初始化 region news 的表格
        let regionTBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateRegionData()
            }
        }

        self.regionNewsTBView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height - bottom_height), headerRefreshBlk: regionTBHeaderBlk)
        self.regionNewsTBView.delegate = self
        self.regionNewsTBView.dataSource = self
        self.regionNewsTBView.separatorStyle = .none
        self.regionNewsTBView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        self.regionNewsTBView.isHidden = false
        self.addSubview(regionNewsTBView)

        // 底部的可选择 view
        let bottomView = self.getBottomView()
        bottomView.bottom = frame.height
        self.addSubview(bottomView)
        
        self.globalNewsTBView.reloadData()
        self.regionNewsTBView.reloadData()
    }
    
    func updateGlobalData(){
        service.getNewsList{ (list, error) in
            if error != nil{
                return
            }
            self.globalNewsList = list!
            self.globalNewsTBView.reloadData()
        }
    }
    func updateRegionData(){
        
        if ArtGalleryAppCenter.sharedInstance.isLogin(){
            service.getNewsListbyRegionID{ (list, error) in
                if error != nil{
                    return
                }
                self.regionNewsList = list!
                self.regionNewsTBView.reloadData()
            }
        }
        else{
            service.getNewsList{ (list, error) in
                if error != nil{
                    return
                }
                self.regionNewsList = list!
                self.regionNewsTBView.reloadData()
            }
        }
        

    }

    
    func getBottomView() -> UIView{
        
        let bottom_height = CGFloat(45)
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: bottom_height))
        view.backgroundColor = UIColor.white
        
        let regionImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 35))
        regionImgView.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 4, y: view.height / 2)
        regionImgView.image = UIImage.init(named: "news_region_icon")
        
        let regionBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width / 2, height: bottom_height))
        regionBtn.center = regionImgView.center
        
        let globalImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 35))
        globalImgView.image = UIImage.init(named: "news_global_icon_opacity")
        globalImgView.center = CGPoint.init(x: GlobalValue.SCREENBOUND.width / 4 * 3, y: view.height / 2)
        
        let globalBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width / 2, height: bottom_height))
        globalBtn.center = globalImgView.center

        
        regionBtn.bk_(whenTapped: {[weak self]() -> Void in
            if let weakSelf = self{
                weakSelf.globalNewsTBView.isHidden = true
                weakSelf.regionNewsTBView.isHidden = false
                globalImgView.image = UIImage.init(named: "news_global_icon_opacity")
                regionImgView.image = UIImage.init(named: "news_region_icon")
            }

        })
        
        globalBtn.bk_(whenTapped: {[weak self]()-> Void in
            if let weakSelf = self{
                weakSelf.globalNewsTBView.isHidden = false
                weakSelf.regionNewsTBView.isHidden = true
                globalImgView.image = UIImage.init(named: "news_global_icon")
                regionImgView.image = UIImage.init(named: "news_region_icon_opacity")

            }
        })
        

        
        view.addSubview(regionImgView)
        view.addSubview(regionBtn)
        view.addSubview(globalImgView)
        view.addSubview(globalBtn)

        
        return view
    }
}

extension AGWhatsnewView: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.globalNewsTBView{
            return self.globalNewsList.count
        }
        else{
            return self.regionNewsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(281)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! AGArtNewsViewCell
        var news : AGNews?
        
        if tableView == self.globalNewsTBView{
            news = self.globalNewsList[indexPath.row]
            cell.updateData(news:news!)
        }
        
        else{
            news = self.regionNewsList[indexPath.row]
            cell.updateData(news:news!)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var news : AGNews?
        if tableView == self.globalNewsTBView{
            news = self.globalNewsList[indexPath.row]
        }
        else{
            news = self.regionNewsList[indexPath.row]
        }

        let detailVC = AGNewsDetailViewController.init(news:news!)
        self.getCurrentViewController()?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
