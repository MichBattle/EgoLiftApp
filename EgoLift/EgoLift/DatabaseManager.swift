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
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("palestra").appendingPathExtension("sqlite3")
            db = try Connection(fileUrl.path)
            createTables()
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
            })
        } catch {
            print("Error creating tables: \(error)")
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
        let query = allenamentiTable.filter(self.id == id)
        do {
            try db?.run(query.delete())
            print("Allenamento con id \(id) eliminato con successo")
        } catch {
            print("Error deleting allenamento: \(error)")
        }
    }
    
    // Funzioni per gestire gli esercizi
    func addEsercizio(nome: String, descrizione: String, tempoRecupero: Int, note: String, numeroSet: String, tipo: String, allenamentoID: Int64) {
        if !esercizioEsisteGlobalmente(nome: nome, descrizione: descrizione) {
            let insert = eserciziTable.insert(self.nome <- nome, self.descrizione <- descrizione, self.tempoRecupero <- tempoRecupero, self.note <- note, self.numeroSet <- numeroSet, self.tipo <- tipo, self.allenamentoID <- allenamentoID)
            do {
                try db?.run(insert)
                print("Esercizio \(nome) aggiunto con successo")
            } catch {
                print("Error inserting esercizio: \(error)")
            }
        }
    }
    
    func fetchEsercizi(for allenamentoID: Int64) -> [Esercizio] {
        var esercizi = [Esercizio]()
        do {
            let query = eserciziTable.filter(self.allenamentoID == allenamentoID)
            for esercizio in try db!.prepare(query) {
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let esercizioObject = Esercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo)
                esercizioObject.note = note.split(separator: ";").map { Note(content: String($0)) }
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
            for esercizio in try db!.prepare(eserciziTable) {
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let esercizioObject = Esercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo)
                esercizioObject.note = note.split(separator: ";").map { Note(content: String($0)) }
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

    func updateEsercizio(nome: String, descrizione: String, note: String) {
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione)
        do {
            try db?.run(query.update(self.note <- note))
            print("Esercizio \(nome) aggiornato con successo")
        } catch {
            print("Error updating esercizio: \(error)")
        }
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
    
    func esercizioEsistePerAllenamento(nome: String, descrizione: String, allenamentoID: Int64) -> Bool {
        let query = eserciziTable.filter(self.nome == nome && self.descrizione == descrizione && self.allenamentoID == allenamentoID)
        do {
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("Error checking if esercizio exists for allenamento: \(error)")
            return false
        }
    }

    // Funzione per aggiungere un esercizio esistente
    func addEsercizioEsistente(esercizio: Esercizio, to allenamentoID: Int64) -> Bool {
        let query = eserciziTable.filter(self.nome == esercizio.nome && self.descrizione == esercizio.descrizione && self.allenamentoID == allenamentoID)
        do {
            if try db?.scalar(query.count) == 0 {
                let insert = eserciziTable.insert(self.nome <- esercizio.nome, self.descrizione <- esercizio.descrizione, self.tempoRecupero <- esercizio.tempoRecupero, self.note <- esercizio.note.map { $0.content }.joined(separator: ";"), self.numeroSet <- esercizio.numeroSet, self.tipo <- esercizio.tipo, self.allenamentoID <- allenamentoID)
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
                let nome = esercizio[self.nome]
                let descrizione = esercizio[self.descrizione]
                let tempoRecupero = esercizio[self.tempoRecupero]
                let note = esercizio[self.note]
                let numeroSet = esercizio[self.numeroSet]
                let tipo = esercizio[self.tipo]
                let esercizioObject = Esercizio(nome: nome, descrizione: descrizione, tempoRecupero: tempoRecupero, numeroSet: numeroSet, tipo: tipo)
                esercizioObject.note = note.split(separator: ";").map { Note(content: String($0)) }
                return esercizioObject
            }
        } catch {
            print("Error finding global esercizio: \(error)")
        }
        return nil
    }
}
