/**
 * @name Inconsistent getAPrimaryQlClass predicate
 * @description A getAPrimaryQlClass predicate should result in the name of the class.
 * @kind problem
 * @problem.severity error
 * @id ql/primary-ql-class-consistency
 * @tags correctness
 * @precision very-high
 */

import ql

from ClassPredicate pred, String constant
where
  exists(string className, string constantName |
    pred.getParent().getName() = className and
    pred.getName() = "getAPrimaryQlClass" and
    constant = pred.getBody().(ComparisonFormula).getRightOperand() and
    constant.getValue() = constantName and
    // might be "Foo::classname", detect by matching with a regexp
    not constantName.regexpMatch(".*\\b" + className + "$") and
    // ignore constants with "?" in them
    not constantName.regexpMatch(".*\\?.*")
  )
select pred,
  "The getAPrimaryQlClass predicate $@ instead of the class name \"" + pred.getParent().getName() +
    "\".", constant, "results in \"" + constant.getValue() + "\""
