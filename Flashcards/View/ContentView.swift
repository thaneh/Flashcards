//
//  ContentView.swift
//  Flashcards
//
//  Created by Thane Heninger on 8/28/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showingAddView = false
    @State private var cards = [Card]()

    var body: some View {
        NavigationView {
            List {
                ForEach(cards) { card in
                    NavigationLink(destination: ItemDetails(card: card)) {
                        ItemCellView(card: card)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Flashcards")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    #if os(iOS)
                    EditButton()
                    #endif
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddItemView()
                    .onDisappear(perform: loadItems)
            }
        }
        .onAppear(perform: loadItems)
    }
    
    private func loadItems() {
        Store.shared.loadItems { cards in
            DispatchQueue.main.async {
                self.cards = cards
            }
        }
    }
    
    private func addItem() {
        showingAddView = true
    }

    private func deleteItems(offsets: IndexSet) {
        Store.shared.deleteItems(offsets: offsets, completion: loadItems)
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
