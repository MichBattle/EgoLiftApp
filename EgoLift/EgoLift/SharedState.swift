import SwiftUI
import Combine

class SharedState: ObservableObject {
    @Published var allenamentoDetailView: Bool = false
    @Published var esercizioDetailView: Bool = false
    @Published var noteListView: Bool = false
    @Published var eserciziListView: Bool = false
    @Published var eserciziCategoriaView: Bool = false
    @Published var esercizioNoteDetailView: Bool = false
    
    @Published var currentAllenamento: Allenamento? = nil
    @Published var currentEsercizio: Esercizio? = nil
    @Published var esercizi: [Esercizio] = []
    @Published var categoria: String = ""
    
    @Published var isTimerRunning: Bool = false
}
