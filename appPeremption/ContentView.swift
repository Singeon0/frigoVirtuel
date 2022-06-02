import SwiftUI

struct ContentView: View {
    @State var showingScanner = false
    @State var barcodeValue = ""
    

    var body: some View {

        // affichage liste des produits
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
                            Text(prod.nom).font(.headline)
                            Text("Quantité : " + String(prod.quantite)).font(.subheadline)
                            Text("Péremption : " + dateToString(date: prod.peremp)).font(.subheadline)
                        }
                    }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
                }.navigationBarTitle(Text("Produits"))
            }
        }
        
        VStack{
                        
        HStack {
                Spacer()
                
                Button("+") {
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
                    ModalScannerView(barcodeValue: self.$barcodeValue, openFirst: self.showingScanner, torchIsOn: false)
                }
            }
        }
    }
}

// permet l'affichage d'une date au format string, nécessairre pour l'affichage des produits
func dateToString (date: Date) -> String {
    // Create Date Formatter
    let dateFormatter = DateFormatter()

    // Set Date Format
    dateFormatter.dateFormat = "YY/MM/dd"

    // Convert Date to String
    return (dateFormatter.string(from: date))
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .padding()
    }
}
