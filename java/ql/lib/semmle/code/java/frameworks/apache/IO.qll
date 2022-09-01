/** Custom definitions related to the Apache Commons IO library. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class ApacheCommonsIOCustomSummaryCsv extends SummaryModelCsv {
  /**
   * Models that are not yet auto generated or where the generated summaries will
   * be ignored.
   * Note that if a callable has any handwritten summary, all generated summaries
   * will be ignored for that callable.
   */
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.io;IOUtils;false;toBufferedInputStream;;;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.io;IOUtils;true;writeLines;(Collection,String,Writer);;Argument[0].Element;Argument[2];taint;manual",
        "org.apache.commons.io;IOUtils;true;writeLines;(Collection,String,Writer);;Argument[1];Argument[2];taint;manual",
        "org.apache.commons.io;IOUtils;true;toByteArray;(Reader);;Argument[0];ReturnValue;taint;manual",
        "org.apache.commons.io;IOUtils;true;toByteArray;(Reader,String);;Argument[0];ReturnValue;taint;manual",
      ]
  }
}
