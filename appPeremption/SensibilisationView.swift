//
//  SensibilisationView.swift
//  appPeremption
//
//  Created by MacBook d'Arthur on 03/06/2022.
//

import SwiftUI

struct SensibilisationView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                    
                mainView
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    
    var mainView: some View {
        VStack {
            ZStack {
                VStack {
                    Image(systemName: "info.circle.fill")
                }
            }
        }
        .frame(height: 400)
        .frame(maxWidth: .infinity)
        .background(Color(red:242/255, green: 242/255, blue: 247/255))
    }
}

struct SensibilisationView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
