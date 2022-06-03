import SwiftUI

///TODO :
///Mettre en couleur les produits 3 jours avant péremption
///Supprimer les produits périmés -> changer l'id d'un upProd par le vrai id


// Variables globales
let defaults = UserDefaults.standard // Endroits où seront enregistrées les données
var codeBar: [Int] = []
var produits: [Produit] = []

@main
struct appPeremptionApp: App {
    
    //Instructions au démarrage
//    init() {
//        codeBar = defaults.object(forKey: "codeBar") as? [Int] ?? [Int]() // Chargement de tous les codes barres déjà référencés
//        
//        if let data = UserDefaults.standard.data(forKey: "produits") { // Chargements des produits
//            do {
//                // Create JSON Decoder
//                let decoder = JSONDecoder()
//
//                // Decode Note
//                produits = try decoder.decode([Produit].self, from: data)
//
//            } catch {
//                print("Unable to Decode Notes (\(error))")
//            }
//        }
//
//    }
    
    // Ouverture de la première vu
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
