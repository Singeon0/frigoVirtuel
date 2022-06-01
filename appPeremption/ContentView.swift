import SwiftUI

// variables global
 // liste des codes bars référencés
// dictionnaire de produits avec leur code bar comme clé


let defaults = UserDefaults.standard
var codeBar: [Int] = []
var produits: [Produit] = []

//defaults.set(codeBar, forKey: "codeBar")
//defaults.set(produits, forKey: "produits")


     

struct ContentView: View {
    @State var showingScanner = false
    @State var barcodeValue = ""
    

    var body: some View {

        
        NavigationView {
            List {
                //Text("Users").font(.largeTitle)
                ForEach(produits, id: \.id) { prod in
                    HStack {
                        Image(prod.type)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 2.0))
                        VStack (alignment: .leading) {
                            Text(prod.id).font(.headline)
                            Text(String(prod.quantite)).font(.subheadline)
                        }
                    }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
                }.navigationBarTitle(Text("Produits"))
            }
        }
        
        VStack{
            
//            List {
//                ForEach(produits, id : \.id) { prod in
//                     Text(prod.id)
//                }
//            }
            
        HStack {
                Spacer()
                
                Button("+") {
                    print(produits)
                    
                    //codeBar = defaults.object(forKey: "codeBar") as? [Int] ?? [Int]()
                    
    //                if let data = UserDefaults.standard.data(forKey: "produits") {
    //                    do {
    //                        // Create JSON Decoder
    //                        let decoder = JSONDecoder()
    //
    //                        // Decode Note
    //                        produits = try decoder.decode([Produit].self, from: data)
    //
    //                    } catch {
    //                        print("Unable to Decode Notes (\(error))")
    //                    }
    //                }
                    
                    print(produits)
                    
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
                
                .sheet(isPresented: self.$showingScanner) {
                    ModalScannerView(barcodeValue: self.$barcodeValue, openFirst: self.showingScanner, torchIsOn: false)
                }
                //style du bouton
                
                
            }
            
        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
    }
}
