import SwiftUI

// MARK: - 单个任务模型
struct DailyTask: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var emoji: String = "✅"
    var createdAt: Date = Date()
    /// 已打卡日期集合 (yyyy-MM-dd)
    var completedDates: [String] = []

    /// 今天是否已打卡
    var isCheckedInToday: Bool {
        completedDates.contains(todayKey())
    }

    /// 连续打卡天数
    var currentStreak: Int {
        var count = 0
        var date = Date()
        let calendar = Calendar.current
        while true {
            let key = dateKey(for: date)
            if completedDates.contains(key) {
                count += 1
                guard let prev = calendar.date(byAdding: .day, value: -1, to: date) else { break }
                date = prev
            } else {
                break
            }
        }
        return count
    }
}

// MARK: - 数据存储
class TaskStore: ObservableObject {
    @Published var tasks: [DailyTask] = []

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("daily_tasks.json")
    }()

    init() {
        load()
    }

    // MARK: 增删改
    func addTask(title: String, emoji: String = "✅") {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let task = DailyTask(title: title, emoji: emoji)
        tasks.append(task)
        save()
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        save()
    }

    func deleteTask(_ task: DailyTask) {
        tasks.removeAll { $0.id == task.id }
        save()
    }

    /// 打卡 / 取消打卡
    func toggleCheckIn(_ task: DailyTask) {
        guard let idx = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        let key = todayKey()
        if tasks[idx].completedDates.contains(key) {
            tasks[idx].completedDates.removeAll { $0 == key }
        } else {
            tasks[idx].completedDates.append(key)
        }
        save()
    }

    // MARK: 统计
    /// 获取某天的打卡任务数
    func checkedCount(on date: Date) -> Int {
        let key = dateKey(for: date)
        return tasks.filter { $0.completedDates.contains(key) }.count
    }

    /// 总打卡次数
    var totalCheckIns: Int {
        tasks.reduce(0) { $0 + $1.completedDates.count }
    }

    /// 获取过去 N 天每天的完成情况
    func lastNDaysStats(n: Int) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return (0..<n).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!
            return (date, checkedCount(on: date))
        }
    }

    // MARK: 持久化
    func save() {
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("保存失败: \(error)")
        }
    }

    func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            tasks = try JSONDecoder().decode([DailyTask].self, from: data)
        } catch {
            print("加载失败: \(error)")
        }
    }
}

// MARK: - 日期工具
func todayKey() -> String {
    dateKey(for: Date())
}

func dateKey(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "zh_CN")
    return formatter.string(from: date)
}

// MARK: - 跨平台颜色
#if canImport(UIKit)
import UIKit
extension Color {
    static var appBackground: Color { Color(uiColor: .systemBackground) }
    static var appGroupedBackground: Color { Color(uiColor: .systemGroupedBackground) }
}
#elseif canImport(AppKit)
import AppKit
extension Color {
    static var appBackground: Color { Color(nsColor: .windowBackgroundColor) }
    static var appGroupedBackground: Color { Color(nsColor: .underPageBackgroundColor) }
}
#endif
