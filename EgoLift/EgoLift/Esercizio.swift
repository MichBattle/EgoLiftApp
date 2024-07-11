import Foundation

class EsercizioNote: Identifiable {
    var id = UUID()
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

class Esercizio: Identifiable, ObservableObject, Equatable, Hashable {
    var id: UUID
    @Published var nome: String
    @Published var descrizione: String
    @Published var tempoRecupero: Int
    @Published var numeroSet: String
    @Published var tipo: String
    @Published var note: [EsercizioNote]

    init(id: UUID = UUID(), nome: String, descrizione: String, tempoRecupero: Int, numeroSet: String, tipo: String) {
        self.id = id
        self.nome = nome
        self.descrizione = descrizione
        self.tempoRecupero = tempoRecupero
        self.numeroSet = numeroSet
        self.tipo = tipo
        self.note = []
    }

    func aggiungiNota(content: String) {
        let nuovaNota = EsercizioNote(content: content)
        note.append(nuovaNota)
        salvaNoteNelDatabase()
    }

    private func salvaNoteNelDatabase() {
        let noteContent = note.map { $0.content }.joined(separator: ";")
        DatabaseManager.shared.updateEsercizio(nome: nome, descrizione: descrizione, note: noteContent)
    }

    static func == (lhs: Esercizio, rhs: Esercizio) -> Bool {
        return lhs.nome == rhs.nome && lhs.descrizione == rhs.descrizione
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nome)
        hasher.combine(descrizione)
    }
}
