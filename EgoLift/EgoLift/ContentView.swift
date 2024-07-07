import SwiftUI

struct ContentView: View {
    @ObservedObject var palestra = Palestra()
    @State private var nuovoAllenamentoNome: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Nome Allenamento", text: $nuovoAllenamentoNome)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    palestra.aggiungiAllenamento(nome: nuovoAllenamentoNome)
                    nuovoAllenamentoNome = ""
                }) {
                    Text("Aggiungi Allenamento")
                }
                .padding()
                
                List {
                    ForEach(palestra.allenamenti, id: \.id) { allenamento in
                        NavigationLink(destination: AllenamentoDetailView(allenamento: allenamento, palestra: palestra)) {
                            Text(allenamento.nome)
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let allenamento = palestra.allenamenti[index]
                            palestra.eliminaAllenamento(allenamento: allenamento)
                        }
                    }
                }
            }
            .navigationBarTitle("Allenamenti")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
