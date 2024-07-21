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
        .disabled(sharedState.isTimerRunning) // Disable scrolling when the timer is running
        .navigationBarTitle(esercizi[currentIndex].nome)
        .onChange(of: currentIndex) { newIndex in
            // Update the navigation bar title with the new exercise name
            if esercizi.indices.contains(newIndex) {
                esercizi[newIndex].objectWillChange.send()
            }
        }
    }
}
