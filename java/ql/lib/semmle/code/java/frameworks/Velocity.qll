/** Definitions related to the Apache Velocity Templating library. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class VelocitySummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.velocity.context;AbstractContext;true;put;;;Argument[1];Argument[-1];taint;manual",
        "org.apache.velocity.context;AbstractContext;true;internalPut;;;Argument[1];Argument[-1];taint;manual",
      ]
  }
}
