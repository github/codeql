import default
import semmle.code.cpp.ssa.SSAIR

from FunctionIR funcIR
select funcIR.toString(), count(funcIR.getABlock())
