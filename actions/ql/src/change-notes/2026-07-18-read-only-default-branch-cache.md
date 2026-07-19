---
category: minorAnalysis
---
* The `actions/cache-poisoning/code-injection`, `actions/cache-poisoning/direct-cache`, and `actions/cache-poisoning/poisonable-step` queries now account for read-only cache access on low-trust triggers that run in the default branch scope. Results are retained for triggers that GitHub allows to write to that cache scope.
