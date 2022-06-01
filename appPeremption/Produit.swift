import Foundation

public enum TypeProduits: String, CaseIterable, Identifiable {
    case viande = "Viande", fruits_legumes = "Fruits et Légumes", poisson = "Poisson", epicerie_salee = "Épicerie Salée", epicerie_sucree = "Épicerie Sucrée", boissons = "Boissons", prod_frais = "Produits Frais"
    
    public var id: TypeProduits { self }
}


struct Produit: Codable, Identifiable {
    var id: String
    var cb: Int
    var type: String
    var quantite : Int
    var peremp = Date()
}

