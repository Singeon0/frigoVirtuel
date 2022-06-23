import SwiftUI

// Variables globales
let defaults = UserDefaults.standard // Endroits où seront enregistrées les données
var codeBar: [Produit] = [] // dans cette liste seront inclus les produits qui été scanné, c'est en quelques sorte un historique
var produits: [Produit] = [] // dans cette liste sont référencés les produits actuellement dans le frigo

@main
struct appPeremptionApp: App {
    
    //Instructions au démarrage
    init() {
        if let data = UserDefaults.standard.data(forKey: "produits") { // Chargements des produits
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                produits = try decoder.decode([Produit].self, from: data)

            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        
        if let data1 = UserDefaults.standard.data(forKey: "codeBar") { // Chargements des produits
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                codeBar = try decoder.decode([Produit].self, from: data1)

            } catch {
                print("Unable to Decode Code (\(error))")
            }
        }
//        UserDefaults.standard.removeObject(forKey: "codeBar") // permet de supprimer les variables enregitrer
//        UserDefaults.standard.removeObject(forKey: "produits")
        produits = delPeremp(produits: produits)
        print("codeBar: \(codeBar)")
        print("produits: \(produits)")
    }
    
    // Ouverture de la première vu
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

func delPeremp(produits: [Produit]) -> [Produit] { // cette fonction me retourne les produits qui ont une date de péremption >= à la date du jour
    var up: [Produit] = []
    for prod in produits {
        if prod.peremp >= Date() {
            print("toDel: \(prod)\n")
            up.append(prod)
        }
    }
    print("Update: \(up)\n")
    return up
}
