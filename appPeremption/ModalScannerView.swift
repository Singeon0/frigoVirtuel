//
//  ModalScannerView.swift
//  ExampleProject
//
//  Created by narongrit kanhanoi on 7/1/2563 BE.
//  Copyright © 2563 narongrit kanhanoi. All rights reserved.
//

import SwiftUI
import CarBode
import AVFoundation

struct cameraFrame: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines( [
                
                CGPoint(x: 0, y: height * 0.25),
                CGPoint(x: 0, y: 0),
                CGPoint(x:width * 0.25, y:0)
            ])
            
            path.addLines( [
                
                CGPoint(x: width * 0.75, y: 0),
                CGPoint(x: width, y: 0),
                CGPoint(x:width, y:height * 0.25)
            ])
            
            path.addLines( [
                
                CGPoint(x: width, y: height * 0.75),
                CGPoint(x: width, y: height),
                CGPoint(x:width * 0.75, y: height)
            ])
            
            path.addLines( [
                
                CGPoint(x:width * 0.25, y: height),
                CGPoint(x:0, y: height),
                CGPoint(x:0, y:height * 0.75)
               
            ])
            
        }
    }
}


struct ModalScannerView: View {
    // permet de soit ouvrir la vu d'un nouveau produit ou d'un produit déjà référencé
    enum SelectedSheet:Int, Identifiable {
        case newProd, upProd
        var id:Int { rawValue }
        
    }
    @State var selectedTarget:SelectedSheet? = nil
    @Binding var barcodeValue: String // Binding pour passer la variable dans les vues suivantes
    @State var openFirst: Bool
    @State var torchIsOn = false
    @State var cameraPosition = AVCaptureDevice.Position.back

    var body: some View {
        VStack {
            HStack {
                // Bouton pour allumer la lampe torche
                Button {
                    self.torchIsOn.toggle()
                } label: {
                    Image(systemName: "bolt.fill")
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .padding()
                    
                }
                
                
            } .padding()
            
            
            // utilisation du package de scan de code barre
            CBScanner(
                supportBarcode: .constant([.ean13]),
                torchLightIsOn: $torchIsOn,
                cameraPosition: $cameraPosition,
                mockBarCode: .constant(BarcodeData(value:"My Test Data", type: .qr))
            ){
                //print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                barcodeValue = $0.value
            }
            onDraw: {
                //print("Preview View Size = \($0.cameraPreviewView.bounds)")
                //print("Barcode Corners = \($0.corners)")
                
                let lineColor = UIColor.green
                let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                //Draw Barcode corner
                $0.draw(lineWidth: 1, lineColor: lineColor, fillColor: fillColor)
                
            }.frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: 400, alignment: .topLeading)
//                .overlay(cameraFrame() donne un cadre à la zone de caméra
//                            .stroke(lineWidth: 5)
//                            .frame(width: 500, height: 250)
//                            .foregroundColor(.blue))

            
            Spacer()
            
            Button("Enregistrer") {
                self.openFirst = false
                //let code = Int(barcodeValue) ?? 0 /// DÉCOMMENTER POUR LE FONCTIONNEMENT SUR IPHONE
                let code = Int.random(in: 1..<1000) // permet d'utiliser le simulateur
                if (!codeBar.contains(code)) { // si le code barre n'est pas déjà référencé
                    print("pas dans la liste")
                    selectedTarget = .newProd
                }
                
                else { // sinon ouvertue de la vue qui permet d'ajouter un produit avec une quantité et une date de péremption différente
                    selectedTarget = .upProd
                }
                
                
                
                //presentationMode.wrappedValue.dismiss()
            } .padding()
                .font(.system(size: 18, weight: Font.Weight.bold))
                .foregroundColor(Color.white)
                .background(Color.green)
                .cornerRadius(.infinity)
            
            
        } .sheet(item: $selectedTarget) { selectedTarget in
            switch selectedTarget {
             case .newProd:
                NewProduct(nom: "", type: TypeProduits(rawValue: "") ?? TypeProduits.viande, qtt: 1, peremp: Date(), codeBarVal: $barcodeValue)
            case .upProd:
                UpProd(codeBarVal: $barcodeValue)
            }
            
        }
        .padding(50)
        .background(Color.black)
    }
}
// ce qui va s'afficher dans la preview
struct ModalScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ModalScannerView(barcodeValue: .constant("Valeur du code bar"), openFirst: false)
    }
}
