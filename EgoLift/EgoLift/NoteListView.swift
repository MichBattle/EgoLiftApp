import SwiftUI

struct NoteListView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var nuovaNota: String = ""
    @State private var isAddingNota: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(esercizio.note, id: \.id) { nota in
                    Text(nota.content)
                }
                .onDelete(perform: eliminaNota)
            }
            
            Spacer()
        }
        .navigationBarTitle("Note", displayMode: .inline)
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
    
    private func eliminaNota(at offsets: IndexSet) {
        esercizio.note.remove(atOffsets: offsets)
    }
}
