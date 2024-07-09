import Foundation

class Palestra: ObservableObject {
    @Published var allenamenti: [Allenamento] = []
    
    init() {
        loadAllenamentiFromDatabase()
    }

    func aggiungiAllenamento(nome: String) {
        if let allenamentoID = DatabaseManager.shared.addAllenamento(nome: nome) {
            let nuovoAllenamento = Allenamento(id: allenamentoID, nome: nome)
            allenamenti.append(nuovoAllenamento)
        }
    }

    func eliminaAllenamento(allenamento: Allenamento) {
        if let index = allenamenti.firstIndex(of: allenamento) {
            DatabaseManager.shared.deleteAllenamento(id: allenamento.id)
            allenamenti.remove(at: index)
        }
    }

    private func loadAllenamentiFromDatabase() {
        allenamenti = DatabaseManager.shared.fetchAllenamenti()
    }
}
