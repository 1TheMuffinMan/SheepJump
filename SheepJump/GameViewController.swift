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
            scene.scaleMode = .AspectFill
            
            self.canDisplayBannerAds = true
            loadAds()
            
            skView.presentScene(scene)
            
        }
    }
    
    func loadAds(){
        //iAd banner
        let banner = ADBannerView(frame: CGRectZero)
        banner.delegate = self
        // banner.sizeToFit()
        banner.hidden = false
        banner.center = CGPoint(x: banner.center.x, y: view.bounds.size.height - banner.frame.size.height / 2)
        view.addSubview(banner)
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        if(banner.bannerLoaded){
            banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height)
        }
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
