//
//  UpProd.swift
//  appPeremption
//
//  Created by MacBook d'Arthur on 02/06/2022.
//

import SwiftUI

struct UpProd: View {
    @Binding var codeBarVal: String
    @State var qtt = 1
    @State var peremp = Date()
    @Environment(\.presentationMode) var presentationMode // permet de fermer la fenêtre quand le bouton "Enregistrer est cliquer"

    var body: some View {
        NavigationView { // sans ça je ne peux pas cliquer sur les picker
            Form {
                Section {
                    
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
                
                print(qtt)
                
                let infos = getProdByCode(produits: produits, code: Int(codeBarVal) ?? 0)
                var id = Int(codeBarVal) ?? 0
                id += Int.random(in: 1..<1000) // je rajoute un nombre aléatoire au code barre du produit déjà existant afin de ne pas avoir d'id en doublon !
                print(id)
                let upProd = Produit(id: id, nom: infos.nom, type: infos.type, quantite: Int(self.qtt) , peremp: self.peremp)
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
func getProdByCode (produits: [Produit], code: Int) -> (nom: String, type: String) {
    for prod in produits {
        if prod.id == code {
            return (prod.nom, prod.type)
        }
    }
    return ("", "")
}



//struct UpProd_Previews: PreviewProvider {
//    static var previews: some View {
//        UpProd(codeBarVal: "codeBarVal")
//    }
//}
