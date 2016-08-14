//
//  MainMenuViewController.swift
//  SheepJump
//
//  Created by Nicholas Lechnowskyj on 2/10/16.
//  Copyright © 2016 Njl. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController, TransitionProtocol {

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = MainMenuScene(fileNamed: "MainMenuScene") {
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true;
            
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
        
    }
    
    func transitionToOtherViewController() {
        let c = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! GameViewController
        //self.presentViewController(GameViewController(), animated: true, completion: nil)
        self.navigationController?.pushViewController(c, animated: true)
        
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

protocol TransitionProtocol {
    func transitionToOtherViewController()
}