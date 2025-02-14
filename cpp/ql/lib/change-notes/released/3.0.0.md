## 3.0.0

### Breaking Changes

* Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

### Deprecated APIs

* The `NonThrowingFunction` class (`semmle.code.cpp.models.interfaces.NonThrowing.NonThrowingFunction`) has been deprecated. Please use the `NonCppThrowingFunction` class instead.
