import SwiftUI

struct EsercizioDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @ObservedObject var timerManager = TimerManager.shared
    @State private var isEditing: Bool = false
    @State private var isViewingNotes: Bool = false
    
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
            
            if timerManager.timerRunning {
                Text("Tempo rimanente: \(Int(timerManager.secondsRemaining)) secondi")
                    .font(.largeTitle)
                    .padding()
                
                ProgressView(value: timerManager.secondsRemaining, total: Double(esercizio.tempoRecupero))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
                    .animation(.linear(duration: 0.1), value: timerManager.secondsRemaining)
            }
            
            if timerManager.timerRunning {
                Button(action: {
                    timerManager.stopTimer()
                }) {
                    Text("Stop Timer")
                }
                .padding()
            } else {
                Button(action: {
                    timerManager.startTimer(duration: Double(esercizio.tempoRecupero))
                }) {
                    Text("Avvia Timer")
                }
                .padding()
            }
            
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
                    NavigationLink(destination: NoteListView(esercizio: esercizio), isActive: $isViewingNotes) {
                        EmptyView()
                    }.hidden()
                )
            }
        }
        .padding()
        .navigationBarTitle(esercizio.nome, displayMode: .inline)
        .onAppear {
            timerManager.loadTimerState()
        }
    }
}
