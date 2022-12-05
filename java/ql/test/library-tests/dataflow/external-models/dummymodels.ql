import java
import semmle.code.java.dataflow.ExternalFlow

from string package
where extSummaryModel(package, _, _, _, _, _, _, _, _, _)
select package
