/** Provides classes and predicates to reason about logging. */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class LoggingSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.logging.log4j;Logger;true;traceEntry;(Message);;Argument[0];ReturnValue;taint;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Object[]);;Argument[0..1];ReturnValue;taint;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Supplier[]);;Argument[0..1];ReturnValue;taint;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(Supplier[]);;Argument[0];ReturnValue;taint;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(EntryMessage,Object);;Argument[1];ReturnValue;value;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(Message,Object);;Argument[1];ReturnValue;value;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(Object);;Argument[0];ReturnValue;value;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(String,Object);;Argument[1];ReturnValue;value;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;addArgument;;;Argument[1];Argument[-1];taint;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;addArgument;;;Argument[-1];ReturnValue;value;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;addKeyValue;;;Argument[1];Argument[-1];taint;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;addKeyValue;;;Argument[-1];ReturnValue;value;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;addMarker;;;Argument[-1];ReturnValue;value;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;setCause;;;Argument[-1];ReturnValue;value;manual",
        "java.util.logging;LogRecord;false;LogRecord;;;Argument[1];Argument[-1];taint;manual"
      ]
  }
}

private string jBossLogger() { result = "org.jboss.logging;" + ["BasicLogger", "Logger"] }

private class LoggingSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // org.apache.log4j.Category
        "org.apache.log4j;Category;true;assertLog;;;Argument[1];logging;manual",
        "org.apache.log4j;Category;true;debug;;;Argument[0];logging;manual",
        "org.apache.log4j;Category;true;error;;;Argument[0];logging;manual",
        "org.apache.log4j;Category;true;fatal;;;Argument[0];logging;manual",
        "org.apache.log4j;Category;true;forcedLog;;;Argument[2];logging;manual",
        "org.apache.log4j;Category;true;info;;;Argument[0];logging;manual",
        "org.apache.log4j;Category;true;l7dlog;(Priority,String,Object[],Throwable);;Argument[2];logging;manual",
        "org.apache.log4j;Category;true;log;(Priority,Object);;Argument[1];logging;manual",
        "org.apache.log4j;Category;true;log;(Priority,Object,Throwable);;Argument[1];logging;manual",
        "org.apache.log4j;Category;true;log;(String,Priority,Object,Throwable);;Argument[2];logging;manual",
        "org.apache.log4j;Category;true;warn;;;Argument[0];logging;manual",
        // org.apache.logging.log4j.Logger
        "org.apache.logging.log4j;Logger;true;" +
          ["debug", "error", "fatal", "info", "trace", "warn"] +
          [
            ";(CharSequence);;Argument[0];logging;manual",
            ";(CharSequence,Throwable);;Argument[0];logging;manual",
            ";(Marker,CharSequence);;Argument[1];logging;manual",
            ";(Marker,CharSequence,Throwable);;Argument[1];logging;manual",
            ";(Marker,Message);;Argument[1];logging;manual",
            ";(Marker,MessageSupplier);;Argument[1];logging;manual",
            ";(Marker,MessageSupplier);;Argument[1];logging;manual",
            ";(Marker,MessageSupplier,Throwable);;Argument[1];logging;manual",
            ";(Marker,Object);;Argument[1];logging;manual",
            ";(Marker,Object,Throwable);;Argument[1];logging;manual",
            ";(Marker,String);;Argument[1];logging;manual",
            ";(Marker,String,Object[]);;Argument[1..2];logging;manual",
            ";(Marker,String,Object);;Argument[1..2];logging;manual",
            ";(Marker,String,Object,Object);;Argument[1..3];logging;manual",
            ";(Marker,String,Object,Object,Object);;Argument[1..4];logging;manual",
            ";(Marker,String,Object,Object,Object,Object);;Argument[1..5];logging;manual",
            ";(Marker,String,Object,Object,Object,Object,Object);;Argument[1..6];logging;manual",
            ";(Marker,String,Object,Object,Object,Object,Object,Object);;Argument[1..7];logging;manual",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];logging;manual",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];logging;manual",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];logging;manual",
            ";(Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..11];logging;manual",
            ";(Marker,String,Supplier);;Argument[1..2];logging;manual",
            ";(Marker,String,Throwable);;Argument[1];logging;manual",
            ";(Marker,Supplier);;Argument[1];logging;manual",
            ";(Marker,Supplier,Throwable);;Argument[1];logging;manual",
            ";(MessageSupplier);;Argument[0];logging;manual",
            ";(MessageSupplier,Throwable);;Argument[0];logging;manual",
            ";(Message);;Argument[0];logging;manual",
            ";(Message,Throwable);;Argument[0];logging;manual",
            ";(Object);;Argument[0];logging;manual",
            ";(Object,Throwable);;Argument[0];logging;manual",
            ";(String);;Argument[0];logging;manual",
            ";(String,Object[]);;Argument[0..1];logging;manual",
            ";(String,Object);;Argument[0..1];logging;manual",
            ";(String,Object,Object);;Argument[0..2];logging;manual",
            ";(String,Object,Object,Object);;Argument[0..3];logging;manual",
            ";(String,Object,Object,Object,Object);;Argument[0..4];logging;manual",
            ";(String,Object,Object,Object,Object,Object);;Argument[0..5];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object);;Argument[0..6];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object);;Argument[0..7];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..8];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..9];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..10];logging;manual",
            ";(String,Supplier);;Argument[0..1];logging;manual",
            ";(String,Throwable);;Argument[0];logging;manual",
            ";(Supplier);;Argument[0];logging;manual",
            ";(Supplier,Throwable);;Argument[0];logging;manual"
          ],
        "org.apache.logging.log4j;Logger;true;log" +
          [
            ";(Level,CharSequence);;Argument[1];logging;manual",
            ";(Level,CharSequence,Throwable);;Argument[1];logging;manual",
            ";(Level,Marker,CharSequence);;Argument[2];logging;manual",
            ";(Level,Marker,CharSequence,Throwable);;Argument[2];logging;manual",
            ";(Level,Marker,Message);;Argument[2];logging;manual",
            ";(Level,Marker,MessageSupplier);;Argument[2];logging;manual",
            ";(Level,Marker,MessageSupplier);;Argument[2];logging;manual",
            ";(Level,Marker,MessageSupplier,Throwable);;Argument[2];logging;manual",
            ";(Level,Marker,Object);;Argument[2];logging;manual",
            ";(Level,Marker,Object,Throwable);;Argument[2];logging;manual",
            ";(Level,Marker,String);;Argument[2];logging;manual",
            ";(Level,Marker,String,Object[]);;Argument[2..3];logging;manual",
            ";(Level,Marker,String,Object);;Argument[2..3];logging;manual",
            ";(Level,Marker,String,Object,Object);;Argument[2..4];logging;manual",
            ";(Level,Marker,String,Object,Object,Object);;Argument[2..5];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object);;Argument[2..6];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object,Object);;Argument[2..7];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object);;Argument[2..8];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object);;Argument[2..9];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..10];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..11];logging;manual",
            ";(Level,Marker,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[2..12];logging;manual",
            ";(Level,Marker,String,Supplier);;Argument[2..3];logging;manual",
            ";(Level,Marker,String,Throwable);;Argument[2];logging;manual",
            ";(Level,Marker,Supplier);;Argument[2];logging;manual",
            ";(Level,Marker,Supplier,Throwable);;Argument[2];logging;manual",
            ";(Level,Message);;Argument[1];logging;manual",
            ";(Level,MessageSupplier);;Argument[1];logging;manual",
            ";(Level,MessageSupplier,Throwable);;Argument[1];logging;manual",
            ";(Level,Message);;Argument[1];logging;manual",
            ";(Level,Message,Throwable);;Argument[1];logging;manual",
            ";(Level,Object);;Argument[1];logging;manual",
            ";(Level,Object);;Argument[1];logging;manual",
            ";(Level,String);;Argument[1];logging;manual",
            ";(Level,Object,Throwable);;Argument[1];logging;manual",
            ";(Level,String);;Argument[1];logging;manual",
            ";(Level,String,Object[]);;Argument[1..2];logging;manual",
            ";(Level,String,Object);;Argument[1..2];logging;manual",
            ";(Level,String,Object,Object);;Argument[1..3];logging;manual",
            ";(Level,String,Object,Object,Object);;Argument[1..4];logging;manual",
            ";(Level,String,Object,Object,Object,Object);;Argument[1..5];logging;manual",
            ";(Level,String,Object,Object,Object,Object,Object);;Argument[1..6];logging;manual",
            ";(Level,String,Object,Object,Object,Object,Object,Object);;Argument[1..7];logging;manual",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];logging;manual",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];logging;manual",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];logging;manual",
            ";(Level,String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..11];logging;manual",
            ";(Level,String,Supplier);;Argument[1..2];logging;manual",
            ";(Level,String,Throwable);;Argument[1];logging;manual",
            ";(Level,Supplier);;Argument[1];logging;manual",
            ";(Level,Supplier,Throwable);;Argument[1];logging;manual"
          ], "org.apache.logging.log4j;Logger;true;entry;(Object[]);;Argument[0];logging;manual",
        "org.apache.logging.log4j;Logger;true;logMessage;(Level,Marker,String,StackTraceElement,Message,Throwable);;Argument[4];logging;manual",
        "org.apache.logging.log4j;Logger;true;printf;(Level,Marker,String,Object[]);;Argument[2..3];logging;manual",
        "org.apache.logging.log4j;Logger;true;printf;(Level,String,Object[]);;Argument[1..2];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(Message);;Argument[0];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Object[]);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Supplier[]);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceEntry;(Supplier[]);;Argument[0];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(EntryMessage);;Argument[0];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(EntryMessage,Object);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(Message,Object);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(Object);;Argument[0];logging;manual",
        "org.apache.logging.log4j;Logger;true;traceExit;(String,Object);;Argument[0..1];logging;manual",
        // org.apache.logging.log4j.LogBuilder
        "org.apache.logging.log4j;LogBuilder;true;log;(CharSequence);;Argument[0];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(Message);;Argument[0];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(Object);;Argument[0];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String);;Argument[0];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object[]);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object);;Argument[0..2];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object);;Argument[0..3];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object);;Argument[0..4];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object);;Argument[0..5];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object);;Argument[0..6];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object);;Argument[0..7];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..8];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..9];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[0..10];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Supplier);;Argument[0..1];logging;manual",
        "org.apache.logging.log4j;LogBuilder;true;log;(Supplier);;Argument[0];logging;manual",
        // org.apache.commons.logging.Log
        "org.apache.commons.logging;Log;true;" +
          ["debug", "error", "fatal", "info", "trace", "warn"] + ";;;Argument[0];logging;manual",
        // org.jboss.logging.BasicLogger and org.jboss.logging.Logger
        // (org.jboss.logging.Logger does not implement BasicLogger in some implementations like JBoss Application Server 4.0.4)
        jBossLogger() + ";true;" + ["debug", "error", "fatal", "info", "trace", "warn"] +
          [
            ";(Object);;Argument[0];logging;manual",
            ";(Object,Throwable);;Argument[0];logging;manual",
            ";(Object,Object[]);;Argument[0..1];logging;manual",
            ";(Object,Object[],Throwable);;Argument[0..1];logging;manual",
            ";(String,Object,Object[],Throwable);;Argument[1..2];logging;manual",
            ";(String,Object,Throwable);;Argument[1];logging;manual"
          ],
        jBossLogger() + ";true;log" +
          [
            ";(Level,Object);;Argument[1];logging;manual",
            ";(Level,Object,Object[]);;Argument[1..2];logging;manual",
            ";(Level,Object,Object[],Throwable);;Argument[1..2];logging;manual",
            ";(Level,Object,Throwable);;Argument[1];logging;manual",
            ";(Level,String,Object,Throwable);;Argument[2];logging;manual",
            ";(String,Level,Object,Object[],Throwable);;Argument[2..3];logging;manual"
          ],
        jBossLogger() + ";true;" + ["debug", "error", "fatal", "info", "trace", "warn"] + ["f", "v"]
          +
          [
            ";(String,Object[]);;Argument[0..1];logging;manual",
            ";(String,Object);;Argument[0..1];logging;manual",
            ";(String,Object,Object);;Argument[0..2];logging;manual",
            ";(String,Object,Object,Object);;Argument[0..3];logging;manual",
            ";(String,Object,Object,Object,Object);;Argument[0..4];logging;manual",
            ";(Throwable,String,Object);;Argument[1..2];logging;manual",
            ";(Throwable,String,Object,Object);;Argument[1..3];logging;manual",
            ";(Throwable,String,Object,Object,Object);;Argument[0..4];logging;manual"
          ],
        jBossLogger() + ";true;log" + ["f", "v"] +
          [
            ";(Level,String,Object[]);;Argument[1..2];logging;manual",
            ";(Level,String,Object);;Argument[1..2];logging;manual",
            ";(Level,String,Object,Object);;Argument[1..3];logging;manual",
            ";(Level,String,Object,Object,Object);;Argument[1..4];logging;manual",
            ";(Level,String,Object,Object,Object,Object);;Argument[1..5];logging;manual",
            ";(Level,Throwable,String,Object);;Argument[2..3];logging;manual",
            ";(Level,Throwable,String,Object,Object);;Argument[2..4];logging;manual",
            ";(Level,Throwable,String,Object,Object,Object);;Argument[1..5];logging;manual",
            ";(String,Level,Throwable,String,Object[]);;Argument[3..4];logging;manual",
            ";(String,Level,Throwable,String,Object);;Argument[3..4];logging;manual",
            ";(String,Level,Throwable,String,Object,Object);;Argument[3..5];logging;manual",
            ";(String,Level,Throwable,String,Object,Object,Object);;Argument[3..6];logging;manual"
          ],
        // org.slf4j.spi.LoggingEventBuilder
        "org.slf4j.spi;LoggingEventBuilder;true;log;;;Argument[0];logging;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(String,Object);;Argument[0..1];logging;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(String,Object[]);;Argument[0..1];logging;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(String,Object,Object);;Argument[0..2];logging;manual",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(Supplier);;Argument[0];logging;manual",
        // org.slf4j.Logger
        "org.slf4j;Logger;true;" + ["debug", "error", "info", "trace", "warn"] +
          [
            ";(String);;Argument[0];logging;manual",
            ";(String,Object);;Argument[0..1];logging;manual",
            ";(String,Object[]);;Argument[0..1];logging;manual",
            ";(String,Object,Object);;Argument[0..2];logging;manual",
            ";(String,Throwable);;Argument[0];logging;manual",
            ";(Marker,String);;Argument[1];logging;manual",
            ";(Marker,String,Object);;Argument[1..2];logging;manual",
            ";(Marker,String,Object[]);;Argument[1..2];logging;manual",
            ";(Marker,String,Object,Object);;Argument[1..3];logging;manual",
            ";(Marker,String,Object,Object,Object);;Argument[1..4];logging;manual"
          ],
        // org.scijava.Logger
        "org.scijava.log;Logger;true;alwaysLog;(int,Object,Throwable);;Argument[1];logging;manual",
        "org.scijava.log;Logger;true;" + ["debug", "error", "info", "trace", "warn"] +
          [
            ";(Object);;Argument[0];logging;manual",
            ";(Object,Throwable);;Argument[0];logging;manual"
          ], "org.scijava.log;Logger;true;log;(int,Object);;Argument[1];logging;manual",
        "org.scijava.log;Logger;true;log;(int,Object,Throwable);;Argument[1];logging;manual",
        // com.google.common.flogger.LoggingApi
        "com.google.common.flogger;LoggingApi;true;logVarargs;;;Argument[0..1];logging;manual",
        "com.google.common.flogger;LoggingApi;true;log" +
          [
            ";;;Argument[0];logging;manual", ";(String,Object);;Argument[1];logging;manual",
            ";(String,Object,Object);;Argument[1..2];logging;manual",
            ";(String,Object,Object,Object);;Argument[1..3];logging;manual",
            ";(String,Object,Object,Object,Object);;Argument[1..4];logging;manual",
            ";(String,Object,Object,Object,Object,Object);;Argument[1..5];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object);;Argument[1..6];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..7];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];logging;manual",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object[]);;Argument[1..11];logging;manual",
            ";(String,Object,boolean);;Argument[1];logging;manual",
            ";(String,Object,char);;Argument[1];logging;manual",
            ";(String,Object,byte);;Argument[1];logging;manual",
            ";(String,Object,short);;Argument[1];logging;manual",
            ";(String,Object,int);;Argument[1];logging;manual",
            ";(String,Object,long);;Argument[1];logging;manual",
            ";(String,Object,float);;Argument[1];logging;manual",
            ";(String,Object,double);;Argument[1];logging;manual",
            ";(String,boolean,Object);;Argument[2];logging;manual",
            ";(String,char,Object);;Argument[2];logging;manual",
            ";(String,byte,Object);;Argument[2];logging;manual",
            ";(String,short,Object);;Argument[2];logging;manual",
            ";(String,int,Object);;Argument[2];logging;manual",
            ";(String,long,Object);;Argument[2];logging;manual",
            ";(String,float,Object);;Argument[2];logging;manual",
            ";(String,double,Object);;Argument[2];logging;manual"
          ],
        // java.lang.System$Logger
        "java.lang;System$Logger;true;log;" +
          [
            "(Level,Object);;Argument[1]", "(Level,String);;Argument[1]",
            "(Level,String,Object[]);;Argument[1..2]", "(Level,String,Throwable);;Argument[1]",
            "(Level,String,Supplier);;Argument[1..2]",
            "(Level,String,Supplier,Throwable);;Argument[1..2]",
            "(Level,ResourceBundle,String,Object[]);;Argument[2..3]",
            "(Level,ResourceBundle,String,Throwable);;Argument[2]"
          ] + ";logging;manual",
        // java.util.logging.Logger
        "java.util.logging;Logger;true;" +
          ["config", "fine", "finer", "finest", "info", "severe", "warning"] +
          ";;;Argument[0];logging;manual",
        "java.util.logging;Logger;true;entering;(String,String);;Argument[0..1];logging;manual",
        "java.util.logging;Logger;true;entering;(String,String,Object);;Argument[0..2];logging;manual",
        "java.util.logging;Logger;true;entering;(String,String,Object[]);;Argument[0..2];logging;manual",
        "java.util.logging;Logger;true;exiting;(String,String);;Argument[0..1];logging;manual",
        "java.util.logging;Logger;true;exiting;(String,String,Object);;Argument[0..2];logging;manual",
        "java.util.logging;Logger;true;log;(Level,String);;Argument[1];logging;manual",
        "java.util.logging;Logger;true;log;(Level,String,Object);;Argument[1..2];logging;manual",
        "java.util.logging;Logger;true;log;(Level,String,Object[]);;Argument[1..2];logging;manual",
        "java.util.logging;Logger;true;log;(Level,String,Throwable);;Argument[1];logging;manual",
        "java.util.logging;Logger;true;log;(Level,Supplier);;Argument[1];logging;manual",
        "java.util.logging;Logger;true;log;(Level,Throwable,Supplier);;Argument[2];logging;manual",
        "java.util.logging;Logger;true;log;(LogRecord);;Argument[0];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,String);;Argument[1..3];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,String,Object);;Argument[1..4];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,String,Object[]);;Argument[1..4];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,String,Throwable);;Argument[1..3];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,Supplier);;Argument[1..3];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,Throwable,Supplier);;Argument[1..2];logging;manual",
        "java.util.logging;Logger;true;logp;(Level,String,String,Throwable,Supplier);;Argument[4];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Object[]);;Argument[1..2];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Object[]);;Argument[4..5];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Throwable);;Argument[1..2];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Throwable);;Argument[4];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String);;Argument[1..4];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String,Object);;Argument[1..5];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String,Object[]);;Argument[1..5];logging;manual",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String,Throwable);;Argument[1..4];logging;manual",
        // android.util.Log
        "android.util;Log;true;" + ["d", "v", "i", "w", "e", "wtf"] +
          ";;;Argument[1];logging;manual"
      ]
  }
}
