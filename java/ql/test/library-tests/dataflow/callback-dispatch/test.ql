import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import TestUtilities.InlineExpectationsTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "my.callback.qltest;A;false;applyConsumer1;(Object,Consumer1);;Argument[0];Argument[1].Parameter[0];value",
        "my.callback.qltest;A;false;applyConsumer1Field1Field2;(A,A,Consumer1);;Argument[0].Field[my.callback.qltest.A.field1];Argument[2].Parameter[0];value",
        "my.callback.qltest;A;false;applyConsumer1Field1Field2;(A,A,Consumer1);;Argument[1].Field[my.callback.qltest.A.field2];Argument[2].Parameter[0];value",
        "my.callback.qltest;A;false;applyConsumer2;(Object,Consumer2);;Argument[0];Argument[1].Parameter[0];value",
        "my.callback.qltest;A;false;applyConsumer3;(Object,Consumer3);;Argument[0];Argument[1].Parameter[0];value",
        "my.callback.qltest;A;false;applyConsumer3_ret_postup;(Consumer3);;Argument[0].Parameter[0];ReturnValue;value",
        "my.callback.qltest;A;false;forEach;(Object[],Consumer3);;Argument[0].ArrayElement;Argument[1].Parameter[0];value",
        "my.callback.qltest;A;false;applyProducer1;(Producer1);;Argument[0].ReturnValue;ReturnValue;value",
        "my.callback.qltest;A;false;produceConsume;(Producer1,Consumer3);;Argument[0].ReturnValue;Argument[1].Parameter[0];value",
        "my.callback.qltest;A;false;produceConsume;(Producer1,Consumer3);;Argument[1].Parameter[0];ReturnValue;value",
        "my.callback.qltest;A;false;applyConverter1;(Object,Converter1);;Argument[0];Argument[1].Parameter[0];value",
        "my.callback.qltest;A;false;applyConverter1;(Object,Converter1);;Argument[1].ReturnValue;ReturnValue;value"
      ]
  }
}

class Conf extends DataFlow::Configuration {
  Conf() { this = "qltest:callback-dispatch" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr().(MethodAccess).getMethod().hasName("source")
  }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "flow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    exists(DataFlow::Node src, DataFlow::Node sink, Conf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = src.asExpr().(MethodAccess).getAnArgument().toString()
    )
  }
}
