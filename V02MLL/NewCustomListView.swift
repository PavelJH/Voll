import SwiftUI

struct NewCustomListView: View {
    @Binding var lists: [CustomList]
    @Environment(\.presentationMode) var presentationMode
    @State private var newListName: String = ""
    @State private var items: [ListItemModel] = []
    @FocusState private var isFocused: Bool
    @State private var newItemText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("List Name", text: $newListName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isFocused)

                List {
                    ForEach($items) { $item in
                        HStack {
                            
                            Button(action: {
                                item.isCompleted.toggle()
                                if item.isCompleted {
                                    moveCompletedItemToBottom(item: item)
                                } else {
                                    moveItemToTop(item: item)
                                }
                                
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(item.isCompleted ? .green : .gray)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 50)
                                    .padding(.leading, 1)
                            }
                            

                            TextField("Item", text: $item.text)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            
                        }
                    }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: moveItem)
                    
                }
                .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                .listStyle(GroupedListStyle())
                .frame(maxWidth: .infinity)
                

                HStack {
                    TextField("New Item", text: $newItemText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isFocused)
                    Button(action: addItem) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                    }
                }
                .padding()
                

                Button(action: saveNewList) {
                    Text("Save")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
            }
        
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        
    }

    private func addItem() {
        guard !newItemText.isEmpty else { return }
        items.insert(ListItemModel(text: newItemText), at: 0)
        newItemText = ""
        saveLists()
    }

    private func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveLists()
    }

    private func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        saveLists()
    }

    private func moveCompletedItemToBottom(item: ListItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let movedItem = items.remove(at: index)
            items.append(movedItem)
            saveLists()
        }
    }

    private func moveItemToTop(item: ListItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            let movedItem = items.remove(at: index)
            items.insert(movedItem, at: 0)
            saveLists()
        }
    }

    private func saveNewList() {
        guard !newListName.isEmpty else { return }
        let newList = CustomList(name: newListName, items: items)
        lists.append(newList)
        saveLists()
        presentationMode.wrappedValue.dismiss()
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

struct NewCustomListView_Previews: PreviewProvider {
    static var previews: some View {
        NewCustomListView(lists: .constant([]))
    }
}
