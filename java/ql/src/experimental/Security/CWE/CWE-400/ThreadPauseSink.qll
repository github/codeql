/** Provides sink models related to pausing thread operations. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

/** Thread pause data model in the new CSV format. */
private class PauseThreadDataModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.lang;Thread;true;sleep;;;Argument[0];thread-pause",
        "java.util.concurrent;TimeUnit;true;sleep;;;Argument[0];thread-pause"
      ]
  }
}

/** A sink representing methods pausing a thread. */
class PauseThreadSink extends DataFlow::Node {
  PauseThreadSink() { sinkNode(this, "thread-pause") }
}
