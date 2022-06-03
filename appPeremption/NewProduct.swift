import SwiftUI
import UserNotifications

struct NewProduct: View {
    @State var nom: String
    @State var type = TypeProduits.fruits_legumes
    @State var qtt = 1
    @State var peremp = Date()
    @Binding var codeBarVal: String
    @Environment(\.presentationMode) var presentationMode // permet de fermer la fenêtre quand le bouton "Enregistrer ce nouveau produit" est cliquer
    
    var body: some View {
        NavigationView { // sans ça je ne peux pas cliquer sur les picker
            // l'utilisateur va rentrer les infos de son nouveau produit
            Form {
                Section {
                    TextField("Nom", text: $nom)
                    
                    Picker("Type", selection: $type) {
                        ForEach (TypeProduits.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                    
                    Picker("Quantité", selection: $qtt) {
                        ForEach(0 ..< 100) {
                            Text("\($0)")
                        }
                    }
                        
                    DatePicker(
                            "Date de péremption",
                            selection: $peremp,
                            displayedComponents: [.date]
                        )
                }
            } .navigationBarTitle("Nouveau produit")
        }
                    
        VStack {
            Button("Enregistrer ce nouveau produit") {
                
                let code = Int(codeBarVal) ?? 0
                codeBar.append(code)
//                defaults.set(codeBar, forKey: "codeBar") //ajout du code barre dans la liste des codes référencés
                let newProd = Produit(id: code, nom: self.nom, type: self.type.rawValue, quantite: Int(self.qtt) , peremp: self.peremp) // création d'un nouvel objet produit
                produits.append(newProd) // ajout du nouveau produit dans la liste des produits
                
                // enregistrement dans le UserDefault du nouveau produit
//                do {
//                    // Create JSON Encoder
//                    let encoder = JSONEncoder()
//
//                    // Encode Note
//                    let data = try encoder.encode(produits)
//
//                    // Write/Set Data
//                    UserDefaults.standard.set(data, forKey: "produits")
//
//                } catch {
//                    print("Unable to Encode Array of Notes (\(error))")
//                }
                
                ///Création d'une notification 1 jour avant la péremption du produit
                let content = UNMutableNotificationContent()
                content.title = "Produit sur le point de périmer !"
                content.body = "Faites vite son temps est compté"
                content.sound = UNNotificationSound.default

                // peremp.timeIntervalSinceNow est le nombre de seconde entre maintenant et la veille du jour de péremption
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: peremp.timeIntervalSinceNow - 24*3600, repeats: false)

                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
                                
                presentationMode.wrappedValue.dismiss()
                
            }.padding()
                .font(.system(size: 18, weight: Font.Weight.bold))
                .foregroundColor(Color.white)
                .background(Color.green)
                .cornerRadius(.infinity)
        }
    }
}

//struct newProduct_Previews: PreviewProvider {
//    static var previews: some View {
//        newProduct(nom: "Nom", codeBarVal: "Code")
//            .padding()
//    }
//}

