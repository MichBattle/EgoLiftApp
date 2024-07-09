import SwiftUI

struct EserciziCategoriaView: View {
    var categoria: String
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField("Cerca esercizio", text: $searchText)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            List(filteredEsercizi, id: \.id) { esercizio in
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
}
