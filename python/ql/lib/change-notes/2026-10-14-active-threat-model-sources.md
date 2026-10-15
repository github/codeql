---
category: minorAnalysis
---
* Updated the `py/xxe`, `py/xml-bomb`, and `py/nosql-injection` queries to respect the configured threat model when selecting untrusted data sources. The default behavior remains unchanged and uses remote flow sources. As a side effect, these queries now correctly include sources modeled using data extensions.
