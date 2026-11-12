---
category: minorAnalysis
---
* The `cpp/missing-check-scanf` query produces fewer false positives when an unaliased local output variable is overwritten with a default value if a `scanf`-like call fails.
