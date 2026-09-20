import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: TaskStore
    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            List {
                if store.tasks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("还没有任务")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("点击右上角 + 添加第一个任务")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listRowInsets(EdgeInsets())
                } else {
                    ForEach(store.tasks) { task in
                        TaskRow(task: task)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    store.toggleCheckIn(task)
                                }
                            }
                    }
                    .onDelete(perform: store.deleteTask)
                }
            }
            .navigationTitle("今日打卡")
            .toolbar {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddTaskView()
            }
        }
    }
}

struct TaskRow: View {
    let task: DailyTask

    var body: some View {
        HStack(spacing: 16) {
            Text(task.emoji)
                .font(.title)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)

                HStack(spacing: 8) {
                    Label("\(task.currentStreak)", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundColor(.orange)

                    Text("共 \(task.completedDates.count) 次")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if task.isCheckedInToday {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Image(systemName: "circle")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddTaskView: View {
    @EnvironmentObject var store: TaskStore
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var emoji = "✅"

    let emojis = ["✅", "📚", "🏃", "💪", "🎯", "💧", "🍎", "🎵", "✍️", "🌅"]

    var body: some View {
        NavigationView {
            Form {
                Section("任务名称") {
                    TextField("例如：阅读30分钟", text: $title)
                }

                Section("选择图标") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                        ForEach(emojis, id: \.self) { e in
                            Text(e)
                                .font(.title)
                                .padding(8)
                                .background(emoji == e ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    emoji = e
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("添加任务")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        store.addTask(title: title, emoji: emoji)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
