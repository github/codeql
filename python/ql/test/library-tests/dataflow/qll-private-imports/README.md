Sometimes we accidentally re-export too much from `DataFlow` such that for example we can access `Add` from `DataFlow::Add` :disappointed:

This test should always FAIL to compile!
