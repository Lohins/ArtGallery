//
//  AGArtistMPMyWorksView.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-04.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import HMSegmentedControl
import iOS_Slide_Menu

class AGArtistMPMyWorksView: UIView {
    
    // 这个 变量表示， 当该页面被第一次创建的时候， 被赋值 为 0，
    // 当 该页面 被初始化界面了之后， 就被赋值为 1，之后就一直是 1
    var onceInitToken: Int = 0
    
    var segmentControl: HMSegmentedControl!
    
    var tableView: AGBaseTableView!
    
    var dataList: [AGArtwork]
    
    var id:Int!
    
    let cell_identifier = "AGArtistMPWorksItemCell"
    
    var editable: Bool  = false{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override init(frame: CGRect){
        self.dataList = [AGArtwork]()
        super.init(frame: frame)
    }

    // 初始化这个页面的时候， 应该传进 id 参数， 然后到服务器去获取 作品 的数据。
    convenience init(frame: CGRect , id: Int){
        self.init(frame : frame)
        
//        setupUI(frame: frame)
//        updateData()
//        
//        // 注册通知， 在用户 更新为完信息之后，及时的刷新页面。
//        self.registerNotification()
    }
    
    func firstTimeInit(){
        if self.onceInitToken == 0{
            setupUI(frame: self.frame)
//            updateData()
            // 注册通知， 在用户 更新为完信息之后，及时的刷新页面。
            self.registerNotification()
            
            self.onceInitToken = 1
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(frame: CGRect){
        let imgSize = CGSize.init(width: 35, height: 35)
        let addImg = UIImage.init(named: "mainpage_myworks_followbox")?.imageScale(size: imgSize )
        let addOpacityImg = UIImage.init(named: "mainpage_myworks_followbox_opacity")?.imageScale(size: imgSize )
        let editImg = UIImage.init(named: "mainpage_myworks_edit")?.imageScale(size: imgSize )
        let editOpacityImg = UIImage.init(named: "mainpage_myworks_edit_opacity")?.imageScale(size: imgSize )

        self.segmentControl = HMSegmentedControl.init(sectionImages: [addOpacityImg! , editOpacityImg!], sectionSelectedImages: [addImg!, editImg!])
        print(self.segmentControl.frame)
        self.segmentControl.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 45)
        self.segmentControl.segmentEdgeInset = UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20)

        self.segmentControl.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
        self.segmentControl.backgroundColor = UIColor.init(floatValueRed: 176, green: 79, blue: 77, alpha: 1)
        self.segmentControl.selectionIndicatorHeight = 0
        self.segmentControl.isVerticalDividerEnabled = true
        self.segmentControl.verticalDividerWidth = 1
        self.segmentControl.verticalDividerColor = UIColor.init(floatValueRed: 255, green: 255, blue: 255, alpha: 0.2)
        self.addSubview(self.segmentControl)
        
        // table view
        // 显示 图片的table view
        let TBHeaderBlk = {[weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.updateData()
            }
        }

        self.tableView = AGBaseTableView.init(frame: CGRect.init(x: 0, y: self.segmentControl.bottom, width: self.frame.width, height: self.frame.height - self.segmentControl.height), headerRefreshBlk: TBHeaderBlk)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: cell_identifier, bundle: Bundle.main), forCellReuseIdentifier: cell_identifier)
        self.addSubview(self.tableView)
        
        self.tableView.reloadData()
    }
    
    func segmentValueChanged(sender: HMSegmentedControl){
        print(sender.selectedSegmentIndex)
        if sender.selectedSegmentIndex == 0{
            self.editable = false
        }
        else{
            self.editable = true
        }
    }
    
    func updateData(){
        let service = AGArtistService()
        service.getMyWorksList { (list, error) in
            if error != nil{
                return
            }
            
            self.dataList = list!
            self.tableView.reloadData()
        }
    }
    
    // 注册通知
    func registerNotification(){
        ArtGalleryAppCenter.sharedInstance.registerNotification(for: self, withName: Notification.Name("AGArtistMPMyWorksView-UpdateWhenShow"), selector: #selector(updateData))
    }
    
    // 析构函数里 取消注册
    deinit {
        ArtGalleryAppCenter.sharedInstance.removeNotification(for: self)
    }

}

extension AGArtistMPMyWorksView: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(241)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.dataList.count == 0{
            return CGFloat(50)
        }
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.dataList.count == 0{
            let footer = AGTableEmptyFooter.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: 50), title: "No data for displaying.")
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: cell_identifier, for: indexPath) as! AGArtistMPWorksItemCell
        cell.editable = self.editable
        cell.selectionStyle = .none
        cell.updateData(artwork: self.dataList[indexPath.row])
        
        cell.editBlk = { [weak self] ()-> Void in
            if let weakSelf = self{
                let artwork = weakSelf.dataList[indexPath.row]
                if artwork.worksType == .Photo{
                    let vc = AGEditPhotoWorkVC.init(id: artwork.id)
                    //                vc.setArtwork(artwork: self.artwork!)
                    weakSelf.getCurrentViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = AGEditVideoWorkVC.init(id: artwork.id)
                    //                vc.setArtwork(artwork: self.artwork!)
                    weakSelf.getCurrentViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        cell.deleteBlk = { [weak self, weak cell] ()-> Void in
            if let weakSelf = self, let weakCell = cell{
                let alertVC = UIAlertController.init(title: "Confirm", message: "Delete current artwork?", preferredStyle: .alert)
                let confirmaction = UIAlertAction.init(title: "Yes", style: .default, handler:{ []
                    (action: UIAlertAction!) in
                    let item = weakSelf.dataList[indexPath.row]
                    weakCell.deleteData(artworkId: item.id) { (status, id) in
                        if status == 1{
                            weakSelf.deleteItemById(id: id)
                        }
                    }
                })
                let cancelaction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                alertVC.addAction(cancelaction)
                alertVC.addAction(confirmaction)
                weakSelf.getCurrentViewController()!.present(alertVC, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    func deleteItemById(id: Int){
        var index: Int = -1
        for item in self.dataList{
            if item.id == id{
                index = self.dataList.index(of: item)!
            }
        }
        
        if index != -1{
            self.dataList.remove(at: index)
            self.tableView.reloadData()

        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artwork = self.dataList[indexPath.row]
        
        if artwork.worksType == .Photo{
            let vc = AGArtistPhotoWorkHomeVC.init(id: artwork.id , editable: true)
            self.getCurrentViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = AGArtistVideoWorkHomeVC.init(id: artwork.id , editable: true)
            self.getCurrentViewController()?.navigationController?.pushViewController(vc, animated: true)

        }
        
        
    }
}
