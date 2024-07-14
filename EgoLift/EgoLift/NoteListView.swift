import SwiftUI

struct NoteListView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var nuovaNota: String = ""
    @State private var isAddingNota: Bool = false
    @ObservedObject var sharedState: SharedState
    
    var body: some View {
        VStack {
            List {
                ForEach(esercizio.note, id: \.id) { nota in
                    Text(nota.content)
                }
                .onDelete(perform: eliminaNota)
            }.listStyle(PlainListStyle())
            
            Spacer()
        }
        .onAppear(){
            sharedState.currentEsercizio = esercizio
            sharedState.noteListView = true
        }
        .onDisappear(){
            sharedState.currentEsercizio = nil
            sharedState.noteListView = false
        }
        .navigationBarTitle("Note", displayMode: .inline)
    }
    
    private func eliminaNota(at offsets: IndexSet) {
        esercizio.note.remove(atOffsets: offsets)
    }
}
