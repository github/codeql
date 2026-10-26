## 5.4.1

### Minor Analysis Improvements

* The guards libraries (`semmle.code.cpp.controlflow.Guards` and `semmle.code.cpp.controlflow.IRGuards`) have been improved to recognize more guards.
* Improved dataflow through global variables in the new dataflow library (`semmle.code.cpp.dataflow.new.DataFlow` and `semmle.code.cpp.dataflow.new.TaintTracking`). Queries based on these libraries will produce more results on codebases with many global variables.
* The global value numbering library (`semmle.code.cpp.valuenumbering.GlobalValueNumbering` and `semmle.code.cpp.ir.ValueNumbering`) has been improved so more expressions are assigned the same value number.
