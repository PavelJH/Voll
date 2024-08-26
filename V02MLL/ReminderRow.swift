import SwiftUI

struct ReminderRow: View {
    @Binding var reminder: Reminder
    var toggleCompletion: () -> Void
    var deleteReminder: () -> Void

    var body: some View {
        HStack {
            Button(action: toggleCompletion) {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(reminder.isCompleted ? .green : .gray)
            }

            Text(reminder.text)
                .strikethrough(reminder.isCompleted, color: .gray)
                .foregroundColor(reminder.isCompleted ? .gray : .primary)
        }
        .swipeActions {
            Button(role: .destructive, action: deleteReminder) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
