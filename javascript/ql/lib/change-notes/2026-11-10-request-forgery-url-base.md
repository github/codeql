---
category: minorAnalysis
---
* The server-side and client-side request forgery queries (`js/request-forgery` and `js/client-side-request-forgery`) now treat the second (`base`) argument of the `URL` constructor as a taint step. This can reveal previously missed alerts in code such as `new URL("/path", base)`, where `base` is user-controlled.
