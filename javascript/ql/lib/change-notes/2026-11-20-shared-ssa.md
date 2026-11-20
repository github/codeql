---
category: majorAnalysis
---
* JavaScript and TypeScript data flow now use the shared SSA implementation, including refinements and conservative captured-variable definitions. The existing public SSA APIs remain available as shared-backed adapters, and the separate JavaScript SSA computation has been removed. This improves barrier-guard handling across refinements and control-flow joins, reducing false positives when guarded and overwritten values merge, and orders post-update flow after call and assignment completion.
