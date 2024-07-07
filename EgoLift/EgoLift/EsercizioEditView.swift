import SwiftUI

struct EsercizioEditView: View {
    @ObservedObject var esercizio: Esercizio
    @Binding var isPresented: Bool
    @State private var nome: String
    @State private var descrizione: String
    @State private var tempoRecupero: String
    
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
                TextField("Nome Esercizio", text: $nome)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                ZStack(alignment: .topLeading) {
                    if descrizione.isEmpty {
                        Text("Descrizione Esercizio")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                    }
                    TextEditor(text: $descrizione)
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .frame(maxWidth: .infinity, minHeight: 150)
                }
                .frame(maxWidth: .infinity)
                
                TextField("Tempo di Recupero (secondi)", text: $tempoRecupero)
                    .keyboardType(.numberPad)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: tempoRecupero) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.tempoRecupero = filtered
                        }
                    }
                
                Button(action: {
                    if let recupero = Int(tempoRecupero) {
                        esercizio.nome = nome
                        esercizio.descrizione = descrizione
                        esercizio.tempoRecupero = recupero
                        isPresented = false
                    }
                }) {
                    Text("Salva Modifiche")
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Modifica Esercizio", displayMode: .inline)
            .navigationBarItems(leading: Button("Annulla") {
                isPresented = false
            })
        }
    }
}
