/**
 * Provides classes for working with JavaScript testing frameworks.
 */

import javascript
import semmle.javascript.frameworks.xUnit
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
class BDDTest extends Test, @call_expr {
  BDDTest() {
    exists(CallExpr call | call = this |
      call.getCallee().(VarAccess).getName() = "it" and
      exists(call.getArgument(0).getStringValue()) and
      exists(call.getArgument(1).flow().getAFunctionValue(0))
    )
  }
}

/**
 * Gets the test file for `f` with stem extension `stemExt`.
 * That is, a file named `<base>.<stemExt>.<ext>` in the
 * same directory as `f` which is named `<base>.<ext>`.
 */
bindingset[stemExt]
File getTestFile(File f, string stemExt) {
  result = f.getParentContainer().getFile(f.getStem() + "." + stemExt + "." + f.getExtension())
}

/**
 * Gets a test file for `f`.
 * That is, a file named `<base>.<stemExt>.<ext>` in the
 * same directory as `f`, where `f` is named `<base>.<ext>` and
 * `<stemExt>` is a well-known test file identifier, such as `test` or `spec`.
 */
File getATestFile(File f) {
  result = f.getParentContainer().getFile(getATestFileName(f))
}

/**
 * Gets a name of a test file for `f`.
 * That is, `<base>.<stemExt>.<ext>` where
 * `f` is named `<base>.<ext>` and `<stemExt>` is
 * a well-known test file identifier, such as `test` or `spec`.
 */
// Helper predicate factored out for performance.
// This predicate is linear in the size of f, and forces
// callers to join only once against f rather than two separate joins
// when computing the stem and the extension.
// This loses some flexibility because callers cannot specify
// an arbitrary stemExt.
pragma[nomagic]
private string getATestFileName(File f) {
  result = f.getStem() + "." + ["test", "spec"] + "." + f.getExtension()
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
