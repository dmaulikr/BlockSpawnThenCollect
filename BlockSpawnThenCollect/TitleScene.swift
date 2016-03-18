//
//  TitleScene.swift
//  BlockSpawnThenCollect
//
//  Created by Greg Willis on 3/18/16.
//  Copyright © 2016 Willis Programming. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene : SKScene {
    
    var playButton: UIButton!
    var gameTitle: SKLabelNode!
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    var darkGrayColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    
    override func didMoveToView(view: SKView) {
        backgroundColor = darkGrayColor
        setUpText()
    }
    
    func setUpText() {
        gameTitle = SKLabelNode(fontNamed: "Avenir")
        gameTitle.fontSize = 50
        gameTitle.fontColor = offWhiteColor
        gameTitle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        gameTitle.text = "Boring!"
        addChild(gameTitle)
        
        playButton = UIButton(frame: CGRect(x: 100, y: 100, width: 500, height: 100))
        playButton.center = CGPoint(x: (view?.frame.size.width)! / 2, y: (view?.frame.size.height)! * 0.85)
        playButton.titleLabel?.font = UIFont(name: "Avenir", size: 50)
        playButton.setTitle("Play", forState: UIControlState.Normal)
        playButton.setTitleColor(offWhiteColor, forState: UIControlState.Normal)
        playButton.addTarget(self, action: Selector("playTheGame"), forControlEvents: UIControlEvents.TouchUpInside)
        view!.addSubview(playButton)
    }
    
    func playTheGame() {
        gameTitle.removeFromParent()
        playButton.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            skView.presentScene(scene)
        }
    }
    
}