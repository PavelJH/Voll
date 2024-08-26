import SwiftUI

struct MainTabView: View {
    @Binding var isAuthenticated: Bool
    @State private var selectedTab: Tab = .notes

    enum Tab {
        case money, sport, notes, reminders, other
    }

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                MoneyView()
                    .tabItem {
                        Label("Money", systemImage: "dollarsign.circle")
                    }
                    .tag(Tab.money)

                SportView()
                    .tabItem {
                        Label("Sport", systemImage: "sportscourt")
                    }
                    .tag(Tab.sport)

                NotesView()
                    .tabItem {
                        Label("Notes", systemImage: "note.text")
                    }
                    .tag(Tab.notes)

                RemindersView()
                    .tabItem {
                        Label("Reminders", systemImage: "bell")
                    }
                    .tag(Tab.reminders)

                OtherView(isAuthenticated: $isAuthenticated)
                    .tabItem {
                        Label("Other", systemImage: "ellipsis.circle")
                    }
                    .tag(Tab.other)
            }
        }
    }
}
