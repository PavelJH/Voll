import SwiftUI

struct CustomListView: View {
    @State private var showNewCustomListView = false
    @State private var lists: [CustomList] = []

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lists) { list in
                        NavigationLink(destination: CustomListDetailView(list: $lists[getIndex(for: list)], lists: $lists)) {
                            Text(list.name)
                        }
                    }
                    .onDelete(perform: deleteList)
                }

                NavigationLink(destination: NewCustomListView(lists: $lists)) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("New List")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Lists")
            .onAppear(perform: loadLists)
        }
    }

    private func loadLists() {
        if let data = UserDefaults.standard.data(forKey: "lists"),
           let decodedLists = try? JSONDecoder().decode([CustomList].self, from: data) {
            lists = decodedLists
        }
    }

    private func saveLists() {
        if let encoded = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(encoded, forKey: "lists")
        }
    }

    private func deleteList(at offsets: IndexSet) {
        lists.remove(atOffsets: offsets)
        saveLists()
    }

    private func getIndex(for list: CustomList) -> Int {
        return lists.firstIndex { $0.id == list.id } ?? 0
    }
}

struct CustomListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomListView()
    }
}
