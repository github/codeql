/**
 * @name Log4j log injection and LDAP JNDI injection
 * @description Building Log4j log entries from user-controlled data may allow
 *              attackers to inject malicious code through JNDI lookups.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/log4j-injection
 * @tags security
 *       external/cwe/cwe-020
 *       external/cwe/cwe-074
 *       external/cwe/cwe-400
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.ExternalFlow
import DataFlow::PathGraph


private class LoggingSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // org.apache.logging.log4j.Logger
        "org.apache.logging.log4j;Logger;true;" +
          ["debug", "error", "fatal", "info", "trace", "warn"] +
          [
            ";(CharSequence);;Argument[0];logging",
            ";(CharSequence,Throwable);;Argument[0];logging",
            ";(Marker,CharSequence);;Argument[1];logging",
            ";(Marker,CharSequence,Throwable);;Argument[1];logging",
            ";(Marker,Message);;Argument[1];logging",
            ";(Marker,MessageSupplier);;Argument[1];logging",
            ";(Marker,MessageSupplier);;Argument[1];logging",
            ";(Marker,MessageSupplier,Throwable);;Argument[1];logging",
            ";(Marker,Object);;Argument[1];logging",
            ";(Marker,Object,Throwable);;Argument[1];logging",
            ";(Marker,String);;Argument[1];logging",
            ";(Marker,String,Object[]);;Argument[1..2];logging",
            ";(Marker,String,Object);;Argument[1..2];logging",
            ";(Marker,String,Object,Object);;Argument[1..3];logging",
            ";(Marker,String,Object,Object,Object);;Argument[1..4];logging",
            ";(Marker,String,Object,Object,Object,Object);;Argument[1..5];logging",
            ";(Marker,String,Object,Object,Object,Object,Object);;Argument[1..6];logging",
            ";(Marker,String,Object,Object,Object,Object,Object,Object);;Argument[1..7];logging",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];logging",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];logging",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];logging",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..11];logging",
            ";(Marker,String,Supplier);;Argument[1..2];logging",
            ";(Marker,String,Throwable);;Argument[1];logging",
            ";(Marker,Supplier);;Argument[1];logging",
            ";(Marker,Supplier,Throwable);;Argument[1];logging",
            ";(MessageSupplier);;Argument[0];logging",
            ";(MessageSupplier,Throwable);;Argument[0];logging", ";(Message);;Argument[0];logging",
            ";(Message,Throwable);;Argument[0];logging", ";(Object);;Argument[0];logging",
            ";(Object,Throwable);;Argument[0];logging", ";(String);;Argument[0];logging",
            ";(String,Object[]);;Argument[0..1];logging",
            ";(String,Object);;Argument[0..1];logging",
            ";(String,Object,Object);;Argument[0..2];logging",
            ";(String,Object,Object,Object);;Argument[0..3];logging",
            ";(String,Object,Object,Object,Object);;Argument[0..4];logging",
            ";(String,Object,Object,Object,Object,Object);;Argument[0..5];logging",
            ";(String,Object,Object,Object,Object,Object,Object);;Argument[0..6];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object);;Argument[0..7];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..8];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..9];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..10];logging",
            ";(String,Supplier);;Argument[0..1];logging",
            ";(String,Throwable);;Argument[0];logging", ";(Supplier);;Argument[0];logging",
            ";(Supplier,Throwable);;Argument[0];logging"
          ],
        "org.apache.logging.log4j;Logger;true;log" +
          [
            ";(Level,CharSequence);;Argument[1];logging",
            ";(Level,CharSequence,Throwable);;Argument[1];logging",
            ";(Level,Marker,CharSequence);;Argument[2];logging",
            ";(Level,Marker,CharSequence,Throwable);;Argument[2];logging",
            ";(Level,Marker,Message);;Argument[2];logging",
            ";(Level,Marker,MessageSupplier);;Argument[2];logging",
            ";(Level,Marker,MessageSupplier);;Argument[2];logging",
            ";(Level,Marker,MessageSupplier,Throwable);;Argument[2];logging",
            ";(Level,Marker,Object);;Argument[2];logging",
            ";(Level,Marker,Object,Throwable);;Argument[2];logging",
            ";(Level,Marker,String);;Argument[2];logging",
            ";(Level,Marker,String,Object[]);;Argument[2..3];logging",
            ";(Level,Marker,String,Object);;Argument[2..3];logging",
            ";(Level,Marker,String,Object,Object);;Argument[2..4];logging",
            ";(Level,Marker,String,Object,Object,Object);;Argument[2..5];logging",
            ";(Level,Marker,String,Object,Object,Object,Object);;Argument[2..6];logging",
            ";(Level,Marker,String,Object,Object,Object,Object,Object);;Argument[2..7];logging",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object);;Argument[2..8];logging",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object);;Argument[2..9];logging",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..10];logging",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..11];logging",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..12];logging",
            ";(Level,Marker,String,Supplier);;Argument[2..3];logging",
            ";(Level,Marker,String,Throwable);;Argument[2];logging",
            ";(Level,Marker,Supplier);;Argument[2];logging",
            ";(Level,Marker,Supplier,Throwable);;Argument[2];logging",
            ";(Level,Message);;Argument[1];logging",
            ";(Level,MessageSupplier);;Argument[1];logging",
            ";(Level,MessageSupplier,Throwable);;Argument[1];logging",
            ";(Level,Message);;Argument[1];logging",
            ";(Level,Message,Throwable);;Argument[1];logging",
            ";(Level,Object);;Argument[1];logging", ";(Level,Object);;Argument[1];logging",
            ";(Level,String);;Argument[1];logging",
            ";(Level,Object,Throwable);;Argument[1];logging",
            ";(Level,String);;Argument[1];logging",
            ";(Level,String,Object[]);;Argument[1..2];logging",
            ";(Level,String,Object);;Argument[1..2];logging",
            ";(Level,String,Object,Object);;Argument[1..3];logging",
            ";(Level,String,Object,Object,Object);;Argument[1..4];logging",
            ";(Level,String,Object,Object,Object,Object);;Argument[1..5];logging",
            ";(Level,String,Object,Object,Object,Object,Object);;Argument[1..6];logging",
            ";(Level,String,Object,Object,Object,Object,Object,Object);;Argument[1..7];logging",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];logging",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];logging",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];logging",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..11];logging",
            ";(Level,String,Supplier);;Argument[1..2];logging",
            ";(Level,String,Throwable);;Argument[1];logging",
            ";(Level,Supplier);;Argument[1];logging",
            ";(Level,Supplier,Throwable);;Argument[1];logging"
          ], "org.apache.logging.log4j;Logger;true;entry;(Object[]);;Argument[0];logging",
        "org.apache.logging.log4j;Logger;true;logMessage;(Level,Marker,String,StackTraceElement,Message,Throwable);;Argument[4];logging",
        "org.apache.logging.log4j;Logger;true;printf;(Level,Marker,String,Object[]);;Argument[2..3];logging",
        "org.apache.logging.log4j;Logger;true;printf;(Level,String,Object[]);;Argument[1..2];logging",
        // org.apache.logging.log4j.LogBuilder
        "org.apache.logging.log4j;LogBuilder;true;log;(CharSequence);;Argument[0];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(Message);;Argument[0];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(Object);;Argument[0];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String);;Argument[0];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object[]);;Argument[0..1];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object);;Argument[0..1];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object);;Argument[0..2];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object);;Argument[0..3];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object);;Argument[0..4];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object);;Argument[0..5];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object);;Argument[0..6];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object);;Argument[0..7];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..8];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..9];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..10];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Supplier[]);;Argument[0..1];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(Supplier);;Argument[0];logging"
      ]
  }
}

/** A data flow sink for unvalidated user input that is used to log messages. */
class Log4jInjectionSink extends DataFlow::Node {
  Log4jInjectionSink() { sinkNode(this, "logging") }
}

/**
 * A node that sanitizes a message before logging to avoid log injection.
 */
class Log4jInjectionSanitizer extends DataFlow::Node {
  Log4jInjectionSanitizer() {
    this.getType() instanceof BoxedType or this.getType() instanceof PrimitiveType
  }
}

/**
 * A taint-tracking configuration for tracking untrusted user input used in log entries.
 */
class Log4jInjectionConfiguration extends TaintTracking::Configuration {
  Log4jInjectionConfiguration() { this = "Log4jInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Log4jInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof Log4jInjectionSanitizer }
}

from Log4jInjectionConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This $@ flows to a Log4j log entry.", source.getNode(),
  "user-provided value"
