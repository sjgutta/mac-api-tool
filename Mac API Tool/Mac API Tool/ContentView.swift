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
    @State var response: String = ""
    @State var param_string: String = ""
    @State var auth_param_name: String = ""
    @State var auth_param_value: String = ""
    
    var body: some View {
        VSplitView {
            VStack {
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
                
                VStack(alignment: .leading) {
                    Text("Auth Param (Name and Value)")
                        .font(.callout)
                        .bold()
                    HStack {
                        TextField("Name", text: $auth_param_name)
                            .frame(width: 200)
                        TextField("Value", text: $auth_param_value)
                    }
                }.padding(.leading).padding(.trailing).padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Query Params/Body (Enter as 'Key = Value' per line)")
                        .font(.callout)
                        .bold()
                    TextEditor(text: $param_string)
                }.padding(.leading).padding(.trailing).padding(.bottom)
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Response (Drag Divider to Expand)")
                        .bold()
                }
                TextEditor(text: $response)
            }
            .frame(minHeight: 200, alignment: .top)
            .padding()
        }
    }
    
    func get_params_dict(param_string: String) -> Dictionary<String, String> {
        var split_by_lines = param_string.split(whereSeparator: \.isNewline)
        var result = Dictionary<String, String>()
        for line in split_by_lines {
            var key_value_split = line.components(separatedBy: "=")
            if key_value_split.count > 1 {
                var key = key_value_split[0].trimmingCharacters(in: .whitespacesAndNewlines)
                var value = key_value_split[1].trimmingCharacters(in: .whitespacesAndNewlines)
                if key != "" && value != ""{
                    result[key] = value
                }
            }
        }
        return result
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
