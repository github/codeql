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

/**
 * Gets a string that is allowed to be returned from the `getAPrimaryQlClass` implementation
 * in class `c`.
 *
 * For most languages this is just the name of `c`, but QL for Swift implements
 * the `getAPrimaryQlClass` predicate for a class `Foo` in another class `FooBase`.
 */
string getAnAllowedResultForClass(Class c) {
  result = c.getName()
  or
  c.getName() = result + "Base"
}

from ClassPredicate pred, String constant, Class c
where
  c = pred.getParent() and
  pred.getName() = "getAPrimaryQlClass" and
  exists(string constantName |
    constant = pred.getBody().(ComparisonFormula).getRightOperand() and
    constant.getValue() = constantName and
    // might be "Foo::classname", detect by matching with a regexp
    not constantName.regexpMatch(".*\\b" + getAnAllowedResultForClass(c) + "$") and
    // ignore constants with "?" in them
    not constantName.regexpMatch(".*\\?.*")
  )
select pred,
  "The getAPrimaryQlClass predicate $@ instead of the class name \"" + c.getName() + "\".",
  constant, "results in \"" + constant.getValue() + "\""
