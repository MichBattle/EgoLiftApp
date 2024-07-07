import SwiftUI

struct EsercizioDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var nuovaNota: String = ""
    
    var body: some View {
        VStack {
            Text(esercizio.descrizione)
                .padding()
            
            TextField("Aggiungi Nota", text: $nuovaNota)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                esercizio.aggiungiNota(content: nuovaNota)
                nuovaNota = ""
            }) {
                Text("Aggiungi Nota")
            }
            .padding()
            
            List {
                ForEach(esercizio.note, id: \.id) { nota in
                    Text(nota.content)
                }
            }
        }
        .navigationBarTitle(esercizio.nome)
    }
}
