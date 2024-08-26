import SwiftUI

struct RemindersView: View {
    @State private var reminders: [Reminder] = []
    @State private var newReminderText: String = ""
    @State private var isAddingNewReminder = false
    @FocusState private var isFocused: Bool
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            VStack {
                if isAddingNewReminder {
                    HStack {
                        TextField("New Reminder", text: $newReminderText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isFocused)
                            .onSubmit {
                                saveNewReminder()
                            }
                            .padding()
                    }
                    .padding()
                }

                List {
                    ForEach($reminders) { $reminder in
                        ReminderRow(reminder: $reminder, toggleCompletion: {
                            toggleCompletion(for: reminder)
                        }, deleteReminder: {
                            deleteReminder(reminder)
                        })
                    }
                    .onMove(perform: moveReminder)
                }
                .environment(\.editMode, $editMode)

                Button(action: {
                    isAddingNewReminder = true
                    isFocused = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("New Reminder")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            .onAppear(perform: loadReminders)
            .hideKeyboardOnTap()
        }
    }

    private func saveNewReminder() {
        guard !newReminderText.isEmpty else { return }
        let newReminder = Reminder(text: newReminderText, isCompleted: false)
        reminders.insert(newReminder, at: 0) // Add new reminder at the top
        saveReminders()
        newReminderText = ""
        isAddingNewReminder = false
    }

    private func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        saveReminders()
    }

    private func moveReminder(from source: IndexSet, to destination: Int) {
        reminders.move(fromOffsets: source, toOffset: destination)
        saveReminders()
    }

    private func moveReminderToBottom(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            let movedReminder = reminders.remove(at: index)
            reminders.append(movedReminder)
            saveReminders()
        }
    }

    private func moveReminderToTop(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            let movedReminder = reminders.remove(at: index)
            reminders.insert(movedReminder, at: 0)
            saveReminders()
        }
    }

    private func toggleCompletion(for reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isCompleted.toggle()
            if reminders[index].isCompleted {
                moveReminderToBottom(reminders[index])
            } else {
                moveReminderToTop(reminders[index])
            }
        }
    }

    private func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: "reminders"),
           let decodedReminders = try? JSONDecoder().decode([Reminder].self, from: data) {
            reminders = decodedReminders
        }
    }

    private func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: "reminders")
        }
    }
}

struct RemindersView_Previews: PreviewProvider {
    static var previews: some View {
        RemindersView()
    }
}
