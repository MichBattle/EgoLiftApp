import Foundation

class Esercizio: Identifiable, ObservableObject, Equatable {
    var id = UUID()
    @Published var nome: String
    @Published var descrizione: String
    @Published var tempoRecupero: Int
    @Published var numeroSet: String
    @Published var tipo: String
    @Published var note: [Note]

    init(nome: String, descrizione: String, tempoRecupero: Int, numeroSet: String, tipo: String) {
        self.nome = nome
        self.descrizione = descrizione
        self.tempoRecupero = tempoRecupero
        self.numeroSet = numeroSet
        self.tipo = tipo
        self.note = []
    }

    func aggiungiNota(content: String) {
        let nuovaNota = Note(content: content)
        note.append(nuovaNota)
        salvaNoteNelDatabase()
    }

    private func salvaNoteNelDatabase() {
        let noteContent = note.map { $0.content }.joined(separator: ";")
        DatabaseManager.shared.updateEsercizio(nome: nome, note: noteContent)
    }

    static func == (lhs: Esercizio, rhs: Esercizio) -> Bool {
        return lhs.id == rhs.id
    }
}
