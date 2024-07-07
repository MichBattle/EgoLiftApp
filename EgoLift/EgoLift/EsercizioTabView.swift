import SwiftUI

struct EsercizioTabView: View {
    var esercizi: [Esercizio]
    @State var currentIndex: Int
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<esercizi.count, id: \.self) { index in
                EsercizioDetailView(esercizio: esercizi[index])
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .navigationBarTitle(esercizi[currentIndex].nome)
    }
}
