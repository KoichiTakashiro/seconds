//
//  recordViewController.swift
//  seconds
//
//  Created by 高城晃一 on 2016/02/17.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class recordViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {

    //ビデオのアウトプット
    private var myVideoOutPut:AVCaptureMovieFileOutput!
    
    //スタート&ストップボタン
    private var myButtonStart : UIButton!
    private var myButtonStop : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //セッションの作成
        let mySession : AVCaptureSession = AVCaptureSession()
        
        //デバイス
        var myDevice : AVCaptureDevice?
        
        //出力先の生成
        let myImageOutput : AVCaptureStillImageOutput = AVCaptureStillImageOutput()
        
        
        //デバイス一覧の取得
        let devices = AVCaptureDevice.devices()
        
        //マイクを取得
        //マイクをセッションのInputに追加
        do{
            let audioCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
            let audioInput = try AVCaptureDeviceInput(device: audioCaptureDevice)
            if (mySession.canAddInput(audioInput)){
                mySession.addInput(audioInput)
            }
        }catch let error as NSError{
            print(error)
        }
        
        //バックライトをmyDeviceに格納
        for device in devices {
            if (device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        //バックカメラを取得
        do{
            let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            //ビデオをセッションのInputに追加
            if (mySession.canAddInput(videoInput)){
                mySession.addInput(videoInput)
            }
        }catch let error as NSError{
            print(error)
        }
        
        
        //セッションに出力先を追加
        mySession.addOutput(myImageOutput)
        
        //動画の保存
        myVideoOutPut = AVCaptureMovieFileOutput()
        
        //ビデオ出力をOutputに追加
        mySession.addOutput(myVideoOutPut)
        
        //画像を表示するレイヤーを生成
        let myVideoLayer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: mySession)
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //viewに追加
        self.view.layer.addSublayer(myVideoLayer)
        
        //セッション開始
        mySession.startRunning()
        
        // UIボタン作成
        myButtonStart = UIButton(frame: CGRectMake(0,0,120,50))
        myButtonStop = UIButton(frame: CGRectMake(0,0,120,50))
        
        myButtonStart.backgroundColor = UIColor.redColor()
        myButtonStop.backgroundColor = UIColor.grayColor()
        
        myButtonStart.layer.masksToBounds = true
        myButtonStop.layer.masksToBounds = true
        
        myButtonStart.setTitle("撮影", forState: .Normal)
        myButtonStop.setTitle("停止", forState: .Normal)
        
        myButtonStart.layer.cornerRadius = 20
        myButtonStop.layer.cornerRadius = 20
        
        
        myButtonStart.layer.position = CGPoint(x: self.view.bounds.width/2 - 70, y: self.view.bounds.height-50)
        myButtonStop.layer.position = CGPoint(x: self.view.bounds.width/2 + 70, y: self.view.bounds.height-50)
        
        myButtonStart.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        myButtonStop.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        //UIボタンをViewに追加
        self.view.addSubview(myButtonStart)
        self.view.addSubview(myButtonStop)
    }
    
    //ボタンイベント
    internal func onClickMyButton(sender:UIButton){
        //撮影開始
        if sender == myButtonStart {
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            
            //フォルダ
            let documentsDirectory = paths[0] as! String
            
            //ファイル名
            let filePath:String? = "\(documentsDirectory)/test.mp4"
            
            //URL
            let fileURL:NSURL = NSURL(fileURLWithPath: filePath!)
            print("ファイルURLは\(fileURL)")
            
            //録画開始
            myVideoOutPut.startRecordingToOutputFileURL(fileURL, recordingDelegate: self)
            
        } else if sender == myButtonStop {
            myVideoOutPut.stopRecording()
            
        }
    }
    
    //動画がキャプチャーされた後に呼ばれるメソッド
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        print("didFinishRecordingToOutputFileAtURL")
        //AssetsLibraryを生成
        let assetsLib = ALAssetsLibrary()
        
        //動画のパスから動画をフォトライブラリに保存する
        assetsLib.writeVideoAtPathToSavedPhotosAlbum(outputFileURL, completionBlock: nil)
        
    }
    
    //動画のキャプチャーが開始された時に呼ばれるメソッド
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print("didStartRecordingToOutputFileAtURL")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
