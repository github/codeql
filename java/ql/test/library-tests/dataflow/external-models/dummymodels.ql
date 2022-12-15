import java
import semmle.code.java.dataflow.ExternalFlowExtensions

from string package
where summaryModel(package, _, _, _, _, _, _, _, _, _)
select package
