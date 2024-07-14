import SwiftUI

struct EserciziListView: View {
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    @State private var showErrorAlert = false
    @ObservedObject var sharedState: SharedState
    let categorie = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]

    var body: some View {
        VStack {
            List(categorie, id: \.self) { categoria in
                NavigationLink(destination: EserciziCategoriaView(categoria: categoria, sharedState: sharedState)) {
                    Text(categoria)
                        .font(.title2) 
                        .padding(10)
                }
            }.listStyle(PlainListStyle())
        }
        .navigationBarTitle("Esercizi")
        .onAppear(){
            sharedState.esercizi = esercizi
            sharedState.eserciziListView = true
        }
        .onDisappear(){
            sharedState.esercizi = []
            sharedState.eserciziListView = false
        }
    }
}
