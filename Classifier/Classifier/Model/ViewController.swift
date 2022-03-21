//
//  ViewController.swift
//  Classifier
//
//  Created by Gin on 2022/3/17.
//

import SwiftUI
import UIKit
import CoreML
import CoreMotion

class ViewController: ObservableObject{
    struct ModelConstants {
        static let numOfFeatures = 6
        static let predictionWindowSize = 100
        static let sensorUpdateFrequency = 1.0 / 50
        static let hiddenInLength = 200
        static let hiddenCellInLength = 200
    }
    
    var onUpdate: (() -> Void) = {}
    
    @Published var label: String = "haha"
    @Published var counter: Int = 0
    private let motionManager = CMMotionManager()
    private var timer = Timer()
    private var updateInterval: TimeInterval
   
    
    init(updateInterval: TimeInterval){
        self.updateInterval = updateInterval
    }
    
    private let classifier = MyActivityClassifier()
    private let modelName: String = "MyActivityClassifier"
    var currentIndexInPredictWindow = 0
    
    func start(){
        initState()
        if motionManager.isDeviceMotionAvailable{
            motionManager.startDeviceMotionUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true){ _ in
                self.addMotionDataSampleToArray()
            }
        }else{
            print("Motion data isn't available on this device.")
        }
    }
    
    let accX = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accY = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accZ = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let rotX = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let rotY = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let rotZ = try? MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
    
    var currentState = try? MLMultiArray(shape: [(ModelConstants.hiddenInLength + ModelConstants.hiddenCellInLength) as NSNumber], dataType: MLMultiArrayDataType.double)
    
    func initState(){
        for i in 0...400{
            currentState![i] = 0.01
        }
    }
    
    
    func stopDeviceMotion(){
        guard motionManager.isDeviceMotionAvailable else {
            debugPrint("Core Motion Data Unavailable!")
            return
        }
        
        motionManager.stopDeviceMotionUpdates()
        
        currentIndexInPredictWindow = 0
        currentState = try? MLMultiArray(shape: [(ModelConstants.hiddenInLength + ModelConstants.hiddenCellInLength) as NSNumber], dataType: MLMultiArrayDataType.double)
    }
    
    
    
    func addMotionDataSampleToArray(){
        if let data = motionManager.deviceMotion{
            DispatchQueue.global().async {
                self.rotX![self.currentIndexInPredictWindow] = data.rotationRate.x as NSNumber
                self.rotY![self.currentIndexInPredictWindow] = data.rotationRate.y as NSNumber
                self.rotZ![self.currentIndexInPredictWindow] = data.rotationRate.z as NSNumber
                self.accX![self.currentIndexInPredictWindow] = data.gravity.x as NSNumber
                self.accY![self.currentIndexInPredictWindow] = data.gravity.y as NSNumber
                self.accZ![self.currentIndexInPredictWindow] = data.gravity.z as NSNumber
                
                
                self.currentIndexInPredictWindow += 1
                
                if (self.currentIndexInPredictWindow == ModelConstants.predictionWindowSize) {
                    DispatchQueue.main.async{
                        
                        self.label = self.activityPrediction() ?? "N/A"
                    }
                    
                    self.currentIndexInPredictWindow = 0
                    self.counter += 1
                    self.onUpdate()
                }
                
                self.onUpdate()
            }
        }
    }
    
    func activityPrediction() -> String? {
        let modelPrediction = try? classifier.prediction(
            AccelerationX: accX!,
            AccelerationY: accY!,
            AccelerationZ: accZ!,
            GyroX: rotX!,
            GyroY: rotY!,
            GyroZ: rotZ!,
            stateIn: currentState!)
        
        print(currentState)
        
        
        print(modelPrediction?.labelProbability)
        
        print(self.counter, modelPrediction?.label)
        if (modelPrediction?.labelProbability["Left"] != modelPrediction?.labelProbability["Left"]){
            modelPrediction?.label = "Stable"
        }
        
        return modelPrediction?.label
        
    }
}

extension ViewController{
    func started() -> ViewController{
        start()
        return self
    }
}

