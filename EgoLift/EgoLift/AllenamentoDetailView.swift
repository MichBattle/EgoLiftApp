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
    @State private var showErrorAlert = false
    
    var body: some View {
        VStack {
            List {
                ForEach(allenamento.esercizi.indices, id: \.self) { index in
                    NavigationLink(destination: EsercizioTabView(esercizi: allenamento.esercizi, currentIndex: index)) {
                        Text(allenamento.esercizi[index].nome)
                            .font(.title3)
                            .padding(10)
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        let esercizio = allenamento.esercizi[index]
                        allenamento.rimuoviEsercizio(esercizio: esercizio)
                    }
                }
            }.listStyle(PlainListStyle())
            
            Spacer()
        }
        .navigationBarTitle(allenamento.nome)
        .navigationBarItems(trailing: Button(action: {
            isAddingFromLibrary.toggle()
        }) {
            Text("+")
                .font(.largeTitle)
                .frame(width: 30, height: 30)
        })
        .sheet(isPresented: $isAddingFromLibrary) {
            EserciziLibraryView(allenamento: allenamento)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Errore"),
                message: Text("Esercizio con lo stesso nome e descrizione esiste già."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
