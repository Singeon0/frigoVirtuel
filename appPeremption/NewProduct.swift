//
//  newProduct.swift
//  ExampleProject
//
//  Created by MacBook d'Arthur on 13/05/2022.
//  Copyright © 2022 narongrit kanhanoi. All rights reserved.
//

import SwiftUI

struct NewProduct: View {
    @State var nom: String
    @State var type = TypeProduits.fruits_legumes
    @State var qtt = 1
    @State var peremp = Date()
    @Binding var codeBarVal: String
    @Environment(\.presentationMode) var presentationMode // permet de fermer la fenêtre quand le bouton "Enregistrer est cliquer"
    
    var body: some View {
        NavigationView { // sans ça je ne peux pas cliquer sur les picker
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
                
                let newProd = Produit(id: self.nom, cb: Int(codeBarVal) ?? 0, type: self.type.rawValue, quantite: Int(self.qtt) , peremp: self.peremp)
                produits.append(newProd)
                
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

