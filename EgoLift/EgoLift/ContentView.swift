import SwiftUI

struct ContentView: View {
    @ObservedObject var palestra = Palestra()
    @State private var nuovoAllenamentoNome: String = ""
    @State private var isAddingAllenamento: Bool = false
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                if selectedTab == 0 {
                    homeView
                } else if selectedTab == 1 {
                    EserciziListView()
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
                        NavigationLink(destination: AllenamentoDetailView(allenamento: allenamento, palestra: palestra)) {
                            Text(allenamento.nome)
                                .font(.title2) // Increase the font size
                                .fontWeight(.bold) // Make the text bold
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
                isAddingAllenamento.toggle()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
