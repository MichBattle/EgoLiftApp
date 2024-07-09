import SwiftUI

struct EserciziLibraryView: View {
    @ObservedObject var allenamento: Allenamento
    @State private var esercizi: [Esercizio] = []
    @State private var showAlert = false
    let categorie = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]

    var body: some View {
        NavigationView {
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Esercizio aggiunto"),
                    message: Text("L'esercizio è stato aggiunto con successo."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    private func loadEsercizi() {
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }
}
