# 每日任务打卡程序

一个简单的 SwiftUI 每日任务打卡应用，帮助你养成好习惯。

## 功能特性

### 📋 页面 1：今日打卡
- 查看所有任务及其打卡状态
- 点击任务即可打卡/取消打卡
- 显示每个任务的连续打卡天数和总打卡次数
- 添加新任务时可选择图标（✅、📚、🏃、💪 等）
- 支持删除任务（向左滑动）

### 📊 页面 2：统计
- **概览卡片**：总任务数、总打卡次数
- **今日进度**：今日完成情况百分比
- **7 天趋势**：柱状图展示近 7 天打卡趋势
- **连续排行**：按连续打卡天数排序

### 💾 数据持久化
- 所有数据自动保存到本地 JSON 文件
- 下次打开应用时自动加载
- 数据存储位置：`Documents/daily_tasks.json`

## 技术栈

- **SwiftUI** - 现代声明式 UI 框架
- **Swift 6.0** - 最新 Swift 版本
- **Codable** - JSON 序列化
- **FileManager** - 本地文件存储
- 支持 **iOS 17+** 和 **macOS 14+**

## 项目结构

```
Sources/DailyCheck/
├── DailyCheckApp.swift      # 应用入口
├── ContentView.swift       # 主视图（TabView）
├── Models.swift           # 数据模型 + 存储逻辑
├── TodayView.swift        # 打卡页面
└── StatsView.swift        # 统计页面
```

## 运行方式

```bash
# 构建
swift build

# 运行（需要 Xcode 或 xtool）
# 通过 Xcode 打开 Package.swift 运行模拟器
```

## 使用示例

1. **添加任务**：点击右上角 "+"，输入任务名称，选择图标
2. **打卡**：点击任务行，绿色勾选表示已完成
3. **查看统计**：切换到"统计"标签页查看数据
4. **删除任务**：在打卡页面左滑任务，点击删除

## 数据模型

```swift
struct DailyTask {
    id: UUID
    title: String           // 任务标题
    emoji: String          // 图标
    createdAt: Date        // 创建时间
    completedDates: [String] // 已打卡日期列表 (yyyy-MM-dd)
}
```
