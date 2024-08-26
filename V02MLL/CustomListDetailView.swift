import SwiftUI

struct CustomListDetailView: View {
    @Binding var list: CustomList
    @Binding var lists: [CustomList]
    @State private var newItemText: String = ""

    var body: some View {
        VStack {
            List {
                ForEach(Array(zip(list.items.indices, $list.items)), id: \.0) { index, $item in
                    HStack {
                        Button(action: {
                            toggleCompletion(for: index)
                        }) {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(item.isCompleted ? .green : .gray)
                            
                        }

                        TextField("Item", text: $item.text)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    .contentShape(Rectangle()) // Добавляем это, чтобы весь HStack реагировал на нажатие
                    .onTapGesture {
                        toggleCompletion(for: index)
                        
                    }
                }
                .onDelete(perform: deleteItem)
                .onMove(perform: moveItem)
                
            }
            .listStyle(GroupedListStyle())
               
            
            .navigationTitle(list.name)
            .onDisappear(perform: saveLists)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }

            HStack {
                TextField("New Item", text: $newItemText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addItem) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    private func addItem() {
        guard !newItemText.isEmpty else { return }
        list.items.append(ListItemModel(text: newItemText))
        newItemText = ""
        saveLists()
    }

    private func toggleCompletion(for index: Int) {
        list.items[index].isCompleted.toggle()
        if list.items[index].isCompleted {
            moveCompletedItemToBottom(at: index)
        } else {
            moveItemToTop(at: index)
        }
    }

    private func moveCompletedItemToBottom(at index: Int) {
        let movedItem = list.items.remove(at: index)
        list.items.append(movedItem)
        saveLists()
    }

    private func moveItemToTop(at index: Int) {
        let movedItem = list.items.remove(at: index)
        list.items.insert(movedItem, at: 0)
        saveLists()
    }

    private func deleteItem(at offsets: IndexSet) {
        list.items.remove(atOffsets: offsets)
        saveLists()
    }

    private func moveItem(from source: IndexSet, to destination: Int) {
        list.items.move(fromOffsets: source, toOffset: destination)
        saveLists()
    }

    private func saveLists() {
        if let encoded = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(encoded, forKey: "lists")
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct CustomListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CustomListDetailView(list: .constant(CustomList(name: "Sample List", items: [])), lists: .constant([]))
    }
}
