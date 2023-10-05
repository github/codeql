## 0.9.2

### Deprecated APIs

* `getAllocatorCall` on `DeleteExpr` and `DeleteArrayExpr` has been deprecated. `getDeallocatorCall` should be used instead.

### New Features

* Added `DeleteOrDeleteArrayExpr` as a super type of `DeleteExpr` and `DeleteArrayExpr`

### Minor Analysis Improvements

* `delete` and `delete[]` are now modeled as calls to the relevant `operator delete` in the IR. In the case of a dynamic delete call a new instruction `VirtualDeleteFunctionAddress` is used to represent a function that dispatches to the correct delete implementation.
* Only the 2 level indirection of `argv` (corresponding to `**argv`) is consided for `FlowSource`.
