//
//  GameViewController.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/10/16.
//  Copyright (c) 2016 Njl. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

class GameViewController: UIViewController, ADBannerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
           // self.canDisplayBannerAds = true
            //loadAds()
            
            skView.presentScene(scene)
            
        }
    }
    
    func loadAds(){
        //iAd banner
        let banner = ADBannerView(frame: CGRect.zero)
        banner.delegate = self
        // banner.sizeToFit()
        banner.isHidden = false
        banner.center = CGPoint(x: banner.center.x, y: view.bounds.size.height - banner.frame.size.height / 2)
        view.addSubview(banner)
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        if(banner.isBannerLoaded){
            banner.frame = banner.frame.offsetBy(dx: 0, dy: banner.frame.size.height)
        }
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        banner.frame = banner.frame.offsetBy(dx: 0, dy: banner.frame.size.height)
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
