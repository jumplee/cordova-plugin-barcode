import Foundation

 @objc(BarcodeScan) class BarcodeScan : CDVPlugin {
    var scanCallBackId :String!
   

    func scan(_ command:CDVInvokedUrlCommand){
//        let type = command.arguments[0] as? String ?? ""
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.inner;
        style.photoframeLineW = 2;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = false;
        
        style.anmiationStyle = LBXScanViewAnimationStyle.lineMove;
        
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        
        
        let vc = LBXScanViewController()
        vc.scanStyle = style
        vc.prePlugin = self
    
        self.viewController?.present(vc, animated: true,completion: nil)

        self.scanCallBackId=command.callbackId
    }

    func scanSuccess(_ code:String,type:String){
        let re :[String:String]=[
            "text":code,
            "format":type
        ]
        let pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs:re
        )
//        let pluginResult = CDVPluginResult(
//            status: CDVCommandStatus_OK,
//            messageAsString:code
//        )

        self.commandDelegate!.send(
            pluginResult,
            callbackId: self.scanCallBackId
        )
    }
    func cancelScan(){
                let pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_ERROR
                )
                self.commandDelegate!.send(
                    pluginResult,
                    callbackId: self.scanCallBackId
                )
    }
}
