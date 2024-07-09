import SwiftUI

struct AllenamentoDetailView: View {
    @ObservedObject var allenamento: Allenamento
    @ObservedObject var palestra: Palestra
    @State private var nuovoEsercizioNome: String = ""
    @State private var nuovaDescrizione: String = ""
    @State private var tempoRecupero: String = ""
    @State private var numeroSet: String = ""
    @State private var tipoEsercizioSelezionato = "Petto"
    let tipiEsercizio = ["Petto", "Schiena", "Spalle", "Bicipiti", "Tricipiti", "Gambe", "Addome", "Cardio", "Altro"]
    @State private var isAddingEsercizio: Bool = false
    @State private var isAddingFromLibrary: Bool = false
    
    var body: some View {
        VStack {
            List {
                ForEach(allenamento.esercizi.indices, id: \.self) { index in
                    NavigationLink(destination: EsercizioTabView(esercizi: allenamento.esercizi, currentIndex: index)) {
                        Text(allenamento.esercizi[index].nome)
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        let esercizio = allenamento.esercizi[index]
                        allenamento.eliminaEsercizio(esercizio: esercizio)
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(allenamento.nome)
        .navigationBarItems(trailing: Menu {
            Button(action: {
                isAddingEsercizio.toggle()
            }) {
                Text("Crea Nuovo Esercizio")
            }
            
            Button(action: {
                isAddingFromLibrary.toggle()
            }) {
                Text("Aggiungi da Libreria")
            }
        } label: {
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
                        allenamento.aggiungiEsercizio(nome: nuovoEsercizioNome, descrizione: nuovaDescrizione, tempoRecupero: recupero, numeroSet: numeroSet, tipo: tipoEsercizioSelezionato)
                        nuovoEsercizioNome = ""
                        nuovaDescrizione = ""
                        tempoRecupero = ""
                        numeroSet = ""
                        tipoEsercizioSelezionato = "Petto"
                        isAddingEsercizio = false
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
        }
        .sheet(isPresented: $isAddingFromLibrary) {
            EserciziLibraryView(allenamento: allenamento)
        }
    }
}
