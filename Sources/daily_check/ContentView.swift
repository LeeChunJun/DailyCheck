import SwiftUI

struct ContentView: View {
    @StateObject private var store = TaskStore()

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("打卡", systemImage: "checkmark.circle")
                }

            StatsView()
                .tabItem {
                    Label("统计", systemImage: "chart.bar.fill")
                }
        }
        .environmentObject(store)
    }
}
