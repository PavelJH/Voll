import SwiftUI

struct NewNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var notes: [Note]
    @State private var noteContent: String = ""
    @FocusState private var isFocused: Bool
    @State private var isNoteSaved = false

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $noteContent)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                    .focused($isFocused)
                    .onChange(of: isFocused) { focused in
                        if !focused {
                            saveNote()
                        }
                    }

                Spacer()
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        saveNote()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .hideKeyboardOnTap()
        }
    }

    private func saveNote() {
        guard !isNoteSaved else { return }
        isNoteSaved = true

        let newNote = Note(content: noteContent)
        if !noteContent.isEmpty {
            notes.insert(newNote, at: 0) // Добавляем новую заметку в начало списка
            saveNotes()
        }
    }

    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
}

struct NewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView(notes: .constant([]))
    }
}
