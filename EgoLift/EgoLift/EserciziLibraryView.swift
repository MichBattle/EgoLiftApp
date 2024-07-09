import SwiftUI

struct EserciziLibraryView: View {
    @ObservedObject var allenamento: Allenamento
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Cerca esercizio", text: $searchText)
                    .padding(7)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                List(filteredEsercizi, id: \.id) { esercizio in
                    Button(action: {
                        aggiungiEsercizioDaLibreria(esercizio: esercizio)
                    }) {
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
                .navigationBarTitle("Seleziona Esercizio")
                .onAppear {
                    loadEsercizi()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Esercizio aggiunto"),
                        message: Text("L'esercizio è stato aggiunto con successo."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
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
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }

    private func aggiungiEsercizioDaLibreria(esercizio: Esercizio) {
        allenamento.aggiungiEsercizioEsistente(esercizio: esercizio)
        showAlert = true
    }
}
