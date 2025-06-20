//
//  ViewController.swift
//  MyIOSApp
//
//  Created by 蔡晓辰 on 2025/6/20.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎使用我的iOS应用！"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("点击我", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.text = "点击次数: 0"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private var clickCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(helloLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(actionButton)
        view.addSubview(counterLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Hello World Label
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            helloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            helloLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Welcome Label
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Action Button
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 200),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Counter Label
            counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            counterLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 30),
            counterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            counterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        clickCount += 1
        counterLabel.text = "点击次数: \(clickCount)"
        
        // 添加按钮动画效果
        UIView.animate(withDuration: 0.1, animations: {
            self.actionButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.actionButton.transform = CGAffineTransform.identity
            }
        }
        
        // 显示提示信息
        let alert = UIAlertController(
            title: "Hello World! 👋", 
            message: "您点击了按钮 \(clickCount) 次\n欢迎使用iOS开发！", 
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
} 