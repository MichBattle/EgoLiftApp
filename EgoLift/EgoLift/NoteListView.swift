import SwiftUI

struct NoteListView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var nuovaNota: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(esercizio.note, id: \.id) { nota in
                    Text(nota.content)
                }
                .onDelete(perform: eliminaNota)
            }
            
            HStack {
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
            }
            .padding()
        }
        .navigationBarTitle("Note", displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
    
    private func eliminaNota(at offsets: IndexSet) {
        esercizio.note.remove(atOffsets: offsets)
    }
}
