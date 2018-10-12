import java
import semmle.code.java.controlflow.Guards

from ConditionBlock cb, boolean testIsTrue, BasicBlock controlled
where
  cb.controls(controlled, testIsTrue) and
  cb.getEnclosingCallable().getDeclaringType().hasName("Test")
select cb.getCondition(), testIsTrue, controlled
