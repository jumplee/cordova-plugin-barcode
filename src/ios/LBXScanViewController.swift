//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class LBXScanViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate {
    
    var scanObj:LBXScanWrapper?
    
    var scanStyle:LBXScanViewStyle? = LBXScanViewStyle()
    
    var qRScanView:LBXScanView?
    
    //启动区域识别功能
    var isOpenInterestRect = false
    
    var prePlugin:BarcodeScan!
    
    //识别码的类型
    var arrayCodeType:[String]?
    
    //是否需要识别后的当前图像
    var isNeedCodeImage = false

    fileprivate let presentingAnimator = PushAnimation()
    
    fileprivate let hideAnimator =  PopAnimation()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return hideAnimator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
              // [self.view addSubview:_qRScanView];
        self.view.backgroundColor = UIColor.black
        self.transitioningDelegate=self
       
        self.edgesForExtendedLayout = UIRectEdge()
            
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        drawScanView()
       
        perform(#selector(LBXScanViewController.startScan), with: nil, afterDelay: 0.3)
        
    }
    
    func startScan()
    {
        if(!LBXPermissions .isGetCameraPermission())
        {
            showMsg("提示", message: "没有相机权限，请到设置->隐私中开启本程序相机权限")
            return;
        }
        
        if (scanObj == nil)
        {
            var cropRect = CGRect.zero
            if isOpenInterestRect
            {
                cropRect = LBXScanView.getScanRectWithPreView(self.view, style:scanStyle! )
            }
            
            //识别各种码，
            //let arrayCode = LBXScanWrapper.defaultMetaDataObjectTypes()
            
            //指定识别几种码
            if arrayCodeType == nil
            {
                arrayCodeType = [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code]
            }
            
            scanObj = LBXScanWrapper(videoPreView: self.view,objType:arrayCodeType!, isCaptureImg: isNeedCodeImage,cropRect:cropRect, success: { [weak self] (arrayResult) -> Void in
                
                if let strongSelf = self
                {
                    //停止扫描动画
                    strongSelf.qRScanView?.stopScanAnimation()
                    
                    strongSelf.handleCodeResult(arrayResult)
                }
             })
        }
        
        //结束相机等待提示
        qRScanView?.deviceStopReadying()
        
        //开始扫描动画
        qRScanView?.startScanAnimation()
        
        //相机运行
        scanObj?.start()
    }
    
    func drawScanView()
    {
        if qRScanView == nil
        {
            qRScanView = LBXScanView(frame: self.view.frame,vstyle:scanStyle! )
            self.view.addSubview(qRScanView!)
        }
//        var  toolbarView = UIView()
//        var toolbar = UIToolbar()
//        var btn = UIBarButtonItem()
        
//        toolbar.setItems(<#T##items: [UIBarButtonItem]?##[UIBarButtonItem]?#>, animated: true)
        
//        let yMax = CGRectGetMaxY(self.view.frame) - CGRectGetMinY(self.view.frame)
        
        let bottomItemsView = UIView(frame:CGRect( x: 0.0, y: 0,width: self.view.frame.size.width, height: 62 ) )
        
        
        bottomItemsView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.8)
        
        
        let btn = UIButton(frame:CGRect(origin: CGPoint(x: 5, y: 18.0), size: CGSize(width: 65,height: 44)))
           btn.setImage(UIImage(named: "CodeScan.bundle/back"),for: UIControlState())
     
        btn.addTarget(self, action: #selector(self.cancel), for: UIControlEvents.touchUpInside)
        bottomItemsView.addSubview(btn)
        
        //如果是ios8及以上机型可以使用从图片中识别二维码
        //ios8以上显示从相册查看
        if #available(iOS 8.0, *) {
            //从相册选择
            let photoBtn = UIButton(frame:CGRect(origin: CGPoint(x: self.view.frame.size.width-60, y: 16.0), size: CGSize(width: 60,height: 50)))
            photoBtn.setTitle("相册",for: UIControlState())
            photoBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1 , alpha: 1), for: UIControlState())
            photoBtn.addTarget(self, action: #selector(QQScanViewController.openPhotoAlbum), for: UIControlEvents.touchUpInside)
            bottomItemsView.addSubview(photoBtn)
        }

        
        
        self.view.addSubview(bottomItemsView)

        qRScanView?.deviceStartReadying("相机启动中...")
        
    }
    func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     处理扫码结果，如果是继承本控制器的，可以重写该方法,作出相应地处理
     */
    func handleCodeResult(_ arrayResult:[LBXScanResult])
    {
        for result:LBXScanResult in arrayResult
        {
            print("%@",result.strScanned)
        }
        
        let result:LBXScanResult = arrayResult[0]
        print(result.strScanned);
        
//        self.navigationController?.popViewControllerAnimated(true)
//       self.dismissViewControllerAnimated(true, completion: )
        self.dismiss(animated: true) { 
           let hello = self.prePlugin
            hello?.scanSuccess(result.strScanned!,type:result.strBarCodeType!)
        }
        
        
//        showMsg(result.strBarCodeType, message: result.strScanned)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        qRScanView?.stopScanAnimation()
        
        scanObj?.stop()
    }
    
    func openPhotoAlbum()
    {
        if(!LBXPermissions.isGetPhotoPermission())
        {
            showMsg("提示", message: "没有相册权限，请到设置->隐私中开启本程序相册权限")
        }
        
        let picker = UIImagePickerController()
        
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        picker.delegate = self;
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        
        var image:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if (image == nil )
        {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        if(image != nil)
        {
            let arrayResult = LBXScanWrapper.recognizeQRImage(image!)
            if arrayResult.count > 0
            {
                handleCodeResult(arrayResult)
                return
            }
        }
      
        showMsg("", message: "识别失败")
    }
    
    func showMsg(_ title:String?,message:String?)
    {
        if LBXScanWrapper.isSysIos8Later()
        {
        
            //if #available(iOS 8.0, *)
            
            if #available(iOS 8.0, *) {
                let alertAction = UIAlertAction(title:  "知道了", style: UIAlertActionStyle.default) { [weak self] (alertAction) -> Void in
                    
                    if let strongSelf = self
                    {
                        strongSelf.startScan()
                    }
                }
                let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(alertAction)
                
                present(alertController, animated: true, completion: nil)
            } else {
                 UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "好").show()
            }
           
        }
    }
    deinit
    {
        print("LBXScanViewController deinit")
    }
    
}





