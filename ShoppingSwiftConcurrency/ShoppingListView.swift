//
//  ShoppingListView.swift
//  ShoppingSwiftConcurrency
//
//  Created by 仲優樹 on 2025/06/28.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var newItemName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("買い物アイテムを入力", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !newItemName.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        viewModel.addItem(name: newItemName)
                        newItemName = ""
                    }) {
                        Image(systemName: "plus")
                            .padding(8)
                    }
                }
                .padding()
                
                List {
                    ForEach(viewModel.items) { item in
                        Text(item.name)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteItem(at: indexSet)
                    }
                }
            }
            .navigationTitle("買い物リスト")
        }
    }
}

#Preview {
    ShoppingListView()
}
