import SwiftUI

struct EsercizioDetailView: View {
    @ObservedObject var esercizio: Esercizio
    @State private var isEditing: Bool = false
    @State private var isViewingNotes: Bool = false
    @State private var timerRunning: Bool = false
    @State private var secondsRemaining: Double = 0
    @State private var totalSeconds: Double = 0
    @State private var timer: Timer?
    
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
            
            if timerRunning {
                Text("Tempo rimanente: \(Int(secondsRemaining)) secondi")
                    .font(.largeTitle)
                    .padding()
                
                ProgressView(value: totalSeconds - secondsRemaining, total: totalSeconds)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
                    .animation(.linear(duration: 0.1), value: secondsRemaining)
            }
            
            if timerRunning {
                Button(action: {
                    stopTimer()
                }) {
                    Text("Stop Timer")
                }
                .padding()
            } else {
                Button(action: {
                    startTimer()
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
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        totalSeconds = Double(esercizio.tempoRecupero)
        secondsRemaining = totalSeconds
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 0.01
            } else {
                timer?.invalidate()
                timerRunning = false
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timerRunning = false
    }
}
