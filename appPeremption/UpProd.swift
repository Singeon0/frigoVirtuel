import SwiftUI

struct UpProd: View {
    @State var qtt = 1
    @State var peremp = Date()
    @Binding var code: Int
    @Environment(\.presentationMode) var presentationMode // permet de fermer la fenêtre quand le bouton "Enregistrer est cliquer"

    var body: some View {
        NavigationView { // sans ça je ne peux pas cliquer sur les picker
            Form {
                Section {
                    
                    Picker("Quantité", selection: $qtt) {
                        ForEach(0 ..< 100) {
                            Text("Quantité : \($0)")
                        }
                    }.pickerStyle(.menu)
                        
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
                print("ici \(code)")
                let infos = getProdByCode(codeBar: codeBar, code: code)
                code += Int.random(in: 1..<1000) // je rajoute un nombre aléatoire au code barre du produit déjà existant afin de ne pas avoir d'id en doublon !
                let upProd = Produit(id: code, nom: infos.nom, type: infos.type, quantite: Int(self.qtt) , peremp: self.peremp)
                print(upProd)
                produits.append(upProd)
                
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
                                
                ///Création d'une notification 1 jour avant la péremption du produit
                let content = UNMutableNotificationContent()
                content.title = "\(infos.nom) est sur le point de périmer !"
                content.body = "Faites vite son temps est compté"
                content.sound = UNNotificationSound.default

                // peremp.timeIntervalSinceNow est le nombre de seconde entre maintenant et la veille du jour de péremption
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: abs(peremp.timeIntervalSinceNow - 24*3600), repeats: false)

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

// return le nom et le type de produit avec le même code barre
func getProdByCode (codeBar: [Produit], code: Int) -> (nom: String, type: String) {
    for prod in codeBar {
        if prod.id == code {
            return (prod.nom, prod.type)
        }
    }
    return ("", "") // si aucun produit n'est trouvé on ne renvoie rien (sinon erreur du compilateur)
}



//struct UpProd_Previews: PreviewProvider {
//    static var previews: some View {
//        UpProd(codeBarVal: "codeBarVal")
//    }
//}
