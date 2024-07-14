import SwiftUI

struct ContentView: View {
    @ObservedObject var palestra = Palestra()
    @State private var nuovoAllenamentoNome: String = ""
    @State private var isAddingAllenamento: Bool = false
    @State private var isAddingFromLibrary: Bool = false
    @State private var isAddingNota: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var isAddingEsercizio: Bool = false
    @State private var selectedTab: Int = 0
    @State private var nuovaNota: String = ""
    @State private var nuovoEsercizioNome: String = ""
    @State private var nuovaDescrizione: String = ""
    @State private var tempoRecupero: String = ""
    @State private var numeroSet: String = ""
    @State private var tipoEsercizioSelezionato = "Petto"
    @State private var esercizi: [Esercizio] = []
    @ObservedObject var sharedState = SharedState()
    let tipiEsercizio = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    homeView
                } else if selectedTab == 1 {
                    EserciziListView(sharedState: sharedState)
                }
                
                Spacer()
                
                customTabBar
            }
        }
    }
    
    var homeView: some View {
        NavigationView {
            VStack {
                WaterIntakeWidget()
                List {
                    ForEach(palestra.allenamenti, id: \.id) { allenamento in
                        NavigationLink(destination: AllenamentoDetailView(allenamento: allenamento, palestra: palestra, sharedState: sharedState)) {
                            Text(allenamento.nome)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(10)
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let allenamento = palestra.allenamenti[index]
                            palestra.eliminaAllenamento(allenamento: allenamento)
                        }
                    }
                }.listStyle(PlainListStyle())
                
                Spacer()
            }.navigationTitle("Home")
        }
    }
    
    var customTabBar: some View {
        HStack {
            Spacer()
            
            Button(action: {
                selectedTab = 0
            }) {
                Image(systemName: "house.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                if !sharedState.esercizioDetailView {
                    if sharedState.allenamentoDetailView {
                        isAddingFromLibrary.toggle()
                    } else if sharedState.noteListView {
                        isAddingNota.toggle()
                    } else if sharedState.eserciziListView {
                        isAddingEsercizio.toggle()
                    } else {
                        isAddingAllenamento.toggle()
                    }
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
            }
            .padding()
            .sheet(isPresented: $isAddingAllenamento) {
                VStack {
                    Text("Nuovo Allenamento")
                        .font(.headline)
                        .padding()
                    
                    TextEditor(text: $nuovoAllenamentoNome)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        palestra.aggiungiAllenamento(nome: nuovoAllenamentoNome)
                        nuovoAllenamentoNome = ""
                        isAddingAllenamento = false
                    }) {
                        Text("Crea Allenamento")
                    }
                    .padding()
                    
                    Button(action: {
                        isAddingAllenamento = false
                    }) {
                        Text("Annulla")
                    }
                    .padding()
                }
                .padding()
            }
            .sheet(isPresented: $isAddingFromLibrary) {
                if let allenamento = sharedState.currentAllenamento {
                    EserciziLibraryView(allenamento: allenamento, sharedState: sharedState)
                } else {
                    Text("Seleziona un allenamento prima di aggiungere esercizi dalla libreria.")
                }
            }
            .sheet(isPresented: $isAddingNota) {
                VStack {
                    Text("Nuova Nota")
                        .font(.headline)
                        .padding()
                    
                    TextEditor(text: $nuovaNota)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 150)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        // Assuming there's a method to add a note in your data model
                        sharedState.currentEsercizio?.aggiungiNota(content: nuovaNota)
                        nuovaNota = ""
                        isAddingNota = false
                    }) {
                        Text("Aggiungi Nota")
                    }
                    .padding()
                    
                    Button(action: {
                        isAddingNota = false
                    }) {
                        Text("Annulla")
                    }
                    .padding()
                }
                .padding()
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Errore"),
                    message: Text("Esercizio con lo stesso nome e descrizione esiste già."),
                    dismissButton: .default(Text("OK"))
                )
            }
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
                            if DatabaseManager.shared.addEsercizio(nome: nuovoEsercizioNome, descrizione: nuovaDescrizione, tempoRecupero: recupero, note: "", numeroSet: numeroSet, tipo: tipoEsercizioSelezionato, allenamentoID: 0, isOriginal: true) {
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
            
            Spacer()
            
            Button(action: {
                selectedTab = 1
            }) {
                Image(systemName: "archivebox.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .padding()
            
            Spacer()
        }
    }
    
    private func loadEsercizi() {
        esercizi = sharedState.esercizi
        esercizi = DatabaseManager.shared.fetchAllEsercizi()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
