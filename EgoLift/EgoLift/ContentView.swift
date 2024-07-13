import SwiftUI

struct ContentView: View {
    @ObservedObject var palestra = Palestra()
    @State private var nuovoAllenamentoNome: String = ""
    @State private var isAddingAllenamento: Bool = false

    var body: some View {
        NavigationView {
            VStack {
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

                Spacer()

                HStack {
                    Button(action: {
                        isAddingAllenamento.toggle()
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .frame(width: 30, height: 30)
                    }
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

                    Spacer()

                    NavigationLink(destination: EserciziListView()) {
                        Text("E")
                            .font(.largeTitle)
                            .frame(width: 30, height: 30)
                    }

                    Spacer()

                    NavigationLink(destination: TuttiEserciziView()) {
                        Text("Tutti")
                            .font(.largeTitle)
                            .frame(width: 60, height: 30)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Allenamenti")
        }
    }
}
