//
//  ContentView.swift
//  Mac API Tool
//
//  Created by Sajan  Gutta on 12/9/20.
//

import SwiftUI

struct ContentView: View {
    @State var url: String = ""
    @State var request_type: RequestType = RequestType.get

    
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
        
        VStack(alignment: .leading) {
            Text("Request Type")
                .font(.callout)
                .bold()
            Picker("Request Type", selection: $request_type) {
                ForEach(RequestType.allCases, id: \.self) { this_type in
                    Text(this_type.rawValue).tag(this_type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
        }.padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
