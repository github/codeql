import cpp
import semmle.code.cpp.dataflow.DataFlow
import semmle.code.cpp.dataflow.DataFlow2
import semmle.code.cpp.dataflow.DataFlow3
import semmle.code.cpp.dataflow.DataFlow4
import semmle.code.cpp.dataflow.TaintTracking
import semmle.code.cpp.dataflow.TaintTracking2
import semmle.code.cpp.dataflow.RecursionPrevention

class TestConf1 extends DataFlow::Configuration {
  TestConf1() { this = "TestConf1" }

  override predicate isSource(DataFlow::Node source) { any() }

  override predicate isSink(DataFlow::Node sink) { any() }
}

class TestConf2 extends DataFlow2::Configuration {
  TestConf2() { this = "TestConf2" }

  override predicate isSource(DataFlow::Node source) {
    exists(TestConf1 conf1 | conf1.hasFlowTo(source))
  }

  override predicate isSink(DataFlow::Node sink) { exists(TestConf1 conf1 | conf1.hasFlowTo(sink)) }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(TestConf1 conf1 |
      conf1.hasFlowTo(n1) and
      conf1.hasFlowTo(n2)
    )
  }
}

class TestConf3 extends DataFlow3::Configuration {
  TestConf3() { this = "TestConf3" }

  override predicate isSource(DataFlow::Node source) {
    exists(TestConf2 conf2 | conf2.hasFlowTo(source))
  }

  override predicate isSink(DataFlow::Node sink) { exists(TestConf2 conf2 | conf2.hasFlowTo(sink)) }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(TestConf2 conf2 |
      conf2.hasFlowTo(n1) and
      conf2.hasFlowTo(n2)
    )
  }
}

class TestConf4 extends DataFlow4::Configuration {
  TestConf4() { this = "TestConf4" }

  override predicate isSource(DataFlow::Node source) {
    exists(TestConf3 conf3 | conf3.hasFlowTo(source))
  }

  override predicate isSink(DataFlow::Node sink) { exists(TestConf3 conf3 | conf3.hasFlowTo(sink)) }

  override predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(TestConf3 conf3 |
      conf3.hasFlowTo(n1) and
      conf3.hasFlowTo(n2)
    )
  }
}

select 1
