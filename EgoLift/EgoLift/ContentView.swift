import SwiftUI

struct ContentView: View {
    @State private var nuovoAllenamentoNome: String = ""
    @State private var isAddingAllenamento: Bool = false
    @State private var isAddingFromLibrary: Bool = false
    @State private var isAddingNota: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var showEmptyFieldsAlert: Bool = false
    @State private var isAddingEsercizio: Bool = false
    @State private var selectedTab: Int = 0
    @State private var nuovaNota: String = ""
    @State private var nuovoEsercizioNome: String = ""
    @State private var nuovaDescrizione: String = ""
    @State private var tempoRecupero: String = ""
    @State private var isAddingFromAllenamento: Bool = false
    @State private var isAddingFromCategoria: Bool = false
    @State private var numeroSet: String = ""
    @State private var tipoEsercizioSelezionato = "Petto"
    @State private var esercizi: [Esercizio] = []
    @State private var showRestrictedAlert: Bool = false
    @State private var showActionSheet: Bool = false
    @State private var erroreVuoto: Bool = false
    @ObservedObject var palestra = Palestra()
    @ObservedObject var sharedState = SharedState()
    let tipiEsercizio = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]
    
    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    homeView
                } else if selectedTab == 1 {
                    NavigationView {
                        EserciziListView(sharedState: sharedState)
                    }
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
                if !sharedState.esercizioDetailView && !sharedState.eserciziListView && !sharedState.esercizioNoteDetailView {
                    if sharedState.allenamentoDetailView {
                        showActionSheet.toggle()
                    } else if sharedState.noteListView {
                        isAddingNota.toggle()
                    } else if sharedState.eserciziCategoriaView {
                        isAddingFromCategoria.toggle()
                        isAddingEsercizio.toggle()
                    } else {
                        isAddingAllenamento.toggle()
                    }
                } else {
                    showRestrictedAlert = true // Mostra l'alert
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
            }
            .padding()
            .alert("Non puoi aggiungere nuovi elementi da qua", isPresented: $showRestrictedAlert) {
                Button("Ok", role: .cancel){}
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Aggiungi Esercizio"), buttons: [
                    .default(Text("Aggiungi da Libreria")) {
                        isAddingFromLibrary.toggle()
                    },
                    .default(Text("Crea Nuovo Esercizio")) {
                        isAddingFromAllenamento.toggle()
                        isAddingEsercizio.toggle()
                    },
                    .cancel()
                ])
            }
            .alert("Nuovo Allenamento", isPresented: $isAddingAllenamento) {
                        TextField("Inserisci nome", text: $nuovoAllenamentoNome)
                Button("OK", action: {
                    if nuovoAllenamentoNome == "" {
                        erroreVuoto.toggle()
                    } else {
                        palestra.aggiungiAllenamento(nome: nuovoAllenamentoNome)
                    }
                    nuovoAllenamentoNome = ""
                    isAddingAllenamento = false
                })
                Button("Annulla", action: {
                    nuovoAllenamentoNome = ""
                    isAddingAllenamento = false
                })
            }
            .sheet(isPresented: $isAddingFromLibrary) {
                if let allenamento = sharedState.currentAllenamento {
                    EserciziLibraryView(allenamento: allenamento, sharedState: sharedState)
                } else {
                    Text("Seleziona un allenamento prima di aggiungere esercizi dalla libreria.")
                }
            }
            .alert("Inserisci il nome!", isPresented: $erroreVuoto){
                Button("Ok", role: .cancel){}
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
                        sharedState.currentEsercizio?.aggiungiNota(content: nuovaNota)
                        nuovaNota = ""
                        isAddingNota = false
                    }) {
                        Text("Aggiungi Nota")
                    }
                    .padding()
                }
                .padding()
                .onDisappear(){
                    isAddingNota = false
                }
            }
            .alert("Esiste già un sercizio con lo stesso nome e descrizione!", isPresented: $showErrorAlert) {
                Button("Ok", role: .cancel){}
            }
            .alert("Riepmpi tutti i campi!", isPresented: $showEmptyFieldsAlert) {
                Button("Ok", role: .cancel){}
            }
            .sheet(isPresented: $isAddingEsercizio, onDismiss: {
                isAddingEsercizio = false
                isAddingFromCategoria = false
                isAddingFromAllenamento = false
            }) {
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
                    
                    // Sezione aggiunta per selezionare il tipo di esercizio
                    if !isAddingFromCategoria {
                        VStack(alignment: .center) {
                            Text("Tipo di Esercizio")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                                .padding(.top, 12)
                            Picker("Tipo di Esercizio", selection: $tipoEsercizioSelezionato) {
                                ForEach(tipiEsercizio, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal, 8)
                        }
                    }
                    
                    Button(action: {
                        var tipo: String
                        if isAddingFromAllenamento {
                            tipo = tipoEsercizioSelezionato
                        } else if isAddingFromCategoria {
                            tipo = sharedState.categoria
                        } else {
                            tipo = "Altro"
                        }
                        
                        if nuovoEsercizioNome.isEmpty || nuovaDescrizione.isEmpty || tempoRecupero.isEmpty || numeroSet.isEmpty {
                            showEmptyFieldsAlert = true
                        } else if let recupero = Int(tempoRecupero) {
                            if DatabaseManager.shared.addEsercizio(nome: nuovoEsercizioNome, descrizione: nuovaDescrizione, tempoRecupero: recupero, note: "", numeroSet: numeroSet, tipo: tipo, allenamentoID: 0, isOriginal: true) {
                                nuovoEsercizioNome = ""
                                nuovaDescrizione = ""
                                tempoRecupero = ""
                                numeroSet = ""
                                tipoEsercizioSelezionato = "Petto"
                                isAddingEsercizio = false
                                isAddingFromCategoria = false
                                isAddingFromAllenamento = false
                                loadEsercizi()
                            } else {
                                showErrorAlert = true
                            }
                        }
                    }) {
                        Text("Aggiungi Esercizio")
                    }
                    .padding()
                }
                .padding()
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("Errore"),
                        message: Text("Esiste già un sercizio con lo stesso nome e descrizione"),
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
