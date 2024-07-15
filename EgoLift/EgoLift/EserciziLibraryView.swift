import SwiftUI

struct EserciziLibraryView: View {
    @ObservedObject var allenamento: Allenamento
    @State private var esercizi: [Esercizio] = []
    @State private var showAlert = false
    @State private var showErrorAlert = false
    let categorie = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]
    @ObservedObject var sharedState: SharedState

    var body: some View {
        NavigationView {
            VStack {
                List(categorie, id: \.self) { categoria in
                    NavigationLink(destination: EserciziCategoriaView(categoria: categoria, isSelectable: false, onAddEsercizio: { esercizio in
                        if allenamento.aggiungiEsercizioEsistente(esercizio: esercizio) {
                            showAlert = true
                            return true
                        } else {
                            showErrorAlert = true
                            return false
                        }
                    }, sharedState: sharedState)) {
                        Text(categoria)
                            .font(.title2)
                            .padding(10)
                    }
                }.listStyle(PlainListStyle())
            }
            .navigationBarTitle("Esercizi")
            .onAppear {
                loadEsercizi()
            }
            .padding()
            .alert("Esercizio aggiunto!", isPresented: $showAlert) {
                Button("Ok", role: .cancel){}
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Errore"),
                    message: Text("Esercizio già presente nell'allenamento!"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func loadEsercizi() {
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }
}
