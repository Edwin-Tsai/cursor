//
//  TankGameScene.swift
//  MyIOSApp
//
//  Created by 蔡晓辰 on 2025/6/20.
//

import SpriteKit

// MARK: - Game Direction
enum Direction {
    case up, down, left, right
}

// MARK: - Game Delegate
protocol TankGameDelegate: AnyObject {
    func didUpdateScore(_ newScore: Int)
    func didUpdateLives(_ newLives: Int)
}

class TankGameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    weak var gameDelegate: TankGameDelegate?
    
    private var playerTank: SKSpriteNode!
    private var enemies: [SKSpriteNode] = []
    private var bullets: [SKSpriteNode] = []
    private var enemyBullets: [SKSpriteNode] = []
    private var walls: [SKSpriteNode] = []
    
    private var score = 0
    private var lives = 3
    private var gameStarted = false
    
    // Physics Categories
    private let playerCategory: UInt32 = 0x1 << 0
    private let enemyCategory: UInt32 = 0x1 << 1
    private let bulletCategory: UInt32 = 0x1 << 2
    private let enemyBulletCategory: UInt32 = 0x1 << 3
    private let wallCategory: UInt32 = 0x1 << 4
    
    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        setupPhysics()
        setupGame()
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    private func setupGame() {
        backgroundColor = .black
        createPlayerTank()
        createWalls()
        spawnEnemies()
        startGameLoop()
    }
    
    // MARK: - Game Elements Creation
    private func createPlayerTank() {
        playerTank = SKSpriteNode(color: .green, size: CGSize(width: 30, height: 30))
        playerTank.position = CGPoint(x: size.width / 2, y: 100)
        playerTank.name = "playerTank"
        
        // Physics body
        playerTank.physicsBody = SKPhysicsBody(rectangleOf: playerTank.size)
        playerTank.physicsBody?.isDynamic = true
        playerTank.physicsBody?.categoryBitMask = playerCategory
        playerTank.physicsBody?.contactTestBitMask = enemyCategory | enemyBulletCategory
        playerTank.physicsBody?.collisionBitMask = wallCategory
        playerTank.physicsBody?.allowsRotation = false
        
        addChild(playerTank)
    }
    
    private func createWalls() {
        // Top wall
        let topWall = SKSpriteNode(color: .gray, size: CGSize(width: size.width, height: 10))
        topWall.position = CGPoint(x: size.width / 2, y: size.height - 5)
        topWall.name = "wall"
        setupWallPhysics(topWall)
        addChild(topWall)
        walls.append(topWall)
        
        // Bottom wall
        let bottomWall = SKSpriteNode(color: .gray, size: CGSize(width: size.width, height: 10))
        bottomWall.position = CGPoint(x: size.width / 2, y: 5)
        bottomWall.name = "wall"
        setupWallPhysics(bottomWall)
        addChild(bottomWall)
        walls.append(bottomWall)
        
        // Left wall
        let leftWall = SKSpriteNode(color: .gray, size: CGSize(width: 10, height: size.height))
        leftWall.position = CGPoint(x: 5, y: size.height / 2)
        leftWall.name = "wall"
        setupWallPhysics(leftWall)
        addChild(leftWall)
        walls.append(leftWall)
        
        // Right wall
        let rightWall = SKSpriteNode(color: .gray, size: CGSize(width: 10, height: size.height))
        rightWall.position = CGPoint(x: size.width - 5, y: size.height / 2)
        rightWall.name = "wall"
        setupWallPhysics(rightWall)
        addChild(rightWall)
        walls.append(rightWall)
    }
    
    private func setupWallPhysics(_ wall: SKSpriteNode) {
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = wallCategory
        wall.physicsBody?.collisionBitMask = playerCategory | enemyCategory | bulletCategory | enemyBulletCategory
    }
    
    private func spawnEnemies() {
        let spawnTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.spawnEnemy()
        }
        spawnTimer.fire()
    }
    
    private func spawnEnemy() {
        guard enemies.count < 5 else { return }
        
        let enemy = SKSpriteNode(color: .red, size: CGSize(width: 25, height: 25))
        let randomX = CGFloat.random(in: 50...(size.width - 50))
        enemy.position = CGPoint(x: randomX, y: size.height - 50)
        enemy.name = "enemy"
        
        // Physics body
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = bulletCategory | playerCategory
        enemy.physicsBody?.collisionBitMask = wallCategory
        enemy.physicsBody?.allowsRotation = false
        
        addChild(enemy)
        enemies.append(enemy)
        
        // Enemy movement
        let moveAction = SKAction.moveBy(x: 0, y: -100, duration: 2.0)
        let repeatAction = SKAction.repeatForever(moveAction)
        enemy.run(repeatAction)
        
        // Enemy shooting
        let shootTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.enemyShoot(enemy)
        }
    }
    
    // MARK: - Game Actions
    func moveTank(direction: Direction) {
        guard let tank = playerTank else { return }
        
        let moveDistance: CGFloat = 20
        var newPosition = tank.position
        
        switch direction {
        case .up:
            newPosition.y += moveDistance
        case .down:
            newPosition.y -= moveDistance
        case .left:
            newPosition.x -= moveDistance
        case .right:
            newPosition.x += moveDistance
        }
        
        // Boundary check
        let tankSize = tank.size.width / 2
        newPosition.x = max(tankSize, min(size.width - tankSize, newPosition.x))
        newPosition.y = max(tankSize, min(size.height - tankSize, newPosition.y))
        
        let moveAction = SKAction.move(to: newPosition, duration: 0.1)
        tank.run(moveAction)
    }
    
    func fireBullet() {
        guard let tank = playerTank else { return }
        
        let bullet = SKSpriteNode(color: .yellow, size: CGSize(width: 8, height: 8))
        bullet.position = CGPoint(x: tank.position.x, y: tank.position.y + 20)
        bullet.name = "bullet"
        
        // Physics body
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = enemyCategory | wallCategory
        bullet.physicsBody?.collisionBitMask = wallCategory
        bullet.physicsBody?.allowsRotation = false
        
        addChild(bullet)
        bullets.append(bullet)
        
        // Bullet movement
        let moveAction = SKAction.moveBy(x: 0, y: 300, duration: 1.0)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        bullet.run(sequence) {
            if let index = self.bullets.firstIndex(of: bullet) {
                self.bullets.remove(at: index)
            }
        }
    }
    
    private func enemyShoot(_ enemy: SKSpriteNode) {
        let bullet = SKSpriteNode(color: .orange, size: CGSize(width: 6, height: 6))
        bullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y - 15)
        bullet.name = "enemyBullet"
        
        // Physics body
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = enemyBulletCategory
        bullet.physicsBody?.contactTestBitMask = playerCategory | wallCategory
        bullet.physicsBody?.collisionBitMask = wallCategory
        bullet.physicsBody?.allowsRotation = false
        
        addChild(bullet)
        enemyBullets.append(bullet)
        
        // Bullet movement
        let moveAction = SKAction.moveBy(x: 0, y: -200, duration: 1.5)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        bullet.run(sequence) {
            if let index = self.enemyBullets.firstIndex(of: bullet) {
                self.enemyBullets.remove(at: index)
            }
        }
    }
    
    // MARK: - Game Loop
    private func startGameLoop() {
        gameStarted = true
    }
    
    func restartGame() {
        // Remove all game elements
        removeAllChildren()
        enemies.removeAll()
        bullets.removeAll()
        enemyBullets.removeAll()
        walls.removeAll()
        
        // Reset game state
        score = 0
        lives = 3
        gameStarted = false
        
        // Setup game again
        setupGame()
    }
    
    // MARK: - Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == playerCategory | enemyCategory {
            handlePlayerEnemyCollision(contact)
        } else if collision == bulletCategory | enemyCategory {
            handleBulletEnemyCollision(contact)
        } else if collision == playerCategory | enemyBulletCategory {
            handlePlayerEnemyBulletCollision(contact)
        } else if collision == bulletCategory | wallCategory || collision == enemyBulletCategory | wallCategory {
            handleBulletWallCollision(contact)
        }
    }
    
    private func handlePlayerEnemyCollision(_ contact: SKPhysicsContact) {
        let player = contact.bodyA.categoryBitMask == playerCategory ? contact.bodyA.node : contact.bodyB.node
        let enemy = contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node : contact.bodyB.node
        
        player?.removeFromParent()
        enemy?.removeFromParent()
        
        if let enemyNode = enemy, let index = enemies.firstIndex(of: enemyNode as! SKSpriteNode) {
            enemies.remove(at: index)
        }
        
        lives -= 1
        gameDelegate?.didUpdateLives(lives)
        
        if lives > 0 {
            createPlayerTank()
        }
    }
    
    private func handleBulletEnemyCollision(_ contact: SKPhysicsContact) {
        let bullet = contact.bodyA.categoryBitMask == bulletCategory ? contact.bodyA.node : contact.bodyB.node
        let enemy = contact.bodyA.categoryBitMask == enemyCategory ? contact.bodyA.node : contact.bodyB.node
        
        bullet?.removeFromParent()
        enemy?.removeFromParent()
        
        if let bulletNode = bullet, let index = bullets.firstIndex(of: bulletNode as! SKSpriteNode) {
            bullets.remove(at: index)
        }
        
        if let enemyNode = enemy, let index = enemies.firstIndex(of: enemyNode as! SKSpriteNode) {
            enemies.remove(at: index)
        }
        
        score += 10
        gameDelegate?.didUpdateScore(score)
    }
    
    private func handlePlayerEnemyBulletCollision(_ contact: SKPhysicsContact) {
        let player = contact.bodyA.categoryBitMask == playerCategory ? contact.bodyA.node : contact.bodyB.node
        let bullet = contact.bodyA.categoryBitMask == enemyBulletCategory ? contact.bodyA.node : contact.bodyB.node
        
        bullet?.removeFromParent()
        player?.removeFromParent()
        
        if let bulletNode = bullet, let index = enemyBullets.firstIndex(of: bulletNode as! SKSpriteNode) {
            enemyBullets.remove(at: index)
        }
        
        lives -= 1
        gameDelegate?.didUpdateLives(lives)
        
        if lives > 0 {
            createPlayerTank()
        }
    }
    
    private func handleBulletWallCollision(_ contact: SKPhysicsContact) {
        let bullet = contact.bodyA.categoryBitMask == bulletCategory || contact.bodyA.categoryBitMask == enemyBulletCategory ? contact.bodyA.node : contact.bodyB.node
        
        bullet?.removeFromParent()
        
        if let bulletNode = bullet {
            if bulletNode.name == "bullet", let index = bullets.firstIndex(of: bulletNode as! SKSpriteNode) {
                bullets.remove(at: index)
            } else if bulletNode.name == "enemyBullet", let index = enemyBullets.firstIndex(of: bulletNode as! SKSpriteNode) {
                enemyBullets.remove(at: index)
            }
        }
    }
} 