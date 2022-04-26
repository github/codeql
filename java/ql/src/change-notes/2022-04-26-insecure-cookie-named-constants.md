---
category: minorAnalysis
---
* Query `java/insecure-cookie` no longer produces a false positive if 
`cookie.setSecure(...)` is called passing a constant that always equals 
`true`.
