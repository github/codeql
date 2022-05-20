/**
 * @name Erroneous class compare
 * @description Finds checks of an object's type based on its class name
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cs/class-name-comparison
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-486
 */

import csharp
import semmle.code.csharp.commons.ComparisonTest
import semmle.code.csharp.frameworks.System

ComparisonTest getComparisonTest(Expr e) { result.getExpr() = e }

class StringComparison extends Expr {
  StringComparison() {
    exists(ComparisonTest ct | ct = getComparisonTest(this) |
      ct.getComparisonKind().isEquality() and
      ct.getFirstArgument().stripCasts().getType() instanceof StringType and
      ct.getSecondArgument().stripCasts().getType() instanceof StringType
    )
  }

  Expr getAnOperand() { result = getComparisonTest(this).getAnArgument() }
}

from StringComparison sc, PropertyAccess pa
where
  sc.getAnOperand() instanceof StringLiteral and
  sc.getAnOperand() = pa and
  pa.getTarget() = any(SystemTypeClass c).getFullNameProperty()
select sc, "Erroneous class compare."
