import SwiftUI

struct ContentView: View {
    @State private var allenamenti: [Allenamento] = []
    @State private var nuovoAllenamentoNome: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Nome Allenamento", text: $nuovoAllenamentoNome)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    let nuovoAllenamento = Allenamento(nome: nuovoAllenamentoNome)
                    allenamenti.append(nuovoAllenamento)
                    nuovoAllenamentoNome = ""
                }) {
                    Text("Aggiungi Allenamento")
                }
                .padding()
                
                List {
                    ForEach(allenamenti, id: \.id) { allenamento in
                        NavigationLink(destination: AllenamentoDetailView(allenamento: allenamento)) {
                            Text(allenamento.nome)
                        }
                    }
                }
            }
            .navigationBarTitle("Allenamenti")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
