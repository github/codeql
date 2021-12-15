import semmle.javascript.frameworks.Testing

class MyTest extends Test, CallExpr {
  MyTest() { getCallee().(VarAccess).getName() = "mytest" }

  override string toString() { result = CallExpr.super.toString() }
}

from Test t
select t
