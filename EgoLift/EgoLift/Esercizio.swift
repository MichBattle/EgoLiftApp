import Foundation

class EsercizioNote: Identifiable {
    var id = UUID()
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

class Esercizio: Identifiable, ObservableObject, Equatable, Hashable {
    var id: Int64
    @Published var nome: String
    @Published var descrizione: String
    @Published var tempoRecupero: Int
    @Published var numeroSet: String
    @Published var tipo: String
    @Published var note: [EsercizioNote]
    @Published var isOriginal: Bool

    init(id: Int64 = Int64.random(in: Int64.min...Int64.max), nome: String, descrizione: String, tempoRecupero: Int, numeroSet: String, tipo: String, isOriginal: Bool) {
        self.id = id
        self.nome = nome
        self.descrizione = descrizione
        self.tempoRecupero = tempoRecupero
        self.numeroSet = numeroSet
        self.tipo = tipo
        self.note = []
        self.isOriginal = isOriginal
    }

    func aggiungiNota(content: String) {
        let nuovaNota = EsercizioNote(content: content)
        note.append(nuovaNota)
        salvaNoteNelDatabase(content: content)
    }

    private func salvaNoteNelDatabase(content: String) {
        DatabaseManager.shared.updateEsercizio(nome: nome, nuovaNota: content)
    }
    
    func copia() -> Esercizio {
            return Esercizio(id: Int64.random(in: Int64.min...Int64.max), nome: self.nome, descrizione: self.descrizione, tempoRecupero: self.tempoRecupero, numeroSet: self.numeroSet, tipo: self.tipo, isOriginal: false)
        }

    static func == (lhs: Esercizio, rhs: Esercizio) -> Bool {
        return lhs.id == rhs.id // Confrontiamo gli esercizi usando l'ID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
