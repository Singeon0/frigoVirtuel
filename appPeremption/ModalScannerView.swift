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
    @Binding var barcodeValue: String
    @State var openFirst: Bool
    @State var torchIsOn = false
    @State var openNewProd = false
    @State var cameraPosition = AVCaptureDevice.Position.back
    //@Environment(\.presentationMode) var presentationMode // permet de fermer la fenêtre quand le bouton "Enregistrer est cliquer"

    var body: some View {
        VStack {
            HStack {
                Text("Scan de code bar")
                    
                    .font(.system(size: 30, weight: Font.Weight.bold))
                    .foregroundColor(Color.blue)
                
                Button {
                    self.torchIsOn.toggle()
                } label: {
                    Image(systemName: "bolt.fill")
                        .renderingMode(.original)
                        .foregroundColor(Color.white)
                        .padding(12.0)
                }
                
                
            } .padding()
            
            
            
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
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 400, maxHeight: 400, alignment: .topLeading)
//                .overlay(cameraFrame() donne un cadre à la zone de caméra
//                            .stroke(lineWidth: 5)
//                            .frame(width: 500, height: 250)
//                            .foregroundColor(.blue))

            
            Spacer()
            
            Button("Enregistrer") {
                self.openFirst = false
                let code = Int(barcodeValue) ?? 0
                if (!codeBar.contains(code)) {
                    codeBar.append(code)
                    defaults.set(codeBar, forKey: "codeBar")
                    print("pas dans la liste")
                    self.openNewProd = true
                }
                
                
                
                //presentationMode.wrappedValue.dismiss()
            }
            .sheet(isPresented: $openNewProd) {
                NewProduct(nom: "", type: TypeProduits(rawValue: "") ?? TypeProduits.viande, qtt: 1, peremp: Date(), codeBarVal: $barcodeValue)
            } .padding()
                .font(.system(size: 18, weight: Font.Weight.bold))
                .foregroundColor(Color.white)
                .background(Color.green)
                .cornerRadius(.infinity)
        }.padding(50) .background(Color.black)
    }
}
// ce qui va s'afficher dans la preview
struct ModalScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ModalScannerView(barcodeValue: .constant("Valeur du code bar"), openFirst: false)
    }
}

