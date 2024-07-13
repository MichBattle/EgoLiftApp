import SwiftUI

struct AllenamentoDetailView: View {
    @ObservedObject var allenamento: Allenamento
    @ObservedObject var palestra: Palestra
    @State private var isAddingFromLibrary: Bool = false
    @State private var showErrorAlert = false
    
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
                        allenamento.rimuoviEsercizio(esercizio: esercizio)
                    }
                }
            }
            
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
    }
}
