import SwiftUI

struct EserciziCategoriaView: View {
    var categoria: String
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    var isSelectable: Bool = true // Default is selectable
    var onAddEsercizio: ((Esercizio) -> Bool)? // Callback returns success
    
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
                        NavigationLink(destination: EsercizioNoteDetailView(esercizio: esercizio)) {
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
                                    _ = onAddEsercizio(esercizio)
                                }
                            }) {
                                Text("Aggiungi")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .onDelete(perform: isSelectable ? eliminaEsercizi : nil)
            }
        }
        .navigationBarTitle(categoria)
        .onAppear {
            loadEsercizi()
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
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }

    private func eliminaEsercizi(at offsets: IndexSet) {
        offsets.forEach { index in
            let esercizio = filteredEsercizi[index]
            DatabaseManager.shared.deleteEsercizio(nome: esercizio.nome, descrizione: esercizio.descrizione)
        }
        loadEsercizi()
    }
}
