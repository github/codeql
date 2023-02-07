---
category: minorAnalysis
---
* The data flow library now disregards flow through code that is dead based on some basic constant propagation, for example, guards like `if (1+1>3)`.
