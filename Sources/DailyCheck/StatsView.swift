import SwiftUI

struct StatsView: View {
    @EnvironmentObject var store: TaskStore

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    overviewSection
                    todayProgressSection
                    weeklyTrendSection
                    streakRankingSection
                }
                .padding()
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("统计")
        }
    }

    // MARK: - 概览卡片
    private var overviewSection: some View {
        HStack(spacing: 16) {
            StatCard(
                icon: "list.bullet.clipboard",
                color: .blue,
                title: "总任务",
                value: "\(store.tasks.count)"
            )
            StatCard(
                icon: "checkmark.seal.fill",
                color: .green,
                title: "总打卡",
                value: "\(store.totalCheckIns)"
            )
        }
    }

    // MARK: - 今日完成情况
    private var todayProgressSection: some View {
        let todayCount = store.checkedCount(on: Date())
        let todayRate: Double = store.tasks.isEmpty ? 0.0 : Double(todayCount) / Double(store.tasks.count)

        return VStack(spacing: 12) {
            HStack {
                Text("今日完成")
                    .font(.headline)
                Spacer()
                Text("\(todayCount) / \(store.tasks.count)")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
            }

            ProgressView(value: todayRate)
                .tint(.green)

            Text("完成 \(Int(todayRate * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.appBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    // MARK: - 近7天趋势
    private var weeklyTrendSection: some View {
        let stats = store.lastNDaysStats(n: 7)
        let maxCount = max(stats.map(\.count).max() ?? 1, 1)

        return VStack(alignment: .leading, spacing: 12) {
            Text("近 7 天打卡趋势")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(stats.enumerated()), id: \.offset) { _, stat in
                    VStack(spacing: 4) {
                        Text("\(stat.count)")
                            .font(.caption2)
                            .foregroundColor(.secondary)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(stat.count > 0 ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                            .frame(
                                width: 28,
                                height: max(CGFloat(stat.count) / CGFloat(maxCount) * 100, 4)
                            )

                        Text(weekdayShort(stat.date))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .padding()
        .background(Color.appBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }

    // MARK: - 连续打卡排行
    @ViewBuilder
    private var streakRankingSection: some View {
        if !store.tasks.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("🔥 连续打卡排行")
                    .font(.headline)

                ForEach(store.tasks.sorted(by: { $0.currentStreak > $1.currentStreak })) { task in
                    HStack {
                        Text(task.emoji)
                        Text(task.title)
                            .font(.subheadline)
                        Spacer()
                        Text("\(task.currentStreak) 天")
                            .font(.subheadline.bold())
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .background(Color.appBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4)
        }
    }

    private func weekdayShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "EE"
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let icon: String
    let color: Color
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.appBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4)
    }
}
