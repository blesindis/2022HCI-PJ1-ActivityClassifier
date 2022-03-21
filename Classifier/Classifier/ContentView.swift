//
//  ContentView.swift
//  Classifier
//
//  Created by Gin on 2022/3/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ResultView()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environmentObject(ViewController(updateInterval: 0.02).started())
    }
}
