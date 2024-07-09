---
category: minorAnalysis
---
* Added a new query, `js/functionality-from-untrusted-domain`, which detects uses in HTML and JavaScript scripts from untrusted domains, including the compromised `polyfill.io` content delivery network, and can be extended to detect other compromised scripts using data extensions.
* Modified existing query, `js/functionality-from-untrusted-source`, to allow adding this new query, but reusing the same logic.
* Created a shared library, `semmle.javascript.security.FunctionalityFromUntrustedSource`, to separate the logic from that existing query and allow having a separate "untrusted domain" query.
