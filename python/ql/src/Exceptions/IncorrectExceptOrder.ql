/**
 * @name Unreachable `except` block
 * @description Handling general exceptions before specific exceptions means that the specific
 *              handlers are never executed.
 * @kind problem
 * @tags quality
 *       reliability
 *       error-handling
 *       external/cwe/cwe-561
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/unreachable-except
 */

import python
import semmle.python.dataflow.new.internal.DataFlowDispatch
import semmle.python.ApiGraphs
import semmle.python.frameworks.data.internal.ApiGraphModels

predicate builtinException(string name) {
  typeModel("builtins.BaseException~Subclass", "builtins." + name, "")
}

predicate builtinExceptionSubclass(string base, string sub) {
  typeModel("builtins." + base + "~Subclass", "builtins." + sub, "")
}

newtype TExceptType =
  TClass(Class c) or
  TBuiltin(string name) { builtinException(name) }

class ExceptType extends TExceptType {
  Class asClass() { this = TClass(result) }

  string asBuiltinName() { this = TBuiltin(result) }

  predicate isBuiltin() { this = TBuiltin(_) }

  string getName() {
    result = this.asClass().getName()
    or
    result = this.asBuiltinName()
  }

  string toString() { result = this.getName() }

  DataFlow::Node getAUse() {
    result = classTracker(this.asClass())
    or
    API::builtin(this.asBuiltinName()).asSource().flowsTo(result)
  }

  ExceptType getADirectSuperclass() {
    result.asClass() = getADirectSuperclass(this.asClass())
    or
    result.isBuiltin() and
    result.getAUse().asExpr() = this.asClass().getABase()
    or
    builtinExceptionSubclass(result.asBuiltinName(), this.asBuiltinName()) and
    this != result
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startColumn` of line `startLine` to
   * column `endColumn` of line `endLine` in file `filepath`.
   * For more information, see
   * [Providing locations in CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filePath, int startLine, int startColumn, int endLine, int endColumn
  ) {
    this.asClass()
        .getLocation()
        .hasLocationInfo(filePath, startLine, startColumn, endLine, endColumn)
    or
    this.isBuiltin() and
    filePath = "" and
    startLine = 0 and
    startColumn = 0 and
    endLine = 0 and
    endColumn = 0
  }
}

predicate incorrectExceptOrder(ExceptStmt ex1, ExceptType cls1, ExceptStmt ex2, ExceptType cls2) {
  exists(int i, int j, Try t |
    ex1 = t.getHandler(i) and
    ex2 = t.getHandler(j) and
    i < j and
    cls1 = exceptClass(ex1) and
    cls2 = exceptClass(ex2) and
    cls1 = cls2.getADirectSuperclass*()
  )
}

ExceptType exceptClass(ExceptStmt ex) { ex.getType() = result.getAUse().asExpr() }

from ExceptStmt ex1, ExceptType cls1, ExceptStmt ex2, ExceptType cls2, string msg
where
  incorrectExceptOrder(ex1, cls1, ex2, cls2) and
  if cls1 = cls2
  then msg = "This except block handling $@ is unreachable; as $@ also handles $@."
  else
    msg =
      "This except block handling $@ is unreachable; as $@ for the more general $@ always subsumes it."
select ex2, msg, cls2, cls2.getName(), ex1, "this except block", cls1, cls1.getName()
