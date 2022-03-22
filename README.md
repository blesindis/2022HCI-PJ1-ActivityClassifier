# 2022HCI-PJ1-ActivityClassifier
### Model
**Create ML**

**Input:** AccelerationX, AccelerationY, AccelerationZ, GyroX, GyroY, GyroZ

**Output:** Label, LabelProbability

**Labels:** Waving, Left, Right, Stable




### App
**SwiftUI**

Gather detector data at a time interval of 0.03, update model result every 3 seconds and print it on screen simultaneously.



### Data
Using _Sensor Logger_ on phone to collect data upon every movement.

About 120 training data for each label class on average.
