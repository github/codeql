import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import CsvValidation
import semmle.code.java.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "my.qltest;C;false;stepArgRes;(Object);;Argument[0];ReturnValue;taint;manual",
        "my.qltest;C;false;stepArgArg;(Object,Object);;Argument[0];Argument[1];taint;manual",
        "my.qltest;C;false;stepArgQual;(Object);;Argument[0];Argument[-1];taint;manual",
        "my.qltest;C;false;stepQualRes;();;Argument[-1];ReturnValue;taint;manual",
        "my.qltest;C;false;stepQualArg;(Object);;Argument[-1];Argument[0];taint;manual",
        "my.qltest;C;false;stepArgResGenerated;(Object);;Argument[0];ReturnValue;taint;generated",
        "my.qltest;C;false;stepArgResGeneratedIgnored;(Object,Object);;Argument[0];ReturnValue;taint;generated",
        "my.qltest;C;false;stepArgResGeneratedIgnored;(Object,Object);;Argument[1];ReturnValue;taint;manual",
      ]
  }
}

from DataFlow::Node node1, DataFlow::Node node2
where FlowSummaryImpl::Private::Steps::summaryThroughStepTaint(node1, node2, _)
select node1, node2
