import Foundation

class Esercizio: Identifiable, ObservableObject, Equatable {
    var id = UUID()
    @Published var nome: String
    @Published var descrizione: String
    @Published var tempoRecupero: Int
    @Published var note: [Note]
    
    init(nome: String, descrizione: String, tempoRecupero: Int) {
        self.nome = nome
        self.descrizione = descrizione
        self.tempoRecupero = tempoRecupero
        self.note = []
    }
    
    func aggiungiNota(content: String) {
        let nuovaNota = Note(content: content)
        note.append(nuovaNota)
    }
    
    static func == (lhs: Esercizio, rhs: Esercizio) -> Bool {
        return lhs.id == rhs.id
    }
}
