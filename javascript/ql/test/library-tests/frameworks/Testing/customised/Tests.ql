import semmle.javascript.frameworks.Testing

class MyTest extends Test, CallExpr {
  MyTest() { getCallee().(VarAccess).getName() = "mytest" }
}

from Test t
select t
