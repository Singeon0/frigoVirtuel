import SwiftUI

//Nécessaire de faire une structure IDENTIFIABLE avec un id afin d'afficher les types de produits dans une List
struct Types: Identifiable, Hashable {
    let name: String
    let id = UUID()
}

private var types = [ // on ne peut pas réutiliser les enums dans une List
    Types(name: "Fruits et Légumes"),
    Types(name: "Poisson"),
    Types(name: "Viande"),
    Types(name: "Épicerie Salée"),
    Types(name: "Épicerie Sucrée"),
    Types(name: "Boissons"),
    Types(name: "Produits Frais")
]

struct ContentView: View {
    @State var showingScanner = false
    @State var barcodeValue = ""
    @State var isPopup = false
    @State var isBlack = false

    var body: some View {
        
        // affichage liste des produits
        VStack {
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
                                .onLongPressGesture(minimumDuration: 0.5) { // clique long sur produit = suppression de celui-ci
                                    print("suppression de \(prod)")
                                    
                                    produits = delProd(produits: produits, produit: prod)
                                    //suppression du produit dans le UserDefault
                                   do {
                                       // Create JSON Encoder
                                       let encoder = JSONEncoder()

                                       // Encode Note
                                       let data = try encoder.encode(produits)

                                       // Write/Set Data
                                       UserDefaults.standard.set(data, forKey: "produits")

                                   } catch {
                                       print("Unable to Encode Array of Notes (\(error))")
                                   }
                                }
                                .listRowBackground(yellowPeremp(date: prod.peremp) ? Color.white : Color.yellow) // produit en jaune si prod proche de la péremption
                        }
                    }.navigationBarTitle(Text("Produits"))
                        .onTapGesture(count: 1) { isPopup = true } // si clique sur nom catégorie, ouverture du message de prévention
                        .alert(isPresented: $isPopup) {
                            Alert(title: Text("Gaspillage alimentaire"), message: Text("En France, les pertes et gaspillages alimentaires représentent 10 millions de tonnes de produits par an.\n \n Ce gaspillage représente un prélèvement inutile de ressources naturelles, telles que les terres cultivables et l’eau, et des émissions de gaz à effet de serre qui pourraient être évitées.\n \n Ce sont également des déchets qui pourraient être évités qui n’auraient donc pas à être traités et n’engendreraient pas les coûts de gestion afférents. \n \n Toutes les étapes de la chaîne alimentaire, production, transformation, distribution et consommation, participent aux pertes et gaspillages alimentaires."), dismissButton: .default(Text("Fermer")))
                        }
                }
            }
        }
        
        VStack {

        HStack {
                Spacer()

                Button("+") {

                    // demande d'autorisation à l'utilisateur d'accepter les notifications, ne s'exécute qu'une seule fois
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
                    ModalScannerView(barcodeValue: "", openFirst: self.showingScanner, torchIsOn: false, code: 10)
                }
            }
        }
    }     //ICI
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


func yellowPeremp(date: Date) -> Bool {
    //cette ftc retourne True si le produit périme dans 3 jours ou moins
    let nextDate = Date(timeIntervalSinceNow: 3600*24*3)
    //print("nextDate : \(date>=nextDate)")
    return (date>=nextDate)
    
}

func delProd(produits: [Produit], produit: Produit) -> [Produit] {
    print("le produit à supprimer = \(produit)")
    var up: [Produit] = []
    for prod in produits {
        if !(prod.id == produit.id && prod.nom == produit.nom && prod.peremp == produit.peremp && prod.quantite == produit.quantite) {
            up.append(prod)
        }
    }
    return up
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
    }
}
