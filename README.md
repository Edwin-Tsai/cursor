# Tank Battle - iOS坦克大战游戏

这是一个使用Cursor和Xcode创建的iOS坦克大战游戏。

## 游戏特色

- 🎮 **经典坦克大战玩法** - 控制绿色坦克消灭红色敌人
- 🎯 **实时射击系统** - 点击火焰按钮发射子弹
- 🎪 **方向控制** - 使用方向按钮控制坦克移动
- 💥 **物理碰撞检测** - 真实的子弹和坦克碰撞效果
- 📊 **得分系统** - 击中敌人获得分数
- ❤️ **生命系统** - 3条生命，被击中减少生命值
- 🔄 **重新开始** - 游戏结束后可以重新开始

## 游戏操作

- **↑↓←→** 方向按钮：控制坦克移动
- **🔥** 火焰按钮：发射子弹
- **重新开始** 按钮：重新开始游戏

## 游戏规则

1. 控制绿色坦克（玩家）消灭红色坦克（敌人）
2. 每击中一个敌人得10分
3. 被敌人子弹击中或与敌人相撞会失去1条生命
4. 生命值为0时游戏结束
5. 敌人会自动向下移动并向玩家射击

## 项目结构

```
MyIOSApp/
├── ViewController.swift          # 主视图控制器（游戏界面）
├── TankGameScene.swift          # 游戏场景（SpriteKit）
├── AppDelegate.swift            # 应用程序委托
├── SceneDelegate.swift          # 场景委托
├── Main.storyboard             # 主界面故事板
├── LaunchScreen.storyboard     # 启动屏幕
├── Info.plist                 # 应用配置文件
└── Assets.xcassets/           # 应用资源
    ├── AppIcon.appiconset/    # 应用图标
    └── Contents.json          # 资源配置文件
```

## 技术特性

- ✅ 原生iOS游戏开发
- ✅ Swift编程语言
- ✅ SpriteKit游戏引擎
- ✅ 物理引擎碰撞检测
- ✅ 实时游戏循环
- ✅ 触摸控制界面
- ✅ 支持iPhone和iPad

## 开发环境要求

- macOS 12.0 或更高版本
- Xcode 14.0 或更高版本
- iOS 17.0 或更高版本作为部署目标

## 如何使用

### 1. 打开项目
```bash
# 在Xcode中打开项目
open MyIOSApp.xcodeproj
```

### 2. 配置开发者账户
- 在Xcode中，选择项目设置
- 在"Signing & Capabilities"标签页中配置您的开发者账户
- 或者选择"Automatically manage signing"

### 3. 运行游戏
- 选择一个iOS模拟器或连接真机
- 点击运行按钮(⌘+R)或选择Product > Run
- 开始游戏！

## 在Cursor中开发

1. **代码编辑**: 在Cursor中编辑Swift文件
2. **游戏逻辑**: 修改TankGameScene.swift调整游戏规则
3. **界面设计**: 使用Xcode的Interface Builder编辑Storyboard
4. **编译调试**: 使用Xcode进行编译和调试

## 游戏架构

### 核心组件
- **ViewController**: 游戏界面控制器，处理用户输入
- **TankGameScene**: 游戏场景，包含所有游戏逻辑
- **物理引擎**: 处理碰撞检测和物理模拟
- **游戏循环**: 实时更新游戏状态

### 游戏元素
- **玩家坦克**: 绿色方块，可移动和射击
- **敌人坦克**: 红色方块，自动移动和射击
- **子弹**: 黄色（玩家）和橙色（敌人）
- **墙壁**: 灰色边界，阻挡移动

## 扩展建议

1. **添加更多功能**
   - 不同类型的敌人
   - 道具系统（生命、武器升级）
   - 关卡系统
   - 音效和背景音乐

2. **优化游戏体验**
   - 添加粒子效果
   - 优化游戏平衡性
   - 添加游戏暂停功能
   - 保存最高分记录

3. **增强视觉效果**
   - 使用精美的游戏素材
   - 添加动画效果
   - 实现平滑的移动效果

## 学习资源

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SpriteKit Programming Guide](https://developer.apple.com/spritekit/)
- [Swift Programming Language](https://docs.swift.org/swift-book/)
- [iOS Game Development](https://developer.apple.com/games/)

## 许可证

本项目仅供学习和参考使用。

---

**使用Cursor和Xcode开发iOS游戏的最佳实践：**

1. 在Cursor中编写游戏逻辑代码，享受AI辅助编程
2. 在Xcode中进行界面设计和游戏调试
3. 使用Git进行版本控制
4. 定期测试游戏性能和用户体验
5. 持续优化游戏平衡性和可玩性 