---
category: minorAnalysis
---
* ASP.NET Core controller definition has been made more precise. The amount of introduced taint sources or eliminated false positives should be low though, since the most common pattern is to derive all user defined ASP.NET Core controllers from the standard Controller class, which is not affected. 
