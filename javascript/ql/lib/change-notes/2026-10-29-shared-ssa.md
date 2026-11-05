---
category: majorAnalysis
---
* JavaScript and TypeScript data flow now use the shared SSA implementation, including refinements and conservative captured-variable definitions. The existing public SSA APIs remain available as shared-backed adapters; the separate JavaScript SSA computation has been removed. This improves barrier-guard handling at control-flow joins, reducing false positives when guarded and overwritten values merge, and improves the ordering of post-update flow around calls and assignments.
