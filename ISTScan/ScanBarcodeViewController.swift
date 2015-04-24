//
//  ScanBarCode.swift
//  ISTScan
//
//  Created by Thamonwan choesuwan on 4/11/2558 BE.
//  Copyright (c) 2558 weeravit. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ScanBarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check network connected
        if(!IJReachability.isConnectedToNetwork()) {
            let alert = UIAlertController(title: "ไม่สามารถบันทึกข้อมูลได้", message: "คุณไม่ได้เชื่อมต่ออินเตอร์เน็ต ข้อมูลของคุณจะไม่ถูกบันทึก คุณต้องการทำต่อหรือไม่", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ตกลง", style: .Default, handler: {
                (action: UIAlertAction!) in
            }))
            alert.addAction(UIAlertAction(title: "ยกเลิก", style: .Default, handler: {
                (action: UIAlertAction!) in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // 1. AVCaptureDevice
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var error : NSError? = nil
        
        // 2. AVCaptureInput
        let input : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(device, error: &error) as? AVCaptureDeviceInput
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        if input != nil {
            session.addInput(input)
        } else {
            // This is fine for a demo, do something real with this in your app. :)
            println(error)
        }
        
        // 3. AVCaptureOutput
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output);
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(session) as! AVCaptureVideoPreviewLayer
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // display green line into screen center
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        self.highlightView.frame = CGRect(x: self.view.bounds.maxX*0.15, y: self.view.bounds.midY, width: self.view.bounds.maxX*0.7, height: 3) // [x,y = position]
        self.view.addSubview(self.highlightView)
        
        // 4. AVCaptureSession
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            for barcodeType in barCodeTypes {
                if metadata.type == barcodeType {
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    self.session.stopRunning()
                    break
                }
            }
        }
        
        // display barcode
        var label = UILabel()
        label.backgroundColor = UIColor.brownColor()
        label.text = detectionString;
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.frame = CGRect(x: self.view.bounds.maxX * 0.27, y: self.view.bounds.maxY * 0.9, width: 150, height: 30)
        label.layer.borderColor = UIColor.greenColor().CGColor
        label.layer.borderWidth = 2
        self.view.addSubview(label)
        
        if(IJReachability.isConnectedToNetwork()) {
            storeLogOnline(detectionString)
        }
        
        // Retry Capture
        self.session.startRunning()
    }
    
    func storeLogOnline(barcode : String!) {
        
        let parameters = [
            "student_id" : barcode,
            "subject_id" : shareSubject["id"].description,
            "lesson_id" : shareLesson["id"].description,
            "log_date" : shareDate
        ]
        
        Alamofire.request(.POST, "http://istscan.weeravit-it.com/webservice/storeLog.php", parameters: parameters)
    }

}
