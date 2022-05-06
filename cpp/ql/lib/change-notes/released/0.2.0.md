## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

### Minor Analysis Improvements

* More Windows pool allocation functions are now detected as `AllocationFunction`s.
* The `semmle.code.cpp.commons.Buffer` library has been enhanced to handle array members of classes that do not specify a size.
