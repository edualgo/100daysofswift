//
//  GameScene.swift
//  Project17
//
//  Created by Pham Anh Tuan on 8/17/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var startField: SKEmitterNode!
    private var player: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    private var possibleEnemy = ["ball", "hammer", "tv"]
    private var isGameOver = false
    private var timer: Timer?
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        startField = SKEmitterNode(fileNamed: "starfield")
        startField.position = CGPoint(x: 1024, y: 384)
        startField.advanceSimulationTime(10)
        startField.zPosition = -1
        addChild(startField)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        
        guard let playerTexture = player.texture else { return }
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    // MARK: - Extra Functions
    @objc private func createEnemy() {
        guard let enemyName = possibleEnemy.randomElement() else { return}
        
        let enemy = SKSpriteNode(imageNamed: enemyName)
        enemy.position = CGPoint(x: 2000, y: Int.random(in: 50...736))
        
        guard let enemyTexture = enemy.texture else { return }
        
        enemy.physicsBody = SKPhysicsBody(texture: enemyTexture, size: enemy.size)
        enemy.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        enemy.physicsBody?.categoryBitMask = 1
        enemy.physicsBody?.angularVelocity = 5
        enemy.physicsBody?.linearDamping = 0
        enemy.physicsBody?.angularDamping = 0
        addChild(enemy)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -200 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
}
