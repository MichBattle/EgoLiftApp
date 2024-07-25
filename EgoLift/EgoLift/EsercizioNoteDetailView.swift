import SwiftUI

struct EsercizioNoteDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var isEditing: Bool = false
    @ObservedObject var sharedState: SharedState

    var body: some View {
        VStack(spacing: 16) {
            Text("Gruppo muscolare: \(esercizio.tipo)")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
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
            
            Button(action: {
                isEditing.toggle()
            }) {
                Text("Modifica")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200) // Adjust the width as needed
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $isEditing) {
                EsercizioEditView(esercizio: esercizio, isPresented: $isEditing)
            }
        }
        .padding()
        .onAppear(){
            sharedState.esercizioNoteDetailView = true
        }
        .onDisappear(){
            sharedState.esercizioNoteDetailView = false
        }
        .navigationBarTitle(esercizio.nome)
        .navigationBarItems(trailing: NavigationLink(destination: NoteListView(esercizio: esercizio, sharedState: sharedState)) {
            Text("Note")
        })
    }
}
