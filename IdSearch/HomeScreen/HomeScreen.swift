//
//  HomeScreen.swift
//  IdSearch
//
//  Created by Maurice Carrier on 8/26/19.
//  Copyright © 2019 Maurice Carrier. All rights reserved.
//

import SwiftUI

struct HomeScreen: View {
    
    @ObservedObject var viewModel = HomeScreenVM()
    
    var body: some View {
        VStack {
            
            VStack {
                Text(self.viewModel.titleLabelText)
                Text(self.viewModel.displayName).font(.headline)
            }.padding()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(self.viewModel.MRZLabelText)
                    .font(.headline)
                TextField(self.viewModel.textFieldPlaceholderText, text: self.$viewModel.inputValue)
                    .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0))
                    .cornerRadius(5)
                    .frame(width: nil, height: 50)
            }.padding(.horizontal, 15)

            
            Button(action: {
                do {
                    try self.viewModel.parseInput()
                } catch {
                    print(error)
                }
            }) {
                Text("SEARCH")
                    .fontWeight(.medium)
                    .font(.body)
                    .padding(.all, 5)
                    .background(Color.clear)
                    .foregroundColor(.blue)
                    .border(Color.blue, width: 2).cornerRadius(4)
            }
            
            
            List(self.viewModel.users) { user in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "photo").padding()
                        VStack(alignment: .leading) {
                            Text("Login: \(user.login)")
                            Text("Id: \(user.id)").font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct HomeScreen_Preview : PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
#endif
