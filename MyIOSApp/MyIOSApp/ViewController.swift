//
//  ViewController.swift
//  MyIOSApp
//
//  Created by 蔡晓辰 on 2025/6/20.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let gameView: SKView = {
        let view = SKView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "得分: 0"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let livesLabel: UILabel = {
        let label = UILabel()
        label.text = "生命: 3"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let controlPanel: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let upButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("↑", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("↓", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("→", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fireButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔥", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("重新开始", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    private var gameScene: TankGameScene!
    private var score = 0
    private var lives = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupGame()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(gameView)
        view.addSubview(scoreLabel)
        view.addSubview(livesLabel)
        view.addSubview(controlPanel)
        
        controlPanel.addSubview(upButton)
        controlPanel.addSubview(downButton)
        controlPanel.addSubview(leftButton)
        controlPanel.addSubview(rightButton)
        controlPanel.addSubview(fireButton)
        controlPanel.addSubview(restartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Game View
            gameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gameView.bottomAnchor.constraint(equalTo: controlPanel.topAnchor, constant: -20),
            
            // Score Label
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 100),
            scoreLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Lives Label
            livesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            livesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            livesLabel.widthAnchor.constraint(equalToConstant: 100),
            livesLabel.heightAnchor.constraint(equalToConstant: 30),
            
            // Control Panel
            controlPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            controlPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            controlPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            controlPanel.heightAnchor.constraint(equalToConstant: 120),
            
            // Direction Buttons
            upButton.centerXAnchor.constraint(equalTo: controlPanel.centerXAnchor),
            upButton.topAnchor.constraint(equalTo: controlPanel.topAnchor, constant: 10),
            upButton.widthAnchor.constraint(equalToConstant: 50),
            upButton.heightAnchor.constraint(equalToConstant: 50),
            
            downButton.centerXAnchor.constraint(equalTo: controlPanel.centerXAnchor),
            downButton.bottomAnchor.constraint(equalTo: controlPanel.bottomAnchor, constant: -10),
            downButton.widthAnchor.constraint(equalToConstant: 50),
            downButton.heightAnchor.constraint(equalToConstant: 50),
            
            leftButton.leadingAnchor.constraint(equalTo: controlPanel.leadingAnchor, constant: 20),
            leftButton.centerYAnchor.constraint(equalTo: controlPanel.centerYAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: 50),
            leftButton.heightAnchor.constraint(equalToConstant: 50),
            
            rightButton.trailingAnchor.constraint(equalTo: controlPanel.trailingAnchor, constant: -20),
            rightButton.centerYAnchor.constraint(equalTo: controlPanel.centerYAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: 50),
            rightButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Fire Button
            fireButton.trailingAnchor.constraint(equalTo: controlPanel.trailingAnchor, constant: -80),
            fireButton.centerYAnchor.constraint(equalTo: controlPanel.centerYAnchor),
            fireButton.widthAnchor.constraint(equalToConstant: 60),
            fireButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Restart Button
            restartButton.leadingAnchor.constraint(equalTo: controlPanel.leadingAnchor, constant: 80),
            restartButton.centerYAnchor.constraint(equalTo: controlPanel.centerYAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 80),
            restartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupActions() {
        upButton.addTarget(self, action: #selector(moveUp), for: .touchDown)
        downButton.addTarget(self, action: #selector(moveDown), for: .touchDown)
        leftButton.addTarget(self, action: #selector(moveLeft), for: .touchDown)
        rightButton.addTarget(self, action: #selector(moveRight), for: .touchDown)
        fireButton.addTarget(self, action: #selector(fire), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
    }
    
    private func setupGame() {
        gameScene = TankGameScene(size: gameView.bounds.size)
        gameScene.scaleMode = .aspectFill
        gameScene.gameDelegate = self
        gameView.presentScene(gameScene)
        
        // 启用调试信息（可选）
        gameView.showsFPS = true
        gameView.showsNodeCount = true
    }
    
    // MARK: - Game Actions
    @objc private func moveUp() {
        gameScene.moveTank(direction: .up)
    }
    
    @objc private func moveDown() {
        gameScene.moveTank(direction: .down)
    }
    
    @objc private func moveLeft() {
        gameScene.moveTank(direction: .left)
    }
    
    @objc private func moveRight() {
        gameScene.moveTank(direction: .right)
    }
    
    @objc private func fire() {
        gameScene.fireBullet()
    }
    
    @objc private func restartGame() {
        score = 0
        lives = 3
        updateUI()
        gameScene.restartGame()
    }
    
    private func updateUI() {
        scoreLabel.text = "得分: \(score)"
        livesLabel.text = "生命: \(lives)"
    }
}

// MARK: - TankGameDelegate
extension ViewController: TankGameDelegate {
    func didUpdateScore(_ newScore: Int) {
        score = newScore
        updateUI()
    }
    
    func didUpdateLives(_ newLives: Int) {
        lives = newLives
        updateUI()
        
        if lives <= 0 {
            showGameOver()
        }
    }
    
    private func showGameOver() {
        let alert = UIAlertController(
            title: "游戏结束",
            message: "最终得分: \(score)\n点击重新开始继续游戏",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "重新开始", style: .default) { _ in
            self.restartGame()
        })
        present(alert, animated: true)
    }
} 