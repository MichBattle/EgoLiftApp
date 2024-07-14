import SwiftUI

struct EsercizioNoteDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var isEditing: Bool = false
    @State private var isViewingNotes: Bool = false
    @ObservedObject var sharedState: SharedState

    var body: some View {
        VStack(spacing: 16) {
            Text(esercizio.descrizione)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Text("Tempo di recupero: \(Int(esercizio.tempoRecupero)) secondi")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            Spacer()
            
            HStack {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text("Modifica")
                }
                .padding()
                .sheet(isPresented: $isEditing) {
                    EsercizioEditView(esercizio: esercizio, isPresented: $isEditing)
                }
                
                Spacer()
                
                Button(action: {
                    isViewingNotes.toggle()
                }) {
                    Text("Note")
                }
                .padding()
                .background(
                    NavigationLink(destination: NoteListView(esercizio: esercizio, sharedState: sharedState), isActive: $isViewingNotes) {
                        EmptyView()
                    }.hidden()
                )
            }
        }
        .padding()
        .navigationBarTitle(esercizio.nome)
    }
}
