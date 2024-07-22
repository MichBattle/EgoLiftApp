import SwiftUI

struct EsercizioEditView: View {
    @ObservedObject var esercizio: Esercizio
    @Binding var isPresented: Bool
    @State private var nome: String
    @State private var descrizione: String
    @State private var tempoRecupero: String
    @State private var alert: Bool = false

    init(esercizio: Esercizio, isPresented: Binding<Bool>) {
        self.esercizio = esercizio
        _nome = State(initialValue: esercizio.nome)
        _descrizione = State(initialValue: esercizio.descrizione)
        _tempoRecupero = State(initialValue: String(esercizio.tempoRecupero))
        self._isPresented = isPresented
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nome Esercizio")
                        .font(.headline)
                    TextEditor(text: $nome)
                        .frame(height: 40)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrizione Esercizio")
                        .font(.headline)
                    TextEditor(text: $descrizione)
                        .frame(height: 80)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Tempo di Recupero (secondi)")
                        .font(.headline)
                    TextEditor(text: $tempoRecupero)
                        .frame(height: 40)
                        .padding(4)
                        .keyboardType(.numberPad)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .onChange(of: tempoRecupero) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.tempoRecupero = filtered
                            }
                        }
                }

                Button(action: {
                    if !DatabaseManager.shared.esercizioEsisteGlobalmente(nome: nome, descrizione: descrizione) {
                        if let recupero = Int(tempoRecupero) {
                            // Update esercizio in the database
                            let success = DatabaseManager.shared.updateEsercizio(id: esercizio.id, nome: nome, descrizione: descrizione, tempoRecupero: recupero)
                            if success {
                                esercizio.nome = nome
                                esercizio.descrizione = descrizione
                                esercizio.tempoRecupero = recupero
                                isPresented = false
                            } else {
                                alert.toggle()
                            }
                        }
                    } else {
                        alert.toggle()
                    }
                }) {
                    Text("Salva Modifiche")
                }
                .padding()
                .alert("Esiste già un esercizio con lo stesso nome e descrizione!", isPresented: $alert) {
                    Button("Ok", role: .cancel) {
                        alert = false
                    }
                }

                Spacer()
            }
            .padding()
            .navigationBarTitle("Modifica Esercizio", displayMode: .inline)
            .onDisappear() {
                isPresented = false
            }
        }
    }
}
