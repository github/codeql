/** Custom definitions related to the Apache Commons IO library. */

import java
import IOGenerated
private import semmle.code.java.dataflow.ExternalFlow

// TODO: manual models that were not generated yet
private class ApacheCommonsIOCustomSummaryCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.io;IOUtils;false;toBufferedInputStream;;;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;true;writeLines;(Collection,String,Writer);;Argument[0];Argument[2];taint",
        "org.apache.commons.io;IOUtils;true;toByteArray;(Reader);;Argument[0];ReturnValue;taint",
        "org.apache.commons.io;IOUtils;true;toByteArray;(Reader,String);;Argument[0];ReturnValue;taint",
      ]
  }
}
