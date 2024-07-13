import SwiftUI

struct EsercizioNoteDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var nuovaNota: String = ""
    @State private var isAddingNota: Bool = false

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
        .navigationBarItems(trailing: Button(action: {
            isAddingNota.toggle()
        }) {
            Text("+")
                .font(.largeTitle)
                .frame(width: 30, height: 30)
        })
        .sheet(isPresented: $isAddingNota) {
            VStack {
                Text("Nuova Nota")
                    .font(.headline)
                    .padding()

                TextEditor(text: $nuovaNota)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))

                Button(action: {
                    esercizio.aggiungiNota(content: nuovaNota)
                    esercizio.note = DatabaseManager.shared.fetchNoteForEsercizio(nome: esercizio.nome, descrizione: esercizio.descrizione)
                    nuovaNota = ""
                    isAddingNota = false
                }) {
                    Text("Aggiungi Nota")
                }
                .padding()

                Button(action: {
                    isAddingNota = false
                }) {
                    Text("Annulla")
                }
                .padding()
            }
            .padding()
        }
    }
}
