import default
import semmle.code.cpp.ir.SSAIR

from FunctionIR funcIR
select funcIR.toString(), count(funcIR.getABlock())
