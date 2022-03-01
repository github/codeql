---
category: minorAnalysis
---
* Improved analysis of attributes for data-flow and taint tracking queries, so `getattr`/`setattr` are supported, and a write to an attribute properly stops flow for the old value in that attribute.
* Added post-update nodes (`DataFlow::PostUpdateNode`) for arguments in calls that can't be resolved.
