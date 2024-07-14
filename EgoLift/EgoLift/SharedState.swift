import SwiftUI
import Combine

class SharedState: ObservableObject {
    @Published var allenamentoDetailView: Bool = false
    @Published var esercizioDetailView: Bool = false
    @Published var noteListView: Bool = false
    @Published var currentAllenamento: Allenamento? = nil
    @Published var currentEsercizio: Esercizio? = nil
}
