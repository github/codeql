/**
 * Provides implementation classes modeling the ZeroMQ networking library.
 */

import semmle.code.cpp.models.interfaces.FlowSource

/**
 * Remote flow sources.
 */
private class ZmqSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;zmq_recv;;;Argument[*1];remote", ";;false;zmq_recvmsg;;;Argument[*1];remote",
        ";;false;zmq_msg_recv;;;Argument[*0];remote",
      ]
  }
}

/**
 * Remote flow sinks.
 */
private class ZmqSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;zmq_send;;;Argument[*1];remote-sink",
        ";;false;zmq_sendmsg;;;Argument[*1];remote-sink",
        ";;false;zmq_msg_send;;;Argument[*0];remote-sink",
      ]
  }
}

/**
 * Flow steps.
 */
private class ZmqSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;zmq_msg_init_data;;;Argument[*1];Argument[*0];taint",
        ";;false;zmq_msg_data;;;Argument[*0];ReturnValue[*];taint",
      ]
  }
}
