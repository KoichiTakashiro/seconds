//
//  checkViewController.swift
//  seconds
//
//  Created by 高城晃一 on 2016/02/17.
//  Copyright © 2016年 KoichiTakashiro. All rights reserved.
//

import UIKit
import MediaPlayer

class checkViewController: UIViewController {

    //MPMoviePlayerViewControllerの宣言
    var myMoviePlayerView:MPMoviePlayerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンの作成
        let myButton = UIButton()
        myButton.frame.size = CGSize(width: 100, height: 40)
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = 20.0
        myButton.backgroundColor = UIColor.orangeColor()
        myButton.setTitle("動画再生", forState: .Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myButton.setTitleShadowColor(UIColor.grayColor(), forState: .Normal)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myButton)
    }
    
    //ボタンクリックイベント
    func onClickMyButton(sender:UIButton){
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        //フォルダ
        let documentsDirectory = paths[0] as! String
        
        //ファイル名
        let filePath:String? = "\(documentsDirectory)/test.mp4"
        
        //動画のパス
        var myMoviePath = filePath
        //var myMoviePath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("sample", ofType: "mov")!)
        
        //MPMoviePlayerViewControllerのインスタンスを生成
        myMoviePlayerView = MPMoviePlayerViewController(contentURL: NSURL(string: myMoviePath!))
        
        // 動画の再生が終了した時のお知らせ
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayBackDidFinish:",
            name: MPMoviePlayerPlaybackDidFinishNotification, object: myMoviePlayerView.moviePlayer)
        
        //画面遷移
        self.presentViewController(myMoviePlayerView, animated: true, completion: nil)
    }
    
    //動画の再生が終了した時に呼ばれるメソッド
    func moviePlayBackDidFinish(notification:NSNotification){
        print("moviePlayBackDidFinish:")
        
        //通知があったらnotificationを削除
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
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
