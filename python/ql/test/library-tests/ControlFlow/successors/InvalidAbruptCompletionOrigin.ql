import semmle.python.controlflow.internal.AstNodeImpl
import ControlFlow::Consistency

from int results
where consistencyOverview("invalidAbruptCompletionOrigin", results)
select results
