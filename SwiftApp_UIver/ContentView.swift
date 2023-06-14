//
//  ContentView.swift
//  SwiftApp_UIver
//
//  Created by user on 2023/06/14.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("ひずみ計算")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .padding()
                
                NavigationLink(destination: SolidCalculationView()) {
                    Text("中実丸棒")
                        .font(.largeTitle)
                        .padding(50)
                    
                }
                NavigationLink(destination: HollowCalculationView()) {
                    Text("中空丸棒")
                        .font(.largeTitle)
                        .padding(50)
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
