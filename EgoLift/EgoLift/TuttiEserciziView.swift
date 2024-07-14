import SwiftUI

struct TuttiEserciziView: View {
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
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
                }
                .onDelete(perform: eliminaEsercizi)

            }.listStyle(PlainListStyle())
        }
        .navigationBarTitle("Tutti gli Esercizi")
        .onAppear {
            loadEsercizi()
        }
    }

    private var filteredEsercizi: [Esercizio] {
        if searchText.isEmpty {
            return esercizi
        } else {
            return esercizi.filter { $0.nome.lowercased().contains(searchText.lowercased()) }
        }
    }

    private func loadEsercizi() {
        esercizi = DatabaseManager.shared.fetchAllEserciziWithDuplicates()
    }

    private func eliminaEsercizi(at offsets: IndexSet) {
        offsets.forEach { index in
            let esercizio = filteredEsercizi[index]
            DatabaseManager.shared.deleteEsercizio(nome: esercizio.nome, descrizione: esercizio.descrizione)
        }
        loadEsercizi()
    }
}
