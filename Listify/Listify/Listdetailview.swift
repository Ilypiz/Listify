//
//  Listdetailview.swift
//  Listify
//
//  Created by Ilaria Pizzano on 17/12/24.
//

import SwiftUI

// Modale per aggiungere un elemento alla lista
struct AddItemModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var itemName = ""
    @State private var description = ""
    var addItem: (ChecklistItem) -> Void
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.title2)
                .bold()
                .padding(.top, 20)
            
            TextField("Item name", text: $itemName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
                .padding(.horizontal)

            
            Button("Add") {
                if !itemName.isEmpty {
                    let newItem = ChecklistItem(title: itemName, isChecked: false, description: description)
                    addItem(newItem)
                    dismiss()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

// Definire il modello per ogni elemento della checklist
struct ChecklistItem: Identifiable {
    var id = UUID()
    var title: String
    var isChecked: Bool
    
    var description: String
}

// View per ogni elemento della checklist
struct ChecklistItemView: View {
    var item: ChecklistItem
    var toggleCheckmark: (ChecklistItem) -> Void
    
    var body: some View {
        HStack {
            // Checkbox (spunta) accanto ad ogni elemento
            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isChecked ? .green : .gray)
                .onTapGesture {
                    toggleCheckmark(item)
                }
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .strikethrough(item.isChecked)  // Barrato se è completato
                
                // Mostra la descrizione sotto il titolo, se presente
                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}




// Schermata Dettagliata
struct ListDetailView: View {
    var listTitle: String
    @State private var items: [ChecklistItem] = [
        ChecklistItem(title: "Milk", isChecked: false, description: ""),
        ChecklistItem(title: "Bread", isChecked: false, description: "")
    ]
    @State private var isShowingModal = false
    
    var body: some View {
        VStack {
            // Titolo con pulsante "+"
            HStack {
                Text(listTitle)
                    .font(.largeTitle)
                    .bold()
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    isShowingModal = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                        .font(.title)
                        .padding(.trailing)
                }
            }
            .padding(.top, 10)
            
            Divider()
            
            // Lista degli elementi con swipe-to-delete
            List {
                ForEach(items) { item in
                    ChecklistItemView(item: item, toggleCheckmark: toggleCheckmark)
                }
                .onDelete(perform: deleteItem)  // Permette l'eliminazione con swipe
            }
        }
        .sheet(isPresented: $isShowingModal) {
            AddItemModalView { newItem in
                items.append(newItem) // Aggiunge un nuovo elemento
            }
            .presentationDetents([.medium])
        }
    }
    
    // Funzione per gestire la selezione della checkbox
    func toggleCheckmark(_ item: ChecklistItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isChecked.toggle()
        }
    }
    
    // Funzione per eliminare un elemento
    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

struct ListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailView(listTitle: "Today grocery")
    }
}

