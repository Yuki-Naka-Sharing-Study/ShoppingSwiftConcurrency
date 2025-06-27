//
//  ShoppingListViewModel.swift
//  ShoppingSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import Foundation

@MainActor
class ShoppingListViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = []
    
    private let saveFileURL: URL = {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent("shopping_list.json")
    }()
    
    init() {
        Task {
            await loadItems()
        }
    }
    
    func addItem(name: String) {
        let newItem = ShoppingItem(id: UUID(), name: name)
        items.append(newItem)
        Task {
            await saveItems()
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        Task {
            await saveItems()
        }
    }
    
    private func saveItems() async {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: saveFileURL, options: .atomic)
        } catch {
            print("保存失敗: \(error)")
        }
    }
    
    private func loadItems() async {
        do {
            let data = try Data(contentsOf: saveFileURL)
            let decoded = try JSONDecoder().decode([ShoppingItem].self, from: data)
            items = decoded
        } catch {
            print("読み込み失敗: \(error.localizedDescription)")
        }
    }
}
