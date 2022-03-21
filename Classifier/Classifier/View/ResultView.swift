//
//  Result.swift
//  Classifier
//
//  Created by Gin on 2022/3/17.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var viewController: ViewController
    
    var result: String{viewController.label}
    
    
    var body: some View {
        if (result != "Stable"){
            Text(result)
                .font(.largeTitle)
        }

        
    }
}

struct Result_Previews: PreviewProvider {
    @StateObject static private var viewController = ViewController(updateInterval: 0.02).started()
    
    static var previews: some View {
        ResultView()
            .environmentObject(viewController)
    }
}
