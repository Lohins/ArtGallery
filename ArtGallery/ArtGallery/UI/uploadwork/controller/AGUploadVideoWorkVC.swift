//
//  AGUploadVideoWorkVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-11-13.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import iOS_Slide_Menu
import AVFoundation
import AVKit

class AGUploadVideoWorkVC: UIViewController {
    
    var progress: UIActivityIndicatorView!
    
    var artwork = AGArtwork.init(data: [:])
    
    var subjectList: [AGSubject] = [AGSubject]()
    
    var tagList = Dictionary<String , [AGTag]>()

    var mainScrollView: AGLinearScrollView!
    
    var urlTextBox: AGUploadWorkTextfieldBox!
    
    var titleTextBox: AGUploadWorkTextfieldBox!
    
    var subjectView: AGUploadWorkDropBox!
    
    var categoryView: AGUploadWorkDropBox!
    
    var tagView: AGUploadWorkDropBox!
    
    var descView:AGUploadWorkTextInput!
    
    var workImageView: UIImageView!
    
    // 用来存储 视频在 本地文件夹中的路径
    var videoFileUrl: URL?
    
    var playerViewController: AVPlayerViewController = AVPlayerViewController.init()
    
//    上传 按钮
    var uploadBtn: UIButton!
    
    let imagePickerController = UIImagePickerController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupNavBar()
        setupUI()
        
        updateData()
        
