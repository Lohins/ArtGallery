//
//  AGImageFullScreenDisplayVC.swift
//  ArtGallery
//
//  Created by UBIELIFE on 2016-12-23.
//  Copyright © 2016 UBIELIFE Inc. All rights reserved.
//

import UIKit
import SDWebImage

class AGImageFullScreenDisplayVC: UIViewController {
    
    var imageView : UIImageView!
    
    var scrollView: UIScrollView!

    var link: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(url: String){
        
        super.init(nibName: nil, bundle: nil)
        self.link = url
        
        self.setupUI()
        
        self.downloadImage()

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        self.view.backgroundColor = UIColor.black
        
//        let imgData = try! Data.init(contentsOf: URL.init(string: self.link)!)
//        let image = UIImage.init(data: imgData)
        let image = UIImage.init(named: "back_arrow_white")
        
        self.imageView = UIImageView.init(image: image)
        
        
        // UIScrollView
        scrollView = UIScrollView.init(frame: GlobalValue.SCREENBOUND)
//        scrollView.contentSize = image!.size
        scrollView.autoresizingMask = [.flexibleHeight , .flexibleWidth]
        self.view.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        let (W , H) = (image!.size.width / scrollView.width ) > (image!.size.height / scrollView.height) ? (scrollView.width, image!.size.height / (image!.size.width / scrollView.width) ) : ( image!.size.width / (image!.size.height / scrollView.height), scrollView.height)
        
        self.imageView.frame = CGRect.init(x: self.imageView.frame.origin.x, y: self.imageView.frame.origin.y, width: W, height: CGFloat(H))
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = scrollView.zoomScale
        scrollView.maximumZoomScale = 4.0
//        scrollView.zoomScale = 1.0
        
        // dismiss btn
        
        let button = UIButton.init(frame: CGRect.init(x: 20, y: 20, width: 15, height: 20))
        button.setImage(UIImage.init(named: "back_arrow_white"), for: .normal)
        button.bk_(whenTapped: { [weak self] in
            if let weakSelf = self{
                weakSelf.dismiss(animated: true, completion: nil)
            }
        })
        self.view.addSubview(button)

        
        
        setZoomScale()
        setupDoubleTouchGesture()
    }
    
    
    
    func setupDoubleTouchGesture(){
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(handleDoubleTap))
        gesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(gesture)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    func setZoomScale(){
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthSacle = scrollViewSize.width / imageViewSize.width
        let heightSacle = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthSacle, heightSacle)
        scrollView.zoomScale = 1.0
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    
    func downloadImage(){
        if let url = URL.init(string: self.link){
            
            SDWebImageManager.shared().downloadImage(with: url, options: SDWebImageOptions.continueInBackground, progress: { (size1 , size2) -> Void in
            }, completed: { [weak self] (image, error, type, flag, url) in
                if let weakSelf = self{
                    if let image = image{
                        weakSelf.imageView.image = image
                    }
                }
            })

        }
    }
}

extension AGImageFullScreenDisplayVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)

    }
    
}
