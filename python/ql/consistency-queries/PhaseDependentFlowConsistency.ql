private import python
private import semmle.python.dataflow.new.DataFlow::DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.python.dataflow.new.internal.VariableCapture as VariableCapture

from Node node
where
  not exists(node.getScope()) and
  exists(Node nodeFrom, Node nodeTo | node in [nodeFrom, nodeTo] |
    // the list of step relations used with PhaseDependentFlow has been compiled
    // manually, and there isn't really a good way to do so automatically :|
    DataFlowPrivate::LocalFlow::definitionFlowStep(nodeFrom, nodeTo)
    or
    DataFlowPrivate::LocalFlow::expressionFlowStep(nodeFrom, nodeTo)
    or
    DataFlowPrivate::LocalFlow::useUseFlowStep(nodeFrom, nodeTo)
    or
    VariableCapture::valueStep(nodeFrom, nodeTo)
  )
select node,
  "Node being used in PhaseDependentFlow does not have result for .getScope(), so will not work properly (since division into run-time/import-time is based on .getScope result)"
