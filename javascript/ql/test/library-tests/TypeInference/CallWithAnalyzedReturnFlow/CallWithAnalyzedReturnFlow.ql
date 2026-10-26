import javascript

from DataFlow::AnalyzedValueNode call
where
  call instanceof CallWithAnalyzedReturnFlow or
  call instanceof CallWithNonLocalAnalyzedReturnFlow
select call, call.getAValue()
