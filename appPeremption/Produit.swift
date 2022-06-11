import Foundation

// énumérations pour toutes les catégories de produits
public enum TypeProduits: String, CaseIterable, Identifiable {
    case fruits_legumes = "Fruits et Légumes", poisson = "Poisson", viande = "Viande", epicerie_salee = "Épicerie Salée", epicerie_sucree = "Épicerie Sucrée", boissons = "Boissons", prod_frais = "Produits Frais"
    
    public var id: TypeProduits { self }
}


struct Produit: Codable, Identifiable {
    var id: Int // le code barre sera identifié comme l'id du produit
    var nom: String
    var type: String
    var quantite : Int
    var peremp = Date()
        
}
