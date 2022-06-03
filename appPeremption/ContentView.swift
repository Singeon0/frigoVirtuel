import SwiftUI

//Nécessaire de faire une structure IDENTIFIABLE avec un id afin d'afficher les types de produits dans une List
struct Types: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

private var types = [
    Types(name: "Viande"),
    Types(name: "Fruits et Légumes"),
    Types(name: "Poisson"),
    Types(name: "Épicerie Salée"),
    Types(name: "Épicerie Sucrée"),
    Types(name: "Boissons"),
    Types(name: "Produits Frais")
]

struct ContentView: View {
    @State var showingScanner = false
    @State var barcodeValue = ""

    var body: some View {

        // affichage liste des produits
        NavigationView {
            List {
                //Text("Users").font(.largeTitle)
                ForEach(types) { type in
                    Section(header: Text(type.name).font(.title2).foregroundColor(Color.blue).fontWeight(.bold)) {
                        ForEach(produits.filter {produ in return produ.type == type.name}, id: \.id) { prod in
                            HStack {
                                Image(prod.type)
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 2.0))
                                VStack (alignment: .leading) {
                                    Text(prod.nom).font(.headline)
                                    Text("Quantité : " + String(prod.quantite)).font(.subheadline)
                                    Text("Péremption : " + dateToString(date: prod.peremp)).font(.subheadline)
                                }
                            }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
                        }
                    }.navigationBarTitle(Text("Produits"))
                }
            }
        }
        
        VStack{
                        
        HStack {
                Spacer()
                
                Button("+") {
                    
                    // demande d'autorisation à l'utilisateur d'accepter les notifications
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    
                    print(produits) // ne s'exécute pas si l'iphone n'est pas connecté à l'IDE
                    self.showingScanner = true
                }
                .font(.system(.largeTitle))
                            .frame(width: 47, height: 40)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 7)
                .background(Color.blue)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                // la vu qui sera ouverte après avoir cliqué sur "+"
                .sheet(isPresented: self.$showingScanner) {
                    ModalScannerView(barcodeValue: self.$barcodeValue, openFirst: self.showingScanner, torchIsOn: false)
                }
            }
        }
    }
}

// permet l'affichage d'une date au format string, nécessairre pour l'affichage des produits
func dateToString (date: Date) -> String {
    // Create Date Formatter
    let dateFormatter = DateFormatter()

    // Set Date Format
    dateFormatter.dateFormat = "dd/MM/YY"

    // Convert Date to String
    return (dateFormatter.string(from: date))
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
    }
}
