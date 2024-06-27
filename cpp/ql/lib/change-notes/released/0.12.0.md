## 0.12.0

### Breaking Changes

* The expressions `AssignPointerAddExpr` and `AssignPointerSubExpr` are no longer subtypes of `AssignBitwiseOperation`.

### Minor Analysis Improvements

* The "Returning stack-allocated memory" (`cpp/return-stack-allocated-memory`) query now also detects returning stack-allocated memory allocated by calls to `alloca`, `strdupa`, and `strndupa`.
* Added models for `strlcpy` and `strlcat`.
* Added models for the `sprintf` variants from the `StrSafe.h` header.
* Added SQL API models for `ODBC`.
* Added taint models for `realloc` and related functions.
