import SwiftUI

struct EsercizioDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @ObservedObject var timerManager = TimerManager.shared
    @State private var isViewingNotes: Bool = false
    @ObservedObject var sharedState: SharedState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase) var scenePhase
    @State private var secondiMancanti: Double = 0
    @State private var decrementatore: Double = 0

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
                    sharedState.isTimerRunning = false
                    decrementatore = 0
                }) {
                    Text("Stop Timer")
                }
                .padding()
            } else {
                Button(action: {
                    timerManager.startTimer(duration: Double(esercizio.tempoRecupero), for: esercizio.id)
                    sharedState.isTimerRunning = true
                    secondiMancanti = timerManager.secondsRemaining
                    decrementatore = 0
                }) {
                    Text("Avvia Timer")
                }
                .padding()
            }
            
            if timerManager.timerRunning {
                if secondiMancanti > 0 {
                    Text("Tempo rimanente: \(Int(secondiMancanti)) secondi")
                        .font(.largeTitle)
                        .padding()
                    
                    ProgressView(value: secondiMancanti, total: Double(esercizio.tempoRecupero))
                        .progressViewStyle(LinearProgressViewStyle(tint: timerManager.currentEsercizioID == esercizio.id ? Color.green : Color.red))
                        .padding()
                        .animation(.linear(duration: 0.1), value: secondiMancanti)
                } else {
                    Text("Tempo rimanente: 0 secondi")
                        .font(.largeTitle)
                        .padding()
                }
            }
            
            Spacer()
        }
        .onChange(of: presentationMode.wrappedValue.isPresented) { isPresented in
            if !isPresented {
                sharedState.esercizioDetailView = false
            }
        }
        .onAppear {
            sharedState.esercizioDetailView = true
            timerManager.updateRemainingTime()
            timerManager.loadTimerState()
            secondiMancanti = timerManager.secondsRemaining
            decrementatore = 0
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                timerManager.updateRemainingTime()
                timerManager.loadTimerState()
                decrementatore += 0.5
                secondiMancanti = timerManager.secondsRemaining - Double(decrementatore)
                print(decrementatore)
            }
        }
        .onReceive(timerManager.$secondsRemaining) { _ in
            secondiMancanti = max(timerManager.secondsRemaining - Double(decrementatore), 0)
            if !timerManager.timerRunning {
                sharedState.isTimerRunning = false
                decrementatore = 0
            }
        }
        .onReceive(timerManager.$timerRunning) { timerRunning in
            if !timerRunning {
                sharedState.isTimerRunning = false
            }
        }
        .padding()
        .navigationBarTitle(esercizio.nome)
        .navigationBarItems(trailing: NavigationLink(destination: NoteListView(esercizio: esercizio, sharedState: sharedState)) {
            Text("Note")
        })
    }
}
