import Foundation

class Allenamento: Identifiable, ObservableObject {
    var id = UUID()
    @Published var nome: String
    @Published var esercizi: [Esercizio]
    
    init(nome: String) {
        self.nome = nome
        self.esercizi = []
    }
    
    func aggiungiEsercizio(nome: String, descrizione: String, tempoRecupero: Int) {
        let nuovoEsercizio = Esercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero)
        esercizi.append(nuovoEsercizio)
    }
}
