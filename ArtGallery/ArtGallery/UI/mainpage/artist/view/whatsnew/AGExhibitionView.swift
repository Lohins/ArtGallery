//
//  AGExhibitionView.swift
//  ArtGallery
//
//  Created by Weibo Wang on 2016-11-08.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit

class AGExhibitionView: UIView {

    var exhibitionTableView: AGBaseTableView!
    
    //Place Holder for now, need change
    let cell_identifier = "AGExhibitionViewCell"
    
    //var exbList = [String]()
    
    var exhibitionList = [AGExhibition]()
    
    var service = AGNewsService()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI(frame: frame)
        
        updateData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(frame: CGRect){
        let TBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }
        self.exhibitionTableView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height), headerRefreshBlk: TBHeaderBlk)
        self.exhibitionTableView.delegate = self
        self.exhibitionTableView.dataSource = self
        self.exhibitionTableView.separatorStyle = .none
        self.exhibitionTableView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        
        self.addSubview(self.exhibitionTableView)

        self.exhibitionTableView.reloadData()
    }
    
    func updateData(){
        service.getExhibitionList { (list, error) in
            if error != nil{
                return
            }
            self.exhibitionList = list!
            self.exhibitionTableView.reloadData()
            
        }
    }
}

extension AGExhibitionView: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exhibitionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(281)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! AGExhibitionViewCell
        
        let ex = self.exhibitionList[indexPath.row]
        cell.updateData(exhibition: ex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exhi = self.exhibitionList[indexPath.row]
        let detailVC = AGExhibitionDetailVC.init(exhibition: exhi)
        self.getCurrentViewController()?.navigationController?.pushViewController(detailVC, animated: true)
    }

}
