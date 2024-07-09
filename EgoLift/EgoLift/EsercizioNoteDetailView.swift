import SwiftUI

struct EsercizioNoteDetailView: View {
    @ObservedObject var esercizio: Esercizio
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(esercizio.nome)
                .font(.largeTitle)
                .padding(.bottom)
            
            Text("Descrizione")
                .font(.headline)
                .padding(.vertical, 2)
            
            Text(esercizio.descrizione)
                .padding(.bottom)
            
            Text("Note")
                .font(.headline)
                .padding(.vertical, 2)
            
            List {
                ForEach(esercizio.note, id: \.id) { nota in
                    Text(nota.content)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Dettagli Esercizio", displayMode: .inline)
    }
}
