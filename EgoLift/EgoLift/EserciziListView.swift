import SwiftUI

struct EserciziListView: View {
    @State private var esercizi: [Esercizio] = []
    @State private var searchText: String = ""
    @State private var isAddingEsercizio: Bool = false
    @State private var nuovoEsercizioNome: String = ""
    @State private var nuovaDescrizione: String = ""
    @State private var tempoRecupero: String = ""
    @State private var numeroSet: String = ""
    @State private var tipoEsercizioSelezionato = "Petto"
    @State private var showErrorAlert = false

    let categorie = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]
    let tipiEsercizio = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]

    var body: some View {
            VStack {
                List(categorie, id: \.self) { categoria in
                    NavigationLink(destination: EserciziCategoriaView(categoria: categoria)) {
                        Text(categoria)
                            .font(.headline)
                            .padding()
                    }
                }
            }
            .navigationBarTitle("Esercizi")
            .navigationBarItems(trailing: Button(action: {
                isAddingEsercizio.toggle()
            }) {
                Text("+")
                    .font(.largeTitle)
                    .frame(width: 30, height: 30)
            })
            .sheet(isPresented: $isAddingEsercizio) {
                VStack {
                    Text("Nuovo Esercizio")
                        .font(.headline)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Nome Esercizio")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.top, 12)
                        TextEditor(text: $nuovoEsercizioNome)
                            .padding(4)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading) {
                        Text("Descrizione Esercizio")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.top, 12)
                        TextEditor(text: $nuovaDescrizione)
                            .padding(4)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading) {
                        Text("Tempo di Recupero (secondi)")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.top, 12)
                        TextEditor(text: $tempoRecupero)
                            .keyboardType(.numberPad)
                            .padding(4)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .onChange(of: tempoRecupero) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.tempoRecupero = filtered
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading) {
                        Text("Numero Set")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.top, 12)
                        TextEditor(text: $numeroSet)
                            .padding(4)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(alignment: .leading) {
                        Text("Tipo di Esercizio")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.top, 12)
                        Picker(selection: $tipoEsercizioSelezionato, label: Text("Tipo di Esercizio")) {
                            ForEach(tipiEsercizio, id: \.self) { tipo in
                                Text(tipo).tag(tipo)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(4)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        if let recupero = Int(tempoRecupero) {
                            if DatabaseManager.shared.addEsercizio(nome: nuovoEsercizioNome, descrizione: nuovaDescrizione, tempoRecupero: recupero, note: "", numeroSet: numeroSet, tipo: tipoEsercizioSelezionato, allenamentoID: 0) {
                                nuovoEsercizioNome = ""
                                nuovaDescrizione = ""
                                tempoRecupero = ""
                                numeroSet = ""
                                tipoEsercizioSelezionato = "Petto"
                                isAddingEsercizio = false
                                loadEsercizi()
                            } else {
                                showErrorAlert = true
                            }
                        }
                    }) {
                        Text("Aggiungi Esercizio")
                    }
                    .padding()
                    
                    Button(action: {
                        isAddingEsercizio = false
                    }) {
                        Text("Annulla")
                    }
                    .padding()
                }
                .padding()
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Errore"),
                        message: Text("Esercizio con lo stesso nome e descrizione esiste già."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .onAppear {
                loadEsercizi()
            }
        
    }

    private func loadEsercizi() {
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }
}
