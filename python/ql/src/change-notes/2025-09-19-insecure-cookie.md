---
category: minorAnalysis
---
* The `py/insecure-cookie` query has been split into multiple queries; with `py/insecure-cookie` checking for cases in which `Secure` flag is not set, `py/client-exposed-cookie` checking for cases in which the `HttpOnly` flag is not set, and the `py/samesite-none` query checking for cases in which the `SameSite` attribute is set to `None`. These queries also now only alert for cases in which the cookie is detected to contain sensitive data.