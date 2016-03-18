//
//  GameScene.swift
//  BlockSpawnThenCollect
//
//  Created by Greg Willis on 3/17/16.
//  Copyright (c) 2016 Willis Programming. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var block: SKSpriteNode!
    var floor: SKSpriteNode!
    var mainLabel: UILabel!
    var scoreLabel: SKLabelNode!
    var blockColor: UIColor!
    var baseColor = 0.5
    var offWhiteColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    var darkGrayColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
    var isSpawning = true
    var isAlive = true
    var touchLocation: CGPoint!
    var score = 0
    var timer = 6
    
    override func didMoveToView(view: SKView) {
        backgroundColor = darkGrayColor
        let physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody = physicsBody
        spawnFloor()
        mainLabel = spawnMainLabel()
        scoreLabel = spawnScoreLabel()
        spawnCollectTimer()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            touchLocation = touch.locationInNode(self)
            
            if isAlive {
                if isSpawning {
                    spawnBlock()
                    addToScore()
                } else {
                    collectBlock()
                }
            }
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}

// MARK: - Spawn Functions
extension GameScene {
    
    func spawnBlock() {
        let red = CGFloat(arc4random_uniform(127)) / 255 + 0.4
        let green = CGFloat(arc4random_uniform(127)) / 255 + 0.4
        let blue = CGFloat(arc4random_uniform(127)) / 255 + 0.4
        blockColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        block = SKSpriteNode(color: blockColor, size: CGSize(width: 50, height: 50))
        block.position = touchLocation
        block.name = "block"
        block.physicsBody = SKPhysicsBody(rectangleOfSize: block.size)
        block.physicsBody?.affectedByGravity = true
        addChild(block)
    }
    
    func spawnFloor() {
        floor = SKSpriteNode(color: offWhiteColor, size: CGSize(width: frame.width, height: 200))
        floor.position = CGPoint(x: CGRectGetMidX(frame), y: 0)
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: floor.size)
        floor.physicsBody?.affectedByGravity = false
        floor.physicsBody?.dynamic = false
        addChild(floor)
    }
    
    func spawnMainLabel() -> UILabel {
        mainLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view!.frame.width, height: view!.frame.height * 0.4))
        if let mainLabel = mainLabel {
            mainLabel.textColor = offWhiteColor
            mainLabel.font = UIFont(name: "Avenir", size: CGRectGetWidth(frame) * 0.14)
            mainLabel.textAlignment = .Center
            mainLabel.numberOfLines = 0
            mainLabel.text = "Start"
            view!.addSubview(mainLabel)
        }
        return mainLabel
    }
    
    func spawnScoreLabel() -> SKLabelNode {
        scoreLabel = SKLabelNode(fontNamed: "Avenir")
        scoreLabel.fontColor = offWhiteColor
        scoreLabel.fontSize = CGRectGetWidth(frame) * 0.15
        scoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMaxY(frame) * 0.2)
        scoreLabel.text = "Score: \(score)"
        
        addChild(scoreLabel)
        
        
        return scoreLabel
    }
}

// MARK: - Collect Function
extension GameScene {
    
    func collectBlock() {
         if let touchedNode = nodeAtPoint(touchLocation) as? SKSpriteNode {
            if touchedNode.name == "block" {
                touchedNode.removeFromParent()
                addToScore()
            }
        }
    }
}

// MARK: - Timer Functions
extension GameScene {
    
    func spawnCollectTimer() {
        let wait = SKAction.waitForDuration(1.0)
        let countDown = SKAction.runBlock {
            self.timer--
            
            if self.timer <= 5 && self.timer >= 0 {
                self.mainLabel.text = "\(self.timer)"
            }
            if self.timer < 0 {
                if self.isSpawning {
                    self.isSpawning = false
                    self.timer = 6
                } else {
                    self.isAlive = false
                    self.gameOver()
                }
            }

        }
        let sequence = SKAction.sequence([wait, countDown])
        runAction(SKAction.repeatActionForever(sequence))
    }
}

// MARK: - Helper Functions
extension GameScene {
    
    func addToScore() {
        score++
        scoreLabel.text = "Score: \(score)"
    }
    
    func gameOver() {
        timer = 0
        mainLabel.text = "Game Over"
        
        let wait = SKAction.waitForDuration(3.0)
        let transition = SKAction.runBlock {
            self.mainLabel.removeFromSuperview()
            if let titleScene = TitleScene(fileNamed: "TitleScene"), view = self.view {
                titleScene.scaleMode = .ResizeFill
                view.presentScene(titleScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        }
        runAction(SKAction.sequence([wait, transition]))
    }
}