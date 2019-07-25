import cpp
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.Taint

from FunctionCall fc, Function f, string str, FunctionInput inModel, FunctionOutput outModel
where
	fc.getTarget() = f and
	(
		(
			f.(TaintFunction).hasTaintFlow(inModel, outModel) and
			str = "taint"
		) or (
			f.(DataFlowFunction).hasDataFlow(inModel, outModel) and
			str = "dataflow"
		)
	)
select
	fc, f, str, inModel, outModel
