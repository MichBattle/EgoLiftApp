import Foundation

class Allenamento: Identifiable, ObservableObject, Equatable {
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
    
    func eliminaEsercizio(esercizio: Esercizio) {
        if let index = esercizi.firstIndex(of: esercizio) {
            esercizi.remove(at: index)
        }
    }
    
    static func == (lhs: Allenamento, rhs: Allenamento) -> Bool {
        return lhs.id == rhs.id
    }
}

class Palestra: ObservableObject {
    @Published var allenamenti: [Allenamento] = []
    
    func aggiungiAllenamento(nome: String) {
        let nuovoAllenamento = Allenamento(nome: nome)
        allenamenti.append(nuovoAllenamento)
    }
    
    func eliminaAllenamento(allenamento: Allenamento) {
        if let index = allenamenti.firstIndex(of: allenamento) {
            allenamenti.remove(at: index)
        }
    }
}
