import SwiftUI

struct EsercizioTabView: View {
    var esercizi: [Esercizio]
    @State var currentIndex: Int
    @ObservedObject var sharedState = SharedState()
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(esercizi.indices, id: \.self) { index in
                EsercizioDetailView(esercizio: esercizi[index], sharedState: sharedState)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationBarTitle(esercizi[currentIndex].nome)
        .onChange(of: currentIndex) { newIndex in
            // Aggiorna il titolo della barra di navigazione con il nome del nuovo esercizio
            if esercizi.indices.contains(newIndex) {
                esercizi[newIndex].objectWillChange.send()
            }
        }
    }
}
