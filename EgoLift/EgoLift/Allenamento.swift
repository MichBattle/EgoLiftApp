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

    func aggiungiEsercizio(nome: String, descrizione: String, tempoRecupero: Int, numeroSet: String, tipo: String) -> Bool {
        if !DatabaseManager.shared.esercizioEsisteGlobalmente(nome: nome, descrizione: descrizione) {
            let nuovoEsercizio = Esercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo)
            esercizi.append(nuovoEsercizio)
            DatabaseManager.shared.addEsercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, note: "", numeroSet: numeroSet, tipo: tipo, allenamentoID: self.id) // Salva l'esercizio nel database
            return true
        }
        return false
    }

    func aggiungiEsercizioEsistente(esercizio: Esercizio) -> Bool {
        if !esercizi.contains(where: { $0.nome == esercizio.nome && $0.descrizione == esercizio.descrizione }) {
            if DatabaseManager.shared.addEsercizioEsistente(esercizio: esercizio, to: self.id) {
                esercizi.append(esercizio)
                return true
            }
            return false
        }
        return false
    }


    func rimuoviEsercizio(esercizio: Esercizio) {
        if let index = esercizi.firstIndex(of: esercizio) {
            esercizi.remove(at: index)
        }
    }

    static func == (lhs: Allenamento, rhs: Allenamento) -> Bool {
        return lhs.id == rhs.id
    }
}
