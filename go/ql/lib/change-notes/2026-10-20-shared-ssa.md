---
category: breaking
---
* The Go SSA API now uses the shared SSA classes (`SsaDefinition`, `SsaWriteDefinition`, `SsaExplicitWrite`, `SsaParameterInit`, `SsaImplicitWrite`, `SsaUncertainWrite`, and `SsaPhiDefinition`):
  - `SsaVariable`, `SsaExplicitDefinition`, `SsaImplicitDefinition`, `SsaVariableCapture`, `SsaPseudoDefinition`, and `SsaPhiNode` have been deprecated.
  - `ControlFlow::WriteNode.definesSsaVariable`, `IR::WriteTarget.asSsaVariable`, `SsaWithFields.getBaseVariable`, and `DataFlow::ReadNode.readsSsaVariable` have been deprecated in favor of `definesSsaDefinition`, `asSsaDefinition`, `getBaseDefinition`, and `readsSsaDefinition`, respectively.
  - `SsaDefinition` no longer defines `getVariable()`, `getRoot()`, or `hasLocationInfo(...)`. Use `SsaDefinition` directly, `getBasicBlock().getScope()`, and `getLocation().hasLocationInfo(...)` instead.
  - `SsaDefinition.getAFirstUse()` is no longer available. First-use access remains available through `getAFirstUse()` on the deprecated `SsaVariable` class. `DataFlow::ReadNode.readsSsaDefinition()` matches all reads, not just first uses, and is not an equivalent replacement.
  - `SsaDefinition.getARead()` returns expression reads only. Use `DataFlow::ReadNode.readsSsaDefinition()` to include implicit reads, such as reads of result variables at function exit.
  - `IR::TypeSwitchImplicitVariableInstruction` now extends `IR::WriteInstruction`, with target class `IR::ImplicitVariableTarget`.
