import SwiftUI

struct EserciziCategoriaView: View {
    var categoria: String
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    var isSelectable: Bool = true // Default is selectable
    var onAddEsercizio: ((Esercizio) -> Bool)? // Callback returns success
    @ObservedObject var sharedState: SharedState
    
    var body: some View {
        VStack {
            TextField("Cerca esercizio", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            List {
                ForEach(filteredEsercizi, id: \.id) { esercizio in
                    if isSelectable {
                        NavigationLink(destination: EsercizioNoteDetailView(esercizio: esercizio, sharedState: sharedState)) {
                            VStack(alignment: .leading) {
                                Text(esercizio.nome)
                                    .font(.headline)
                                Text("Numero Set: \(esercizio.numeroSet)")
                                    .font(.subheadline)
                                Text("Tempo di recupero: \(esercizio.tempoRecupero) secondi")
                                    .font(.subheadline)
                            }
                        }
                    } else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(esercizio.nome)
                                    .font(.headline)
                                Text("Numero Set: \(esercizio.numeroSet)")
                                    .font(.subheadline)
                                Text("Tempo di recupero: \(esercizio.tempoRecupero) secondi")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(action: {
                                if let onAddEsercizio = onAddEsercizio {
                                    if onAddEsercizio(esercizio) {
                                        
                                    } else {
                                        // Handle failed addition
                                    }
                                }
                            }) {
                                Text("Aggiungi")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete(perform: isSelectable ? eliminaEsercizi : nil)
            }.listStyle(PlainListStyle())
        }
        .navigationBarTitle(categoria)
        .onAppear {
            sharedState.eserciziCategoriaView = true
            sharedState.categoria = categoria
            loadEsercizi()
        }
        .onDisappear(){
            sharedState.categoria = ""
            sharedState.eserciziCategoriaView = false
        }
    }

    private var filteredEsercizi: [Esercizio] {
        if searchText.isEmpty {
            return esercizi.filter { $0.tipo == categoria }
        } else {
            return esercizi.filter { $0.tipo == categoria && $0.nome.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func loadEsercizi() {
        esercizi = DatabaseManager.shared.fetchAllEsercizi().filter { $0.tipo == categoria }
    }

    private func eliminaEsercizi(at offsets: IndexSet) {
        offsets.forEach { index in
            let esercizio = filteredEsercizi[index]
            DatabaseManager.shared.deleteEsercizio(nome: esercizio.nome, descrizione: esercizio.descrizione)
        }
        loadEsercizi()
    }
}
