/**
 * Provides classes for working with JavaScript testing frameworks.
 */

import javascript
import semmle.javascript.frameworks.TestingCustomizations

/**
 * A syntactic construct that represents a single test.
 */
abstract class Test extends Locatable { }

/**
 * A QUnit test, that is, an invocation of `QUnit.test`.
 */
class QUnitTest extends Test, @call_expr {
  QUnitTest() {
    exists(MethodCallExpr mce | mce = this |
      mce.getReceiver().(VarAccess).getName() = "QUnit" and
      mce.getMethodName() = "test"
    )
  }
}

/**
 * A BDD-style test (as used by Mocha.js, Unit.js, Jasmine and others),
 * that is, an invocation of a function named `it` where the first argument
 * is a string and the second argument is a function.
 */
class BddTest extends Test, @call_expr {
  BddTest() {
    exists(CallExpr call | call = this |
      call.getCallee().(VarAccess).getName() = "it" and
      exists(call.getArgument(0).getStringValue()) and
      exists(call.getArgument(1).flow().getAFunctionValue(0))
    )
  }
}

/** DEPRECATED: Alias for BddTest */
deprecated class BDDTest = BddTest;

/**
 * Gets the test file for `f` with stem extension `stemExt`, where `stemExt` is "test" or "spec".
 * That is, a file named `<base>.<stemExt>.<ext>` in the
 * same directory as `f` which is named `<base>.<ext>`.
 */
pragma[noinline]
File getTestFile(File f, string stemExt) {
  stemExt = ["test", "spec"] and
  result.getBaseName().regexpMatch(".*\\.(test|spec)\\..*") and
  result = f.getParentContainer().getFile(f.getStem() + "." + stemExt + "." + f.getExtension())
}

/**
 * A Jest test, that is, an invocation of a global function named
 * `test` where the first argument is a string and the second
 * argument is a function. Additionally, the invocation happens in a file
 * named `<base>.test.<ext>` in the same directory as a file named
 * `<base>.<ext>`.
 */
class JestTest extends Test, @call_expr {
  JestTest() {
    exists(CallExpr call | call = this |
      call.getCallee().(GlobalVarAccess).getName() = "test" and
      exists(call.getArgument(0).getStringValue()) and
      exists(call.getArgument(1).flow().getAFunctionValue(0))
    ) and
    getFile() = getTestFile(any(File f), "test")
  }
}

/**
 * A xUnit.js fact, that is, a function annotated with an xUnit.js
 * `Fact` annotation.
 */
class XUnitTest extends Test, XUnitFact { }

/**
 * A tape test, that is, an invocation of `require('tape').test`.
 */
class TapeTest extends Test, @call_expr {
  TapeTest() { this = DataFlow::moduleMember("tape", "test").getACall().asExpr() }
}

/**
 * An AVA test, that is, an invocation of `require('ava').test`.
 */
class AvaTest extends Test, @call_expr {
  AvaTest() { this = DataFlow::moduleMember("ava", "test").getACall().asExpr() }
}

/**
 * A Cucumber test, that is, an invocation of `require('cucumber')`.
 */
class CucumberTest extends Test, @call_expr {
  CucumberTest() {
    exists(DataFlow::ModuleImportNode m, CallExpr call |
      m.getPath() = "cucumber" and
      call = m.getAnInvocation().asExpr() and
      exists(call.getArgument(0).flow().getAFunctionValue()) and
      this = call
    )
  }
}
