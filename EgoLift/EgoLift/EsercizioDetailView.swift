import SwiftUI

struct EsercizioDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @ObservedObject var timerManager = TimerManager.shared
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
            
            if timerManager.timerRunning {
                Button(action: {
                    timerManager.stopTimer()
                }) {
                    Text("Stop Timer")
                }
                .padding()
            } else {
                Button(action: {
                    timerManager.startTimer(duration: Double(esercizio.tempoRecupero), for: esercizio.id)
                }) {
                    Text("Avvia Timer")
                }
                .padding()
            }
            
            if timerManager.timerRunning {
                Text("Tempo rimanente: \(Int(timerManager.secondsRemaining)) secondi")
                    .font(.largeTitle)
                    .padding()
                
                ProgressView(value: timerManager.secondsRemaining, total: Double(esercizio.tempoRecupero))
                    .progressViewStyle(LinearProgressViewStyle(tint: timerManager.currentEsercizioID == esercizio.id ? Color.green : Color.red))
                    .padding()
                    .animation(.linear(duration: 0.1), value: timerManager.secondsRemaining)
            }
            
            Spacer()
        }
        .onAppear {
            sharedState.esercizioDetailView = true
            timerManager.loadTimerState()
        }
        .onDisappear {
            sharedState.esercizioDetailView = false
        }
        .padding()
        .navigationBarTitle(esercizio.nome)
        .navigationBarItems(trailing: Button(action: {
            isViewingNotes.toggle()
        }) {
            Text("Note")
        }
        .sheet(isPresented: $isViewingNotes) {
            NoteListView(esercizio: esercizio, sharedState: sharedState)
        })
    }
}
