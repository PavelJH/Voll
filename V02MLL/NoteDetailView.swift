import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    @Binding var notes: [Note]
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    @State private var isNoteSaved = false

    var body: some View {
        VStack {
            TextEditor(text: $note.content)
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
        .navigationTitle("Note")
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

    private func saveNote() {
        guard !isNoteSaved else { return }
        isNoteSaved = true

        // Обновляем дату последнего изменения
        note.lastModifiedDate = Date()
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            let updatedNote = notes.remove(at: index)
            notes.insert(updatedNote, at: 0) // Перемещаем заметку наверх списка
            saveNotes()
        }
    }

    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(note: .constant(Note(content: "Sample Note")), notes: .constant([]))
    }
}
