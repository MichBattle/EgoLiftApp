import SwiftUI

struct AllenamentoDetailView: View {
    @ObservedObject var allenamento: Allenamento
    @ObservedObject var palestra: Palestra
    @State private var nuovoEsercizioNome: String = ""
    @State private var nuovaDescrizione: String = ""
    @State private var tempoRecupero: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Nome Esercizio", text: $nuovoEsercizioNome)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity)
            
            ZStack(alignment: .topLeading) {
                if nuovaDescrizione.isEmpty {
                    Text("Descrizione Esercizio")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                TextEditor(text: $nuovaDescrizione)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    .frame(maxWidth: .infinity, minHeight: 150)
            }
            .frame(maxWidth: .infinity)
            
            TextField("Tempo di Recupero (secondi)", text: $tempoRecupero)
                .keyboardType(.numberPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: tempoRecupero) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.tempoRecupero = filtered
                    }
                }
            
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
                    NavigationLink(destination: EsercizioDetailView(esercizio: esercizio)) {
                        Text(esercizio.nome)
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        let esercizio = allenamento.esercizi[index]
                        allenamento.eliminaEsercizio(esercizio: esercizio)
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle(allenamento.nome)
        .navigationBarItems(trailing: EditButton())
    }
}
