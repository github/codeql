---
category: minorAnalysis
---
* Most data flow queries that track flow from *remote* flow sources now use the current *threat model* configuration instead. This doesn't lead to any changes in the produced alerts (as the default configuration is *remote* flow sources) unless the threat model configuration is changed.
* Data flow queries that track flow from *local* flow sources now use the current *threat model* configuration instead. This may lead to changes in the produced alerts if the threat model configuration only uses *remote* flow sources.
