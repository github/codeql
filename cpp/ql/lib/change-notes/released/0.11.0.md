## 0.11.0

### Breaking Changes

* The `Container` and `Folder` classes now derive from `ElementBase` instead of `Locatable`, and no longer expose the `getLocation` predicate. Use `getURL` instead.

### New Features

* Added a new class `AdditionalCallTarget` for specifying additional call targets.

### Minor Analysis Improvements

* More field accesses are identified as `ImplicitThisFieldAccess`.
* Added support for new floating-point types in C23 and C++23.
