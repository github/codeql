/**
 * Provides implementation classes modeling the ZeroMQ networking library.
 */

import semmle.code.cpp.models.interfaces.FlowSource

/**
 * Remote flow sources.
 */
private class ZMQSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;zmq_recv;;;Argument[*1];remote",
        ";;false;zmq_recvmsg;;;Argument[*1];remote",
        ";;false;zmq_msg_recv;;;Argument[*0];remote",
      ]
  }
}

/**
 * Remote flow sinks.
 */
private class ZMQSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;zmq_send;;;Argument[*1];remote-sink",
        ";;false;zmq_msg_init_data;;;Argument[*1];remote-sink",
        ";;false;zmq_sendmsg;;;Argument[*1];remote-sink",
        ";;false;zmq_msg_send;;;Argument[*0];remote-sink",
      ]
  }
}

        // TODO: flow into / through zmq_msg_data ?
