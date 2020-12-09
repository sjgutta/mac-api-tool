//
//  ContentView.swift
//  Mac API Tool
//
//  Created by Sajan  Gutta on 12/9/20.
//

import SwiftUI

struct ContentView: View {
    @State var url: String = ""
    
    var body: some View {
        Text("Mac API Tool")
            .font(.title)
            .multilineTextAlignment(.center)
            .padding(.top)
        
        VStack(alignment: .leading) {
            HStack {
                Text("Base URL")
                    .font(.callout)
                    .bold()
                Spacer()
                Button(action: {
                    exit(-1)
                }) {
                    Text("Quit App")
                }
            }
            TextField("Enter URL...", text: $url)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding(.leading).padding(.trailing)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
