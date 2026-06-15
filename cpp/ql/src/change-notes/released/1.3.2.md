## 1.3.2

### Minor Analysis Improvements

* Added dataflow models for `SysAllocString` and related functions.
* The `cpp/badly-bounded-write`, `cpp/equality-on-floats`, `cpp/short-global-name`, `cpp/static-buffer-overflow`, `cpp/too-few-arguments`, `cpp/useless-expression`, `cpp/world-writable-file-creation` queries no longer produce alerts on files created by CMake to test the build configuration.
