## 4.1.4

### Minor Analysis Improvements

* Calls to `super` without explict arguments now have their implicit arguments generated. For example, in `def foo(x, y) { super } end` the call to `super` becomes `super(x, y)`.
