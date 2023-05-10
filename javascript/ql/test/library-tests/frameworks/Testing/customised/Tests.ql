import semmle.javascript.frameworks.Testing

class MyTest extends Test, CallExpr {
  MyTest() { this.getCallee().(VarAccess).getName() = "mytest" }
}

from Test t
select t
