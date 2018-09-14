import cpp
import semmle.code.cpp.controlflow.IRGuards

from IRGuardCondition guard
select guard.getAST()