import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?
    private let allenamentiTable = Table("allenamenti")
    private let eserciziTable = Table("esercizi")
    
    private let id = Expression<Int64>("id")
    private let nome = Expression<String>("nome")
    
    private let allenamentoID = Expression<Int64>("allenamento_id")
    private let descrizione = Expression<String>("descrizione")
    private let tempoRecupero = Expression<Int>("tempo_recupero")
    private let note = Expression<String>("note")
    private let numeroSet = Expression<String>("numero_set")
    private let tipo = Expression<String>("tipo")
    private let isOriginal = Expression<Bool>("is_original")
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("palestra").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            createTables()
            try migrateDatabase()
        } catch {
            print("Error creating connection to database: \(error)")
        }
    }
    
    private func createTables() {
        do {
            try db?.run(allenamentiTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(nome, unique: true)
            })
            
            try db?.run(eserciziTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(allenamentoID)
                table.column(nome)
                table.column(descrizione)
                table.column(tempoRecupero)
                table.column(note)
                table.column(numeroSet)
                table.column(tipo)
                table.column(isOriginal, defaultValue: false) // Aggiungi la colonna isOriginal
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    // Funzione per la migrazione del database
    private func migrateDatabase() throws {
        let columns = try db?.prepare("PRAGMA table_info(esercizi)").map { $0[1] as? String } ?? []
        if !columns.contains("is_original") {
            try db?.run(eserciziTable.addColumn(isOriginal, defaultValue: false))
        }
    }

    // Funzioni per gestire gli allenamenti
    func addAllenamento(nome: String) -> Int64? {
        let insert = allenamentiTable.insert(self.nome <- nome)
        do {
            let rowId = try db?.run(insert)
            print("Allenamento \(nome) aggiunto con successo")
            return rowId
        } catch {
            print("Error inserting allenamento: \(error)")
            return nil
        }
    }
    
    func fetchAllenamenti() -> [Allenamento] {
        var allenamenti = [Allenamento]()
        do {
            for allenamento in try db!.prepare(allenamentiTable) {
                let id = allenamento[self.id]
                let nome = allenamento[self.nome]
                let esercizi = fetchEsercizi(for: id)
                let allenamentoObject = Allenamento(id: id, nome: nome, esercizi: esercizi)
                allenamenti.append(allenamentoObject)
            }
        } catch {
            print("Error fetching allenamenti: \(error)")
        }
        return allenamenti
    }

    func deleteAllenamento(id: Int64) {
        // Elimina prima gli esercizi associati
        deleteEsercizi(for: id)
        // Poi elimina l'allenamento
        let query = allenamentiTable.filter(self.id == id)
        do {
            try db?.run(query.delete())
            print("Allenamento con id \(id) eliminato con successo")
        } catch {
            print("Error deleting allenamento: \(error)")
        }
    }
    
    // Funzioni per gestire gli esercizi
    func addEsercizio(nome: String, descrizione: String, tempoRecupero: Int, note: String, numeroSet: String, tipo: String, allenamentoID: Int64, isOriginal: Bool) -> Bool {
        if !esercizioEsisteGlobalmente(nome: nome, descrizione: descrizione) {
            let insert = eserciziTable.insert(self.nome <- nome, self.descrizione <- descrizione, self.tempoRecupero <- tempoRecupero, self.note <- note, self.numeroSet <- numeroSet, self.tipo <- tipo, self.allenamentoID <- allenamentoID, self.isOriginal <- isOriginal)
            do {
                try db?.run(insert)
                print("Esercizio \(nome) aggiunto con successo")
                return true
            } catch {
                print("Error inserting esercizio: \(error)")
                return false
            }
        }
        return false
    }
    
    func fetchEsercizi(for allenamentoID: Int64) -> [Esercizio] {
        var esercizi = [Esercizio]()
        do {
            let query = eserciziTable.filter(self.allenamentoID == allenamentoID)
            for esercizio in try db!.prepare(query) {
                let id = esercizio[self.id]
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let isOriginal = esercizio[self.isOriginal]
                let esercizioObject = Esercizio(id: id, nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo, isOriginal: isOriginal)
                esercizioObject.note = note.split(separator: ";").map { EsercizioNote(content: String($0)) }
                esercizi.append(esercizioObject)
            }
        } catch {
            print("Error fetching esercizi: \(error)")
        }
        return esercizi
    }
    
    func fetchAllEsercizi() -> [Esercizio] {
        var esercizi = [Esercizio]()
        do {
            for esercizio in try db!.prepare(eserciziTable.filter(self.isOriginal == true)) {
                let id = esercizio[self.id]
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let isOriginal = esercizio[self.isOriginal]
                let esercizioObject = Esercizio(id: id, nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo, isOriginal: isOriginal)
                esercizioObject.note = note.split(separator: ";").map { EsercizioNote(content: String($0)) }
                esercizi.append(esercizioObject)
            }
        } catch {
            print("Error fetching esercizi: \(error)")
        }
        return esercizi
    }

    func fetchAllEserciziWithDuplicates() -> [Esercizio] {
        var esercizi = [Esercizio]()
        do {
            for esercizio in try db!.prepare(eserciziTable) {
                let id = esercizio[self.id]
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let isOriginal = esercizio[self.isOriginal]
                let esercizioObject = Esercizio(id: id, nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo, isOriginal: isOriginal)
                esercizioObject.note = note.split(separator: ";").map { EsercizioNote(content: String($0)) }
                esercizi.append(esercizioObject)
            }
        } catch {
            print("Error fetching esercizi: \(error)")
        }
        return esercizi
    }

    func deleteEsercizio(nome: String, descrizione: String) {
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione)
        do {
            try db?.run(query.delete())
            print("Esercizio \(nome) eliminato con successo")
        } catch {
            print("Error deleting esercizio: \(error)")
        }
    }

    func deleteSingleEsercizioById(id: Int64) {
        let query = eserciziTable.filter(self.id == id)
        do {
            try db?.run(query.delete())
            print("Esercizio con id \(id) eliminato con successo")
        } catch {
            print("Error deleting esercizio: \(error)")
        }
    }

    func deleteEsercizi(for allenamentoID: Int64) {
        let query = eserciziTable.filter(self.allenamentoID == allenamentoID)
        do {
            try db?.run(query.delete())
            print("Esercizi per l'allenamento con id \(allenamentoID) eliminati con successo")
        } catch {
            print("Error deleting esercizi: \(error)")
        }
    }

    func updateEsercizio(nome: String, nuovaNota: String) {
        do {
            // Fetch all esercizi with the same nome
            let query = eserciziTable.filter(self.nome == nome)
            for esercizio in try db!.prepare(query) {
                let existingNotes = esercizio[self.note]
                let updatedNotes = existingNotes.isEmpty ? nuovaNota : existingNotes + ";" + nuovaNota
                let updateQuery = query.filter(self.id == esercizio[self.id])
                try db?.run(updateQuery.update(self.note <- updatedNotes))
                print("Esercizio \(nome) aggiornato con successo")
            }
        } catch {
            print("Error updating esercizio: \(error)")
        }
    }

    func fetchNoteForEsercizio(nome: String, descrizione: String) -> [EsercizioNote] {
        var noteArray = [EsercizioNote]()
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione)
        do {
            for esercizio in try db!.prepare(query) {
                let note = esercizio[self.note]
                let noteObjects = note.split(separator: ";").map { EsercizioNote(content: String($0)) }
                noteArray.append(contentsOf: noteObjects)
            }
        } catch {
            print("Error fetching notes: \(error)")
        }
        return noteArray
    }

    func esercizioEsisteGlobalmente(nome: String, descrizione: String) -> Bool {
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione)
        do {
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("Error checking if esercizio exists: \(error)")
            return false
        }
    }

    // Funzione per aggiungere un esercizio esistente
    func addEsercizioEsistente(esercizio: Esercizio, to allenamentoID: Int64) -> Bool {
        let query = eserciziTable.filter(self.nome == esercizio.nome && self.descrizione == esercizio.descrizione && self.allenamentoID == allenamentoID)
        do {
            if try db?.scalar(query.count) == 0 {
                let insert = eserciziTable.insert(self.nome <- esercizio.nome, self.descrizione <- esercizio.descrizione, self.tempoRecupero <- esercizio.tempoRecupero, self.note <- esercizio.note.map { $0.content }.joined(separator: ";"), self.numeroSet <- esercizio.numeroSet, self.tipo <- esercizio.tipo, self.allenamentoID <- allenamentoID, self.isOriginal <- false)
                try db?.run(insert)
                print("Esercizio \(esercizio.nome) aggiunto con successo all'allenamento \(allenamentoID)")
                return true
            } else {
                print("L'esercizio \(esercizio.nome) esiste già per l'allenamento \(allenamentoID)")
                return false
            }
        } catch {
            print("Error inserting existing esercizio: \(error)")
            return false
        }
    }
    
    // Funzione per trovare un esercizio globale
    func trovaEsercizioGlobale(nome: String, descrizione: String) -> Esercizio? {
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione)
        do {
            if let esercizio = try db?.pluck(query) {
                let id = esercizio[self.id]
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let isOriginal = esercizio[self.isOriginal]
                let esercizioObject = Esercizio(id: id, nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo, isOriginal: isOriginal)
                esercizioObject.note = note.split(separator: ";").map { EsercizioNote(content: String($0)) }
                return esercizioObject
            }
        } catch {
            print("Error finding global esercizio: \(error)")
        }
        return nil
    }
    
    func updateEsercizio(id: Int64, nome: String, descrizione: String, tempoRecupero: Int) -> Bool {
        let query = eserciziTable.filter(self.id == id)
        do {
            let update = query.update(self.nome <- nome, self.descrizione <- descrizione, self.tempoRecupero <- tempoRecupero)
            if try db?.run(update) ?? 0 > 0 {
                print("Esercizio \(nome) aggiornato con successo")
                return true
            }
        } catch {
            print("Error updating esercizio: \(error)")
        }
        return false
    }
    
    func removeNotaFromEsercizio(nome: String, descrizione: String, notaContent: String) {
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione)
        do {
            for esercizio in try db!.prepare(query) {
                let existingNotes = esercizio[self.note].split(separator: ";").map { String($0) }
                let updatedNotes = existingNotes.filter { $0 != notaContent }.joined(separator: ";")
                let updateQuery = query.filter(self.id == esercizio[self.id])
                try db?.run(updateQuery.update(self.note <- updatedNotes))
                print("Nota rimossa da esercizio \(nome) con descrizione \(descrizione)")
            }
        } catch {
            print("Error removing nota from esercizio: \(error)")
        }
    }

}
