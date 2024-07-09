import Foundation

class Allenamento: Identifiable, ObservableObject, Equatable {
    var id: Int64
    @Published var nome: String
    @Published var esercizi: [Esercizio]

    init(id: Int64, nome: String, esercizi: [Esercizio] = []) {
        self.id = id
        self.nome = nome
        self.esercizi = esercizi
    }

    func aggiungiEsercizio(nome: String, descrizione: String, tempoRecupero: Int, numeroSet: String, tipo: String) {
        if !esercizi.contains(where: { $0.nome == nome }) {
            let nuovoEsercizio = Esercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo)
            esercizi.append(nuovoEsercizio)
            DatabaseManager.shared.addEsercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, note: "", numeroSet: numeroSet, tipo: tipo, allenamentoID: self.id) // Salva l'esercizio nel database
        }
    }

    func aggiungiEsercizioEsistente(esercizio: Esercizio) {
        if !esercizi.contains(where: { $0.nome == esercizio.nome }) {
            esercizi.append(esercizio)
        }
    }

    func eliminaEsercizio(esercizio: Esercizio) {
        if let index = esercizi.firstIndex(of: esercizio) {
            esercizi.remove(at: index)
            // Aggiungi la logica per eliminare dal database se necessario
        }
    }

    static func == (lhs: Allenamento, rhs: Allenamento) -> Bool {
        return lhs.id == rhs.id
    }
}
