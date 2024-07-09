import SwiftUI

struct EserciziListView: View {
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    let categorie = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]

    var body: some View {
        VStack{
            List(categorie, id: \.self) { categoria in
                NavigationLink(destination: EserciziCategoriaView(categoria: categoria)) {
                    Text(categoria)
                        .font(.headline)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Esercizi")
        .onAppear {
            loadEsercizi()
        }
    }

    private func loadEsercizi() {
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }
}
