---
category: minorAnalysis
---
* Enums and `System.DateTimeOffset` are now treated as *simple* types, which means that they are considered to have a sanitizing effect. This impacts many queries, among others the `cs/log-forging` query.
