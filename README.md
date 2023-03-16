# IPC - GBM

This is the implementation of the evaluation project for the selection process of the iOS developer position at GBM.

The project consists in three steps. 
1. Build a line chart with the information from this endpoint `https://run.mocky.io/v3/cc4c350b-1f11-42a0-a1aa-f8593eafeb1e`
2. Implement biometry authentication to access to the application. 
3. Show the line chart updating the information every "N" seconds. 

## Installation

Please clone the project and navigate to the project folder. 

Install the pod.

```sh
cd IPC
pod install
open IPC.xcworkspace
```

Also there is a package from `SPM` that is used for testing. Make sure the package is installed. 

## Description

- The project was developed trying to follow the `SOLID` principle. Also some design patterns was implemented, some of them are `Builder`, `Coordinator` and `Router`. 
- The architecture of the projec is MVVM, with some other implementations with the purpouse of maintain a clean architecture. 
- The test were developed following the `Test Doubles` patterns. Also there are some `Snapshot` tests that are very useful to detect undesire changes on the views. 