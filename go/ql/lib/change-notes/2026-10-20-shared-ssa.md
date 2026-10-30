---
category: breaking
---
* The Go SSA API now uses the shared SSA classes. `SsaVariable`, `SsaExplicitDefinition`, `SsaVariableCapture`, and `SsaPhiNode` have been replaced by `SsaDefinition`, `SsaExplicitWrite`, `SsaUncertainWrite`, and `SsaPhiDefinition`, respectively. Deprecated compatibility classes are available for the old names.
