//
//  AGUploadPhotoWorkVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-13.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu

class AGUploadPhotoWorkVC: UIViewController {
    
    var progress: UIActivityIndicatorView!
    
    var artwork = AGArtwork.init(data: [:])
    
    var subjectList: [AGSubject] = [AGSubject]()
    
    var tagList = Dictionary<String , [AGTag]>()
    
    var mainScrollView: AGLinearScrollView!
    
    var titleTextBox: AGUploadWorkTextfieldBox!
    
    var subjectView: AGUploadWorkDropBox!
    
    var categoryView: AGUploadWorkDropBox!
    
    var tagView: AGUploadWorkDropBox!
    
    var descView:AGUploadWorkTextInput!
    
    var workImageView: UIImageView!
    
    let imagePickerController = UIImagePickerController.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavBar()
        
        setupUI()
        
        updateData()
        
        prefillData()
        
    }
    
    // 获取 之前的登陆 视图控制器， 然后 pop到那个视图控制器上面。
    func getMainVC() -> UIViewController?{
        let vcs = navigationController?.viewControllers
        for vc in vcs!{
            if vc.isKind(of: AGArtistMainPageViewController.classForCoder()){
                return vc
            }
        }
        return nil
    }

    
    // 上传作品 接口调用
    func upload(){
        
        guard let seletedImg = self.workImageView.image, let imgData = UIImageJPEGRepresentation(seletedImg, 1.0) else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: String.localizedString("AGSettingViewController-NoticeSelectImage"))
            return
        }

        let base64String = imgData.base64EncodedString()
        
        
        let uploadservice = AGArtworkService()
        var title = ""
        var description = ""
        var subject = 1
        var tag = 1
        var taglist:[Int] = []
        
        guard let TITLE = titleTextBox.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: "Please input title of the work.")
            return
        }
        guard let DESCRIPTION = descView.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: String.localizedString("Notice"), message: "Please input description of the work.")
            return
        }
        
        guard let SUBJECT = subjectView.getSubjectid() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "Please select the subject of the work.")
            return
        }
        
        guard let TAG = tagView.getTagid() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "Please select the tags of the work.")
            return
        }
        
        self.progress = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.progress.frame = self.mainScrollView.frame
        self.progress.center = self.mainScrollView.center
        self.view.addSubview(self.progress)
        self.progress.startAnimating()
        
        title = TITLE
        description = DESCRIPTION
        subject = SUBJECT
        tag = TAG
        taglist.append(tag)
        
        uploadservice.uploadArtwork(caption: title, description: description, imageBase64: base64String, videoBase64: "", subjectid: subject, taglist: taglist, finish: {
            [weak self] (result, error) in
            if let weakSelf = self{
                weakSelf.progress.stopAnimating()
                if error != nil || result == false{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "error", message: "Artwork upload failed.")
                    return
                }
                if result{
                    ArtGalleryAppCenter.sharedInstance.InfoNotification(vc: weakSelf, title: "Success", message: "Artwork upload completed.")
                    // 显示完提示信息之后，返回上一个页面
                    let timer = DispatchTime.now() + 1.0
                    DispatchQueue.main.asyncAfter(deadline: timer) {
                        let _ = weakSelf.navigationController?.popViewController(animated: true)
                    }
                }
            }

        })
        
        
    }
    
    func setupNavBar(){
        self.edgesForExtendedLayout = UIRectEdge()
        
        // 设置 bar 的背景色
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.init(floatValueRed: 231, green: 89, blue: 65, alpha: 1)
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = String.localizedString("AGUploadPhotoWorkVC-uploadphoto")
        titleLabel.font = UIFont.init(name: "OpenSans-Bold", size: 13)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        self.navigationItem.hidesBackButton = true
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 15, height: 20))
        backButton.setBackgroundImage(UIImage.init(named: "back_arrow_white"), for: UIControlState.normal)
        backButton.bk_(whenTapped: { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.navigationController!.popViewController(animated: true)
            }
            })
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
    }
    
    
    func setArtwork(artwork: AGArtwork){
        self.artwork = artwork
    }
    
    func setupUI(){
        // 初始化 图片选择 控制器
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
//        self.imagePickerController.mediaTypes = 

        
        // 初始化 scroll view
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.STATUSBAR_HEIGHT - GlobalValue.NVBAR_HEIGHT))
        //        self.mainScrollView.bottom = GlobalValue.SCREENBOUND.height
        self.view.addSubview(self.mainScrollView)
        
        
        // Row 1 -- 作品图片
        let picRatio = Float(0.624)
        workImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.width * CGFloat( picRatio)))
        workImageView.image = UIImage.init(named: "work-pic")
        workImageView.contentMode = .scaleAspectFill
        workImageView.clipsToBounds = true
        self.mainScrollView.linear_addSubview(workImageView, paddingTop: 0, paddingBottom: 0)
        
        // 改变图片的button
        let btn_width = GlobalValue.SCREENBOUND.width * CGFloat( picRatio) - 80
        let changePictureBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: btn_width, height: btn_width))
        changePictureBtn.setImage(UIImage.init(named: "myworks_changephoto"), for: .normal)
        changePictureBtn.addTarget(self, action: #selector(changePhotoAction), for: .touchUpInside)
        changePictureBtn.center = workImageView.center
        changePictureBtn.isHidden = false
        self.mainScrollView.addSubview(changePictureBtn)
        
        // title
        
        titleTextBox = AGUploadWorkTextfieldBox.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 55), title: String.localizedString("AGUploadPhotoWorkVC-title"))
        
        self.mainScrollView.linear_addSubview(titleTextBox, paddingTop: 15, paddingBottom: 0)
        
        // subject
        
        subjectView = AGUploadWorkDropBox.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 55), title: String.localizedString("AGUploadPhotoWorkVC-subject"))
        subjectView.block = { [weak self, weak subjectView] () -> Void in
            if let weakSelf = self, let weakSV = subjectView{
                let alertVC = UIAlertController.init(title: "Subjects", message: "Please select one.", preferredStyle: .actionSheet)
                for element  in weakSelf.subjectList {
                    let action = UIAlertAction.init(title: element.subjectName, style: .default, handler: { (action) in
                        weakSelf.artwork.subjectList = [element]
                        weakSV.updateData(subject: element)
                    })
                    alertVC.addAction(action)
                }
                let cancel = UIAlertAction.init(title: "Cancal", style: .cancel, handler: nil)
                alertVC.addAction(cancel)
                weakSelf.navigationController?.present(alertVC, animated: true, completion: nil)
            }
        }
        self.mainScrollView.linear_addSubview(subjectView, paddingTop: 15, paddingBottom: 0)
        
        
        // art gallery
        categoryView = AGUploadWorkDropBox.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 55), title: String.localizedString("AGUploadPhotoWorkVC-artcategory"))
        categoryView.block = { [weak self, weak categoryView] in
            if let weakSelf = self, let weakCV = categoryView{
                let categoryList = weakSelf.tagList.keys
                let alertVC = UIAlertController.init(title: "Artwork Category", message: "Please select one.", preferredStyle: .actionSheet)
                for element  in categoryList {
                    let action = UIAlertAction.init(title: element, style: .default, handler: { (action) in
                        weakSelf.artwork.category = element
                        weakCV.updateData(content: element)
                    })
                    alertVC.addAction(action)
                }
                let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                alertVC.addAction(cancel)
                weakSelf.navigationController?.present(alertVC, animated: true, completion: nil)
            }
        }
        self.mainScrollView.linear_addSubview(categoryView, paddingTop: 15, paddingBottom: 0)
        
        // tags
        
        tagView = AGUploadWorkDropBox.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 55), title: String.localizedString("AGUploadPhotoWorkVC-tags"))
        tagView.block = {  [weak self, weak tagView] () -> Void in
            if let weakSelf = self, let weakTV = tagView{
                if let category = weakSelf.artwork.category{
                    let tagList = weakSelf.tagList[category]
                    let alertVC = UIAlertController.init(title: "Tags", message: "Please select one.", preferredStyle: .actionSheet)
                    for element  in tagList! {
                        let action = UIAlertAction.init(title: element.tagName, style: .default, handler: { (action) in
                            weakSelf.artwork.tagsList = [element]
                            weakTV.updateData(tag: element)
                        })
                        alertVC.addAction(action)
                    }
                    let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                    alertVC.addAction(cancel)
                    weakSelf.navigationController?.present(alertVC, animated: true, completion: nil)
                }else{
                    let alertVC = UIAlertController.init(title: "Message", message: "Please select category firstly.", preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                    alertVC.addAction(action)
                    weakSelf.navigationController?.present(alertVC, animated: true, completion: nil)
                }

            }
        }
        self.mainScrollView.linear_addSubview(tagView, paddingTop: 15, paddingBottom: 0)
        
        //descrption
        
        descView = AGUploadWorkTextInput.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 130), title: String.localizedString("AGUploadPhotoWorkVC-description"))
        self.mainScrollView.linear_addSubview(descView, paddingTop: 15, paddingBottom: 10)
        
        // upload button and bgview
        let btnView = UIView.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 55))
        self.mainScrollView.linear_addSubview(btnView, paddingTop: 18, paddingBottom: 10)

        let btnBGView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: btnView.frame.width, height: 55))
        btnBGView.image = UIImage.init(named: "btn_orange_bg")
        btnBGView.contentMode = .scaleToFill
        btnView.addSubview(btnBGView)
        
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: btnView.frame.width, height: 55))
        button.setTitle(String.localizedString("AGUploadPhotoWorkVC-uploadartwork"), for: .normal)
        button.titleLabel?.font = UIFont.init(name: "OpenSans-Bold", size: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.bk_(whenTapped: {[weak self]() -> Void in
            if let weakSelf = self{
                weakSelf.upload()
            }
        })

        btnView.addSubview(button)

    }
    
    func prefillData(){
        
        if let title = self.artwork.caption{
            self.titleTextBox.updateData(content: title)
        }
        
        if  self.artwork.subjectList.count > 0 {
            let subject = self.artwork.subjectList[0]
            self.subjectView.updateData(content: subject.subjectName)
        }
        
        if  self.artwork.tagsList.count > 0 {
            let tag = self.artwork.tagsList[0]
            self.tagView.updateData(content: tag.tagName)
            
            for key in self.tagList.keys{
                let list = self.tagList[key]
                for t in list!{
                    if t.tagName == tag.tagName{
                        self.categoryView.updateData(content: key)
                    }
                }
            }
        }
        
        if let desc = self.artwork.desc{
            self.descView.updateData(content: desc)
        }
        
    }
    
    func updateData(){
        // 获取网络数据
        let service = AGPreferenceService()
        service.getPreferenceInfo {[weak self] (subList, TagDict, cateDict, error) in
            if let weakSelf = self{
                if error != nil{
                    return
                }
                if let subList = subList , let TagDict = TagDict{
                    weakSelf.subjectList = subList
                    weakSelf.tagList = TagDict
                }
            }
        }
    }
    

    
    func changePhotoAction(){
        let blk = { [weak self] (type: UIImagePickerControllerSourceType) -> Void in
            if let weakSelf = self{
                weakSelf.imagePickerController.sourceType = type
                weakSelf.navigationController?.present(weakSelf.imagePickerController, animated: true, completion: {
                    
                })
            }
        }
        
        let alertVC = UIAlertController.init(title: "Change Image", message: "Select image from", preferredStyle: .actionSheet)
        // 检测当前设备是否可以 访问 图库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction.init(title: "Photo Library", style: .default) { (action) in
                blk(UIImagePickerControllerSourceType.photoLibrary)
            }
            alertVC.addAction(photoLibraryAction)
        }
        // 检测当前设备是否可以 访问 相机
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction.init(title: "Camera", style: .default) { (action) in
                blk(UIImagePickerControllerSourceType.camera)
            }
            alertVC.addAction(cameraAction)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
        }
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 页面消失的时候 把  转换的图片文件都删除了。
        // 保存至沙盒路径
        guard let sandboxPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else{
            return
        }
        
        let videoFilePath = sandboxPath + "/UploadImageWork"
        
        // 不存在就 直接返回
        if  !FileManager.default.fileExists(atPath: videoFilePath){
            return
        }
        
        do{
            let list = try FileManager.default.contentsOfDirectory(atPath: videoFilePath)
            print("Before delete.")
            print(list)
            // 把所有 转换文件都删除了
            for path in list{
                let deletePath = videoFilePath + "/" + path
                if  FileManager.default.fileExists(atPath: deletePath){
                    try! FileManager.default.removeItem(atPath: deletePath)
                }
            }
            print("After delete.")
            print(list)
        }
        catch{
            print(error.localizedDescription)
        }
    }

}

extension AGUploadPhotoWorkVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //    选择完图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.workImageView.image = image
            if picker.sourceType == .camera{
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            else{
            }
            
            // 保存至沙盒路径
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            let videoName = dateFormatter.string(from: Date()) + ".png"
            let jpegName = dateFormatter.string(from: Date()) + ".jpeg"
            
            guard let sandboxPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else{
                return
            }
            
            let videoFilePath = sandboxPath + "/UploadImageWork"
            let videoSavePath = "\(videoFilePath)/\(videoName)"
            let jpegNamePath = "\(videoFilePath)/\(jpegName)"
            
            if  !FileManager.default.fileExists(atPath: videoFilePath){
                do {
                    try FileManager.default.createDirectory(atPath: videoFilePath, withIntermediateDirectories: true, attributes: nil)
                }
                catch{
                    print(error.localizedDescription)
                }
            }
            
            try! UIImageJPEGRepresentation(image, 1.0)?.write(to: URL.init(fileURLWithPath: videoSavePath))
            
            var sizeInMB = UIImage.SizeOfImageIn(path: videoSavePath) / 1000 / 1000
            
            if sizeInMB > 10{
                ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "The size of image is bigger than 10 MB, please try another one.")
            }
            
            print("before comprise,Image size  : \(sizeInMB)" )
            
            try! UIImageJPEGRepresentation(image, 0.5)?.write(to: URL.init(fileURLWithPath: jpegNamePath))
            sizeInMB = UIImage.SizeOfImageIn(path: jpegNamePath)
            
            print("after comprise,Image size  : \(sizeInMB)" )

        }
        else{
            print("Pick wrong image.")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消图片选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



