/**
 * @name Potential Log4J LDAP JNDI injection (CVE-2021-44228)
 * @description Building Log4j log entries from user-controlled data may allow
 *              attackers to inject malicious code through JNDI lookups when
 *              using Log4J versions vulnerable to CVE-2021-44228.
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

private class Log4jLoggingSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // org.apache.logging.log4j.Logger
        "org.apache.logging.log4j;Logger;true;" +
          ["debug", "error", "fatal", "info", "trace", "warn"] +
          [
            ";(CharSequence);;Argument[0];log4j", ";(CharSequence,Throwable);;Argument[0];log4j",
            ";(Marker,CharSequence);;Argument[1];log4j",
            ";(Marker,CharSequence,Throwable);;Argument[1];log4j",
            ";(Marker,Message);;Argument[1];log4j", ";(Marker,MessageSupplier);;Argument[1];log4j",
            ";(Marker,MessageSupplier);;Argument[1];log4j",
            ";(Marker,MessageSupplier,Throwable);;Argument[1];log4j",
            ";(Marker,Object);;Argument[1];log4j", ";(Marker,Object,Throwable);;Argument[1];log4j",
            ";(Marker,String);;Argument[1];log4j",
            ";(Marker,String,Object[]);;Argument[1..2];log4j",
            ";(Marker,String,Object);;Argument[1..2];log4j",
            ";(Marker,String,Object,Object);;Argument[1..3];log4j",
            ";(Marker,String,Object,Object,Object);;Argument[1..4];log4j",
            ";(Marker,String,Object,Object,Object,Object);;Argument[1..5];log4j",
            ";(Marker,String,Object,Object,Object,Object,Object);;Argument[1..6];log4j",
            ";(Marker,String,Object,Object,Object,Object,Object,Object);;Argument[1..7];log4j",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];log4j",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];log4j",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];log4j",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..11];log4j",
            ";(Marker,String,Supplier);;Argument[1..2];log4j",
            ";(Marker,String,Throwable);;Argument[1];log4j",
            ";(Marker,Supplier);;Argument[1];log4j",
            ";(Marker,Supplier,Throwable);;Argument[1];log4j",
            ";(MessageSupplier);;Argument[0];log4j",
            ";(MessageSupplier,Throwable);;Argument[0];log4j", ";(Message);;Argument[0];log4j",
            ";(Message,Throwable);;Argument[0];log4j", ";(Object);;Argument[0];log4j",
            ";(Object,Throwable);;Argument[0];log4j", ";(String);;Argument[0];log4j",
            ";(String,Object[]);;Argument[0..1];log4j", ";(String,Object);;Argument[0..1];log4j",
            ";(String,Object,Object);;Argument[0..2];log4j",
            ";(String,Object,Object,Object);;Argument[0..3];log4j",
            ";(String,Object,Object,Object,Object);;Argument[0..4];log4j",
            ";(String,Object,Object,Object,Object,Object);;Argument[0..5];log4j",
            ";(String,Object,Object,Object,Object,Object,Object);;Argument[0..6];log4j",
            ";(String,Object,Object,Object,Object,Object,Object,Object);;Argument[0..7];log4j",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..8];log4j",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..9];log4j",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..10];log4j",
            ";(String,Supplier);;Argument[0..1];log4j", ";(String,Throwable);;Argument[0];log4j",
            ";(Supplier);;Argument[0];log4j", ";(Supplier,Throwable);;Argument[0];log4j"
          ],
        "org.apache.logging.log4j;Logger;true;log" +
          [
            ";(Level,CharSequence);;Argument[1];log4j",
            ";(Level,CharSequence,Throwable);;Argument[1];log4j",
            ";(Level,Marker,CharSequence);;Argument[2];log4j",
            ";(Level,Marker,CharSequence,Throwable);;Argument[2];log4j",
            ";(Level,Marker,Message);;Argument[2];log4j",
            ";(Level,Marker,MessageSupplier);;Argument[2];log4j",
            ";(Level,Marker,MessageSupplier);;Argument[2];log4j",
            ";(Level,Marker,MessageSupplier,Throwable);;Argument[2];log4j",
            ";(Level,Marker,Object);;Argument[2];log4j",
            ";(Level,Marker,Object,Throwable);;Argument[2];log4j",
            ";(Level,Marker,String);;Argument[2];log4j",
            ";(Level,Marker,String,Object[]);;Argument[2..3];log4j",
            ";(Level,Marker,String,Object);;Argument[2..3];log4j",
            ";(Level,Marker,String,Object,Object);;Argument[2..4];log4j",
            ";(Level,Marker,String,Object,Object,Object);;Argument[2..5];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object);;Argument[2..6];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object,Object);;Argument[2..7];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object);;Argument[2..8];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object);;Argument[2..9];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..10];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..11];log4j",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..12];log4j",
            ";(Level,Marker,String,Supplier);;Argument[2..3];log4j",
            ";(Level,Marker,String,Throwable);;Argument[2];log4j",
            ";(Level,Marker,Supplier);;Argument[2];log4j",
            ";(Level,Marker,Supplier,Throwable);;Argument[2];log4j",
            ";(Level,Message);;Argument[1];log4j", ";(Level,MessageSupplier);;Argument[1];log4j",
            ";(Level,MessageSupplier,Throwable);;Argument[1];log4j",
            ";(Level,Message);;Argument[1];log4j", ";(Level,Message,Throwable);;Argument[1];log4j",
            ";(Level,Object);;Argument[1];log4j", ";(Level,Object);;Argument[1];log4j",
            ";(Level,String);;Argument[1];log4j", ";(Level,Object,Throwable);;Argument[1];log4j",
            ";(Level,String);;Argument[1];log4j", ";(Level,String,Object[]);;Argument[1..2];log4j",
            ";(Level,String,Object);;Argument[1..2];log4j",
            ";(Level,String,Object,Object);;Argument[1..3];log4j",
            ";(Level,String,Object,Object,Object);;Argument[1..4];log4j",
            ";(Level,String,Object,Object,Object,Object);;Argument[1..5];log4j",
            ";(Level,String,Object,Object,Object,Object,Object);;Argument[1..6];log4j",
            ";(Level,String,Object,Object,Object,Object,Object,Object);;Argument[1..7];log4j",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];log4j",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];log4j",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];log4j",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..11];log4j",
            ";(Level,String,Supplier);;Argument[1..2];log4j",
            ";(Level,String,Throwable);;Argument[1];log4j", ";(Level,Supplier);;Argument[1];log4j",
            ";(Level,Supplier,Throwable);;Argument[1];log4j"
          ], "org.apache.logging.log4j;Logger;true;entry;(Object[]);;Argument[0];log4j",
        "org.apache.logging.log4j;Logger;true;logMessage;(Level,Marker,String,StackTraceElement,Message,Throwable);;Argument[4];log4j",
        "org.apache.logging.log4j;Logger;true;printf;(Level,Marker,String,Object[]);;Argument[2..3];log4j",
        "org.apache.logging.log4j;Logger;true;printf;(Level,String,Object[]);;Argument[1..2];log4j",
        // org.apache.logging.log4j.LogBuilder
        "org.apache.logging.log4j;LogBuilder;true;log;(CharSequence);;Argument[0];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(Message);;Argument[0];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(Object);;Argument[0];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String);;Argument[0];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object[]);;Argument[0..1];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object);;Argument[0..1];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object);;Argument[0..2];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object);;Argument[0..3];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object);;Argument[0..4];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object);;Argument[0..5];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object);;Argument[0..6];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object);;Argument[0..7];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..8];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..9];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..10];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Supplier[]);;Argument[0..1];log4j",
        "org.apache.logging.log4j;LogBuilder;true;log;(Supplier);;Argument[0];log4j",
        // org.apache.logging.log4j.ThreadContext
        "org.apache.logging.log4j;ThreadContext;false;put;;;Argument[1];log4j",
        "org.apache.logging.log4j;ThreadContext;false;putIfNull;;;Argument[1];log4j",
        "org.apache.logging.log4j;ThreadContext;false;putAll;;;Argument[0];log4j",
        // org.apache.logging.log4j.CloseableThreadContext
        "org.apache.logging.log4j;CloseableThreadContext;false;put;;;Argument[1];log4j",
        "org.apache.logging.log4j;CloseableThreadContext;false;putAll;;;Argument[0];log4j",
        "org.apache.logging.log4j;CloseableThreadContext$Instance;false;put;;;Argument[1];log4j",
        "org.apache.logging.log4j;CloseableThreadContext$Instance;false;putAll;;;Argument[0];log4j",
      ]
  }
}

class Log4jInjectionSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.logging.log4j.message;MapMessage;true;with;;;Argument[1];Argument[-1];taint",
        "org.apache.logging.log4j.message;MapMessage;true;with;;;Argument[-1];ReturnValue;value",
        "org.apache.logging.log4j.message;MapMessage;true;put;;;Argument[1];Argument[-1];taint",
        "org.apache.logging.log4j.message;MapMessage;true;putAll;;;Argument[0].MapValue;Argument[-1];taint",
      ]
  }
}

/** A data flow sink for unvalidated user input that is used to log messages. */
class Log4jInjectionSink extends DataFlow::Node {
  Log4jInjectionSink() { sinkNode(this, "log4j") }
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
