---
category: minorAnalysis
---
* Added a new query, `js/polyfill-io-compromised-script`, which detects uses in HTML and JavaScript of the compromised `polyfill.io` content delivery network.
* Modified existing query, `js/functionality-from-untrusted-source`, to add a new check for the compromised `polyfill.io` content delivery network.
* Created a shared library, `semmle.javascript.security.FunctionalityFromUntrustedSource`, to separate the logic from the existing query and allow having a separate new Polyfill-specific query.
