//codeql-extractor-options: -enable-objc-interop
//codeql-extractor-expected-status: 1

// Successful compilation would require importing Foundation for `@objc`
class A {
  @objc func foo(_ : Int) {}
  @objc subscript(i : Int) -> Int {
    get { return 0 }
  }
};

class B {}

var x : AnyObject = B()
x.foo!(17)
_ = x[17]!
