/**
 * @name TestCase implements tearDown but doesn't call super.tearDown()
 * @description A JUnit 3.8 test method that overrides 'tearDown' but does not call 'super.tearDown'
 *              may result in subsequent tests failing, or allow the current state to persist and
 *              affect subsequent tests.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/junit-teardown-without-super
 * @tags testability
 *       maintainability
 *       frameworks/junit
 */

import java

from TearDownMethod m1
where
  m1.fromSource() and
  not m1.getDeclaringType().isAbstract() and
  not exists(TearDownMethod m2 | m1.overrides(m2) and m1.callsSuper(m2))
select m1, "TestCase implements tearDown but doesn't call super.tearDown()."
