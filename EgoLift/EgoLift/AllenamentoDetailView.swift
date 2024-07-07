import SwiftUI

struct AllenamentoDetailView: View {
    @ObservedObject var allenamento: Allenamento
    @State private var nuovoEsercizioNome: String = ""
    @State private var nuovaDescrizione: String = ""
    @State private var tempoRecupero: String = ""
    
    var body: some View {
        VStack {
            TextField("Nome Esercizio", text: $nuovoEsercizioNome)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Descrizione Esercizio", text: $nuovaDescrizione)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Tempo di Recupero (secondi)", text: $tempoRecupero)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                if let recupero = Int(tempoRecupero) {
                    allenamento.aggiungiEsercizio(nome: nuovoEsercizioNome, descrizione: nuovaDescrizione, tempoRecupero: recupero)
                    nuovoEsercizioNome = ""
                    nuovaDescrizione = ""
                    tempoRecupero = ""
                }
            }) {
                Text("Aggiungi Esercizio")
            }
            .padding()
            
            List {
                ForEach(allenamento.esercizi, id: \.id) { esercizio in
                    NavigationLink(destination: EsercizioTabView(esercizi: allenamento.esercizi, currentIndex: allenamento.esercizi.firstIndex(of: esercizio) ?? 0)) {
                        Text(esercizio.nome)
                    }
                }
            }
        }
        .navigationBarTitle(allenamento.nome)
    }
}
