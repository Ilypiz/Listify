//
//  ContentView.swift
//  Listify
//
//  Created by Ilaria Pizzano on 17/12/24.
//

import SwiftUI
struct MyListsView: View {
    @State private var isShowingModal = false // Stato per mostrare la modale
    @State private var lists: [String] = ["Christmas grocery", "Today grocery"] // Liste iniziali
    @State private var isEditing = false // Stato per il pulsante Edit
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra di ricerca
                HStack {
                    TextField("Search", text: .constant(""))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "mic.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        )
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                Divider()
                
                // Lista dinamica con supporto per navigazione e cancellazione
                List {
                    ForEach(lists, id: \.self) { list in
                        NavigationLink(destination: ListDetailView(listTitle: list)) {
                            Text(list)
                                .font(.title3)
                                .fontWeight(.regular)
                           
                        }
                    }
                    .onDelete(perform: deleteItem) // Funzionalità per eliminare le liste
                }
                .listStyle(PlainListStyle())
                .environment(\.editMode, .constant(isEditing ? .active : .inactive)) // Modalità Edit
            }
            .navigationTitle("My lists")
            .navigationBarItems(
                leading: Button(action: {
                    withAnimation {
                        isEditing.toggle() // Attiva/disattiva modalità Edit
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .foregroundColor(.green)
                },
                trailing: Button(action: {
                    isShowingModal = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
            )
        }
        .sheet(isPresented: $isShowingModal) {
            CreateListModalView { newItem in
                lists.append(newItem) // Aggiunge una nuova lista
            }
            .presentationDetents([.medium, .large]) // Half Modal
            .presentationDragIndicator(.hidden)
        }
    }
    
    // Funzione per eliminare elementi dalla lista
    func deleteItem(at offsets: IndexSet) {
        lists.remove(atOffsets: offsets)
    }
}

// Schermata di dettaglio per una singola lista
struct DetailView: View {
    var listTitle: String
    
    var body: some View {
        VStack {
            Text(listTitle)
                .font(.largeTitle)
                .bold()
                .padding()
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Modale per creare una nuova lista
struct CreateListModalView: View {
    @Environment(\.dismiss) var dismiss
    @State private var listName: String = ""
    var addItem: (String) -> Void
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 10)
            
            Text("Create a new list")
                .font(.title2)
                .bold()
                .padding(.top, 10)
            
            TextField("New list", text: $listName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 1))
                .padding(.horizontal)
            
            Button(action: {
                if !listName.isEmpty {
                    addItem(listName) // Aggiunge la lista
                    dismiss() // Chiude la modale
                }
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding()
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView()
    }
}

