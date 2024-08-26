import SwiftUI

struct NotesView: View {
    @State private var notes: [Note] = []
    @State private var showNewNoteView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notesByDate.keys.sorted(by: >), id: \.self) { date in
                        Section(header: Text(dateFormatted(date))) {
                            ForEach(notesByDate[date]!, id: \.id) { note in
                                NavigationLink(destination: NoteDetailView(note: $notes[getIndex(of: note)], notes: $notes)) {
                                    Text(note.content)
                                        .lineLimit(1)
                                }
                            }
                            .onDelete { offsets in
                                deleteNote(at: offsets, for: date)
                            }
                        }
                    }
                }

                Button(action: {
                    showNewNoteView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("New Note")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $showNewNoteView) {
                    NewNoteView(notes: $notes)
                }
            }
            .navigationTitle("Notes")
            .onAppear(perform: loadNotes)
        }
    }

    private var notesByDate: [Date: [Note]] {
        Dictionary(grouping: notes, by: { Calendar.current.startOfDay(for: $0.lastModifiedDate) })
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    private func deleteNote(at offsets: IndexSet, for date: Date) {
        if let index = offsets.first {
            notes.removeAll { $0.id == notesByDate[date]?[index].id }
            saveNotes()
        }
    }

    private func getIndex(of note: Note) -> Int {
        return notes.firstIndex { $0.id == note.id } ?? 0
    }

    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes
        }
    }

    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