        prefillData()
    }
    
    func setArtwork(artwork: AGArtwork){
        self.artwork = artwork
    }
    
    func uploadvideo(){
        
        guard let url = self.videoFileUrl else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "Please select video first.")
            return
        }
        

        // --- progress indicator
        self.progress = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.progress.frame = self.mainScrollView.frame
        self.progress.center = self.mainScrollView.center
        self.view.addSubview(progress)
        
        var videoBase64 = ""
        var imageBase64 = ""

        do{
            let videoData = try Data.init(contentsOf: url)
            videoBase64 = videoData.base64EncodedString()
            // print(videoData.base64EncodedString())
            let seletedImg = self.workImageView.image!
            if let imgData = UIImageJPEGRepresentation(seletedImg, 1.0) {
                imageBase64 = imgData.base64EncodedString()
            }
            
        }
        catch{
            print(error.localizedDescription)
            // 如果 获取视频失败则返回。
            return
        }
        
        
        var title = "Title"
        var subjectid = 1
        var taglist:[Int] = []
        var tag = 1
        var description = "The description is empty."
        
        guard let TITLE = titleTextBox.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "Please input title of the work.")
            return
        }
        guard let DESCRIPTION = descView.getInfo() else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "Please input description of the work.")
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
        title = TITLE
        description = DESCRIPTION
        subjectid = SUBJECT
        tag = TAG
        taglist.append(tag)
        
        self.progress.startAnimating()
        let uploadservice = AGArtworkService()
        uploadservice.uploadArtwork(caption: title, description: description, imageBase64: imageBase64, videoBase64: videoBase64, subjectid: subjectid, taglist: taglist, finish: {
            [weak self] (result, error) in
            if let weakSelf = self{
                if error != nil || result == false{
                    weakSelf.progress.stopAnimating()
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: weakSelf, title: "Error", message: "Upload artwork failed.")
                    return
                }
                if result{
                    weakSelf.progress.stopAnimating()
                    ArtGalleryAppCenter.sharedInstance.InfoNotification(vc: weakSelf, title: "Success", message: "Artwork upload completed.")
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
        titleLabel.text = String.localizedString("AGUploadPhotoWorkVC-uploadvideo")
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
    
    func setupUI(){
        
        // 初始化 图片选择 控制器
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
        if let _ = mediaTypes?.index(of: "public.movie" ){
            self.imagePickerController.mediaTypes = ["public.movie"]
        }
        // 如果 机器不支持 视频获取的话， 返回上一个页面。
        else{
            self.dismiss(animated: true, completion: nil)
        }

        // 初始化 scroll view
        self.mainScrollView = AGLinearScrollView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.height - GlobalValue.STATUSBAR_HEIGHT - GlobalValue.NVBAR_HEIGHT))
        //        self.mainScrollView.bottom = GlobalValue.SCREENBOUND.height
        self.view.addSubview(self.mainScrollView)
        
        
        // Row 1 -- 作品图片
        let picRatio = Float(0.624)
        workImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.width * CGFloat( picRatio)))
        workImageView.image = UIImage.init(named: "UL_video_navbarbg")
        workImageView.contentMode = .scaleAspectFill
        workImageView.clipsToBounds = true
        self.mainScrollView.linear_addSubview(workImageView, paddingTop: 0, paddingBottom: 0)
        
        // youtuve icon
        let youtubeIcon = UIImageView.init(image: UIImage.init(named: "youtube_logo"))
        youtubeIcon.frame = CGRect.init(x: 0, y: 0, width: 63, height: 45)
        youtubeIcon.center = workImageView.center
        self.mainScrollView.addSubview(youtubeIcon)
        
        // change button
        let changePictureBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalValue.SCREENBOUND.width, height: GlobalValue.SCREENBOUND.width * CGFloat( picRatio)))
        changePictureBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        changePictureBtn.center = workImageView.center
        changePictureBtn.isHidden = false
        self.mainScrollView.addSubview(changePictureBtn)
        
        // 更改 视频 按钮
        let changeBtnView = UIView.init(frame: CGRect.init(x: 23, y: 0, width: GlobalValue.SCREENBOUND.width - 23 * 2, height: 55))
        self.mainScrollView.linear_addSubview(changeBtnView, paddingTop: 18, paddingBottom: 10)
        let changeBtnBGView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: changeBtnView.frame.width, height: 55))
        changeBtnBGView.image = UIImage.init(named: "artist_field_select_btnBG")
        changeBtnBGView.contentMode = .scaleToFill
        changeBtnView.addSubview(changeBtnBGView)
        
        let changeBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: changeBtnView.frame.width, height: 55))
        changeBtn.setTitle(String.localizedString("AGUploadPhotoWorkVC-uploadartwork"), for: .normal)
        changeBtn.titleLabel?.font = UIFont.init(name: "OpenSans", size: 16)
        changeBtn.setTitleColor(UIColor.init(floatValueRed: 74, green: 74, blue: 74, alpha: 1), for: .normal)
        changeBtn.addTarget(self, action: #selector(changeVideoAction), for: .touchUpInside)
        changeBtnView.addSubview(changeBtn)
        
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
                    let alertVC = UIAlertController.init(title: "Subjects", message: "Please select one.", preferredStyle: .actionSheet)
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
        
        uploadBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: btnView.frame.width, height: 55))
        uploadBtn.setTitle(String.localizedString("AGUploadPhotoWorkVC-uploadartwork"), for: .normal)
        uploadBtn.titleLabel?.font = UIFont.init(name: "OpenSans-Bold", size: 16)
        uploadBtn.setTitleColor(UIColor.white, for: .normal)
        uploadBtn.bk_(whenTapped: { [weak self] ()-> Void in
            if let weakSelf = self{
                weakSelf.uploadvideo()
            }
        })
        uploadBtn.isUserInteractionEnabled = false
        btnView.addSubview(uploadBtn)
        
    }
    
    func prefillData(){
        if let link = self.artwork.videoLink{
            self.urlTextBox.updateData(content: link)
        }
        
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
        service.getPreferenceInfo { (subList, TagDict, cateDict, error) in
            if error != nil{
                 return
            }
            if let subList = subList , let TagDict = TagDict{
                self.subjectList = subList
                self.tagList = TagDict
            }
        }
    }
    
    func selectedSubject(){
        
    }
    
    func selectedCategory(){
        
    }
    
    func selectedTag(){
        
    }
    
    
    
    func changeVideoAction(){
        let blk = { [weak self] (type: UIImagePickerControllerSourceType) -> Void in
            if let weakSelf = self{
                weakSelf.imagePickerController.sourceType = type
                weakSelf.navigationController?.present(weakSelf.imagePickerController, animated: true, completion: {
                    
                })
            }

        }
        
        let alertVC = UIAlertController.init(title: "Change Video", message: "Select video from", preferredStyle: .actionSheet)
        // 检测当前设备是否可以 访问 图库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let photoLibraryAction = UIAlertAction.init(title: "Photo Library", style: .default) { (action) in
                blk(UIImagePickerControllerSourceType.photoLibrary)
            }
            alertVC.addAction(photoLibraryAction)
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in
        }
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    // 视频处理结束后调用这个办法， 让 上传按钮变成可点击状态。
    func videoProcessFinish(url : URL){
        uploadBtn.isUserInteractionEnabled = true
        self.videoFileUrl = url
        
        do{
            let item = try FileManager.default.attributesOfItem(atPath: url.path)
            // 单位是 Byte, iOS 中 1K = 1000 B
            let fileSize = item[FileAttributeKey.size] as! UInt64
            let sizeInMB = fileSize / 1000 / 1000
            if sizeInMB > 50{
                ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "The size of video is bigger than 50 MB, please try another one.")
            }
            print( "The size of file \(fileSize / 1000 )" )
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    // 播放视频 - 判断是播放网络视频 还是 本地视频
    func playVideo(){
        // 本地视频
        if let url = self.videoFileUrl{
            let playerItem = AVPlayerItem.init(url: url)
            
            let player = AVPlayer.init(playerItem: playerItem)
            
            self.playerViewController.player = player
            
            self.present(self.playerViewController, animated: true, completion: {
                self.playerViewController.player!.play()
            })
        }
        else{
            ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice", message: "Please select video first.")
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        // 页面消失的时候 把  转换的视频文件都删除了。
        // 保存至沙盒路径
        guard let sandboxPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else{
            return
        }
        
        let videoFilePath = sandboxPath + "/UploadVideoWork"
        
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

extension AGUploadVideoWorkVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        先判断是 是不是 视频文件
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        if mediaType == "public.movie"{
            // 获取 视频的 本地url
            let mediaUrl = info[UIImagePickerControllerMediaURL] as! URL
            print("get url : " + mediaUrl.absoluteString)
            
            // 视频截图
            self.workImageView.image = UIImage.ImageFromVideo(url: mediaUrl)
            
            if FileManager.default.fileExists(atPath: mediaUrl.path){
                // 如果视频太大了，就提示用户 选择其他视频
                let item = try! FileManager.default.attributesOfItem(atPath: mediaUrl.path)
                // 单位是 Byte, iOS 中 1K = 1000 B
                let fileSize = item[FileAttributeKey.size] as! UInt64
                let sizeInMB = fileSize / 1000 / 1000
                // 如果 大于 50 MB
                if sizeInMB > 50{
                    ArtGalleryAppCenter.sharedInstance.ErrorNotification(vc: self, title: "Notice" , message: "The size of video is larger than 50 MB, please select anothor video.")
                    return
                }
            }

            
            convertVideoWithUrl(videoUrl: mediaUrl)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 取消图片选择
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 统一将 视频转换成 MP4 格式的。
    func convertVideoWithUrl(videoUrl: URL) {
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let videoName = dateFormatter.string(from: Date()) + ".mp4"
        
        // 保存至沙盒路径
        guard let sandboxPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else{
            return
        }
        
        let videoFilePath = sandboxPath + "/UploadWorksFolder"
        let videoSavePath = "\(videoFilePath)/\(videoName)"
        
        if  !FileManager.default.fileExists(atPath: videoFilePath){
            do {
                try FileManager.default.createDirectory(atPath: videoFilePath, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                print(error.localizedDescription)
            }
        }
        
        // 转码设置
        
        let asset = AVURLAsset.init(url: videoUrl)
        guard let exportSession = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality) else{
            return
        }
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputURL = URL.init(fileURLWithPath: videoSavePath)
        exportSession.outputFileType = AVFileTypeMPEG4
        
        
        
        exportSession.exportAsynchronously { 
            let status = exportSession.status
            print(status.rawValue)
            switch status{
            case AVAssetExportSessionStatus.failed:
                break
            case AVAssetExportSessionStatus.completed:
                self.videoProcessFinish(url: URL.init(fileURLWithPath: videoSavePath))
                break
            default:
                print("nothing happen.")
            }
        }
        
        
    }
}

