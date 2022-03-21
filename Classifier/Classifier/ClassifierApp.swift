//
//  ClassifierApp.swift
//  Classifier
//
//  Created by Gin on 2022/3/17.
//

import SwiftUI

@main
struct ClassifierApp: App {
    @StateObject private var viewController = ViewController(updateInterval: 0.03).started()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewController)
        }
    }
}
