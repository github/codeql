import python
private import semmle.python.dataflow.new.DataFlow

// Sometimes we accidentally re-export too much from `DataFlow` such that for example we can access `Add` from `DataFlow::Add` :(
//
// This test should always FAIL to compile!
from DataFlow::Add this_should_not_work
select this_should_not_work
