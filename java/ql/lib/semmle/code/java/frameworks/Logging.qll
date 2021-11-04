/** Provides classes and predicates to reason about logging. */

import java
import semmle.code.java.dataflow.ExternalFlow

private class LoggingSummaryModels extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.logging.log4j;Logger;true;traceEntry;(Message);;Argument[0];ReturnValue;taint",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Object[]);;Argument[0..1];ReturnValue;taint",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Supplier[]);;Argument[0..1];ReturnValue;taint",
        "org.apache.logging.log4j;Logger;true;traceEntry;(Supplier[]);;Argument[0];ReturnValue;taint",
        "org.apache.logging.log4j;Logger;true;traceExit;(EntryMessage,Object);;Argument[1];ReturnValue;value",
        "org.apache.logging.log4j;Logger;true;traceExit;(Message,Object);;Argument[1];ReturnValue;value",
        "org.apache.logging.log4j;Logger;true;traceExit;(Object);;Argument[0];ReturnValue;value",
        "org.apache.logging.log4j;Logger;true;traceExit;(String,Object);;Argument[1];ReturnValue;value",
        "org.slf4j.spi;LoggingEventBuilder;true;addArgument;;;Argument[1];Argument[-1];taint",
        "org.slf4j.spi;LoggingEventBuilder;true;addArgument;;;Argument[-1];ReturnValue;value",
        "org.slf4j.spi;LoggingEventBuilder;true;addKeyValue;;;Argument[1];Argument[-1];taint",
        "org.slf4j.spi;LoggingEventBuilder;true;addKeyValue;;;Argument[-1];ReturnValue;value",
        "org.slf4j.spi;LoggingEventBuilder;true;addMarker;;;Argument[-1];ReturnValue;value",
        "org.slf4j.spi;LoggingEventBuilder;true;setCause;;;Argument[-1];ReturnValue;value",
        "java.util.logging;LogRecord;false;LogRecord;;;Argument[1];Argument[-1];taint"
      ]
  }
}

private string jBossLogger() { result = "org.jboss.logging;" + ["BasicLogger", "Logger"] }

private class LoggingSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // org.apache.log4j.Category
        "org.apache.log4j;Category;true;assertLog;;;Argument[1];logging",
        "org.apache.log4j;Category;true;debug;;;Argument[0];logging",
        "org.apache.log4j;Category;true;error;;;Argument[0];logging",
        "org.apache.log4j;Category;true;fatal;;;Argument[0];logging",
        "org.apache.log4j;Category;true;forcedLog;;;Argument[2];logging",
        "org.apache.log4j;Category;true;info;;;Argument[0];logging",
        "org.apache.log4j;Category;true;l7dlog;(Priority,String,Object[],Throwable);;Argument[2];logging",
        "org.apache.log4j;Category;true;log;(Priority,Object);;Argument[1];logging",
        "org.apache.log4j;Category;true;log;(Priority,Object,Throwable);;Argument[1];logging",
        "org.apache.log4j;Category;true;log;(String,Priority,Object,Throwable);;Argument[2];logging",
        "org.apache.log4j;Category;true;warn;;;Argument[0];logging",
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
        "org.apache.logging.log4j;Logger;true;traceEntry;(Message);;Argument[0];logging",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Object[]);;Argument[0..1];logging",
        "org.apache.logging.log4j;Logger;true;traceEntry;(String,Supplier[]);;Argument[0..1];logging",
        "org.apache.logging.log4j;Logger;true;traceEntry;(Supplier[]);;Argument[0];logging",
        "org.apache.logging.log4j;Logger;true;traceExit;(EntryMessage);;Argument[0];logging",
        "org.apache.logging.log4j;Logger;true;traceExit;(EntryMessage,Object);;Argument[0..1];logging",
        "org.apache.logging.log4j;Logger;true;traceExit;(Message,Object);;Argument[0..1];logging",
        "org.apache.logging.log4j;Logger;true;traceExit;(Object);;Argument[0];logging",
        "org.apache.logging.log4j;Logger;true;traceExit;(String,Object);;Argument[0..1];logging",
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
        "org.apache.logging.log4j;LogBuilder;true;log;(String,Supplier);;Argument[0..1];logging",
        "org.apache.logging.log4j;LogBuilder;true;log;(Supplier);;Argument[0];logging",
        // org.apache.commons.logging.Log
        "org.apache.commons.logging;Log;true;" +
          ["debug", "error", "fatal", "info", "trace", "warn"] + ";;;Argument[0];logging",
        // org.jboss.logging.BasicLogger and org.jboss.logging.Logger
        // (org.jboss.logging.Logger does not implement BasicLogger in some implementations like JBoss Application Server 4.0.4)
        jBossLogger() + ";true;" + ["debug", "error", "fatal", "info", "trace", "warn"] +
          [
            ";(Object);;Argument[0];logging", ";(Object,Throwable);;Argument[0];logging",
            ";(Object,Object[]);;Argument[0..1];logging",
            ";(Object,Object[],Throwable);;Argument[0..1];logging",
            ";(String,Object,Object[],Throwable);;Argument[1..2];logging",
            ";(String,Object,Throwable);;Argument[1];logging"
          ],
        jBossLogger() + ";true;log" +
          [
            ";(Level,Object);;Argument[1];logging",
            ";(Level,Object,Object[]);;Argument[1..2];logging",
            ";(Level,Object,Object[],Throwable);;Argument[1..2];logging",
            ";(Level,Object,Throwable);;Argument[1];logging",
            ";(Level,String,Object,Throwable);;Argument[2];logging",
            ";(String,Level,Object,Object[],Throwable);;Argument[2..3];logging"
          ],
        jBossLogger() + ";true;" + ["debug", "error", "fatal", "info", "trace", "warn"] + ["f", "v"]
          +
          [
            ";(String,Object[]);;Argument[0..1];logging",
            ";(String,Object);;Argument[0..1];logging",
            ";(String,Object,Object);;Argument[0..2];logging",
            ";(String,Object,Object,Object);;Argument[0..3];logging",
            ";(String,Object,Object,Object,Object);;Argument[0..4];logging",
            ";(Throwable,String,Object);;Argument[1..2];logging",
            ";(Throwable,String,Object,Object);;Argument[1..3];logging",
            ";(Throwable,String,Object,Object,Object);;Argument[0..4];logging"
          ],
        jBossLogger() + ";true;log" + ["f", "v"] +
          [
            ";(Level,String,Object[]);;Argument[1..2];logging",
            ";(Level,String,Object);;Argument[1..2];logging",
            ";(Level,String,Object,Object);;Argument[1..3];logging",
            ";(Level,String,Object,Object,Object);;Argument[1..4];logging",
            ";(Level,String,Object,Object,Object,Object);;Argument[1..5];logging",
            ";(Level,Throwable,String,Object);;Argument[2..3];logging",
            ";(Level,Throwable,String,Object,Object);;Argument[2..4];logging",
            ";(Level,Throwable,String,Object,Object,Object);;Argument[1..5];logging",
            ";(String,Level,Throwable,String,Object[]);;Argument[3..4];logging",
            ";(String,Level,Throwable,String,Object);;Argument[3..4];logging",
            ";(String,Level,Throwable,String,Object,Object);;Argument[3..5];logging",
            ";(String,Level,Throwable,String,Object,Object,Object);;Argument[3..6];logging"
          ],
        // org.slf4j.spi.LoggingEventBuilder
        "org.slf4j.spi;LoggingEventBuilder;true;log;;;Argument[0];logging",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(String,Object);;Argument[0..1];logging",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(String,Object[]);;Argument[0..1];logging",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(String,Object,Object);;Argument[0..2];logging",
        "org.slf4j.spi;LoggingEventBuilder;true;log;(Supplier);;Argument[0];logging",
        // org.slf4j.Logger
        "org.slf4j;Logger;true;" + ["debug", "error", "info", "trace", "warn"] +
          [
            ";(String);;Argument[0];logging", ";(String,Object);;Argument[0..1];logging",
            ";(String,Object[]);;Argument[0..1];logging",
            ";(String,Object,Object);;Argument[0..2];logging",
            ";(String,Throwable);;Argument[0];logging", ";(Marker,String);;Argument[1];logging",
            ";(Marker,String,Object);;Argument[1..2];logging",
            ";(Marker,String,Object[]);;Argument[1..2];logging",
            ";(Marker,String,Object,Object);;Argument[1..3];logging",
            ";(Marker,String,Object,Object,Object);;Argument[1..4];logging"
          ],
        // org.scijava.Logger
        "org.scijava.log;Logger;true;alwaysLog;(int,Object,Throwable);;Argument[1];logging",
        "org.scijava.log;Logger;true;" + ["debug", "error", "info", "trace", "warn"] +
          [";(Object);;Argument[0];logging", ";(Object,Throwable);;Argument[0];logging"],
        "org.scijava.log;Logger;true;log;(int,Object);;Argument[1];logging",
        "org.scijava.log;Logger;true;log;(int,Object,Throwable);;Argument[1];logging",
        // com.google.common.flogger.LoggingApi
        "com.google.common.flogger;LoggingApi;true;logVarargs;;;Argument[0..1];logging",
        "com.google.common.flogger;LoggingApi;true;log" +
          [
            ";;;Argument[0];logging", ";(String,Object);;Argument[1];logging",
            ";(String,Object,Object);;Argument[1..2];logging",
            ";(String,Object,Object,Object);;Argument[1..3];logging",
            ";(String,Object,Object,Object,Object);;Argument[1..4];logging",
            ";(String,Object,Object,Object,Object,Object);;Argument[1..5];logging",
            ";(String,Object,Object,Object,Object,Object,Object);;Argument[1..6];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object);;Argument[1..7];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..8];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..9];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object);;Argument[1..10];logging",
            ";(String,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object,Object[]);;Argument[1..11];logging",
            ";(String,Object,boolean);;Argument[1];logging",
            ";(String,Object,char);;Argument[1];logging",
            ";(String,Object,byte);;Argument[1];logging",
            ";(String,Object,short);;Argument[1];logging",
            ";(String,Object,int);;Argument[1];logging",
            ";(String,Object,long);;Argument[1];logging",
            ";(String,Object,float);;Argument[1];logging",
            ";(String,Object,double);;Argument[1];logging",
            ";(String,boolean,Object);;Argument[2];logging",
            ";(String,char,Object);;Argument[2];logging",
            ";(String,byte,Object);;Argument[2];logging",
            ";(String,short,Object);;Argument[2];logging",
            ";(String,int,Object);;Argument[2];logging",
            ";(String,long,Object);;Argument[2];logging",
            ";(String,float,Object);;Argument[2];logging",
            ";(String,double,Object);;Argument[2];logging"
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
          ] + ";logging",
        // java.util.logging.Logger
        "java.util.logging;Logger;true;" +
          ["config", "fine", "finer", "finest", "info", "severe", "warning"] +
          ";;;Argument[0];logging",
        "java.util.logging;Logger;true;entering;(String,String);;Argument[0..1];logging",
        "java.util.logging;Logger;true;entering;(String,String,Object);;Argument[0..2];logging",
        "java.util.logging;Logger;true;entering;(String,String,Object[]);;Argument[0..2];logging",
        "java.util.logging;Logger;true;exiting;(String,String);;Argument[0..1];logging",
        "java.util.logging;Logger;true;exiting;(String,String,Object);;Argument[0..2];logging",
        "java.util.logging;Logger;true;log;(Level,String);;Argument[1];logging",
        "java.util.logging;Logger;true;log;(Level,String,Object);;Argument[1..2];logging",
        "java.util.logging;Logger;true;log;(Level,String,Object[]);;Argument[1..2];logging",
        "java.util.logging;Logger;true;log;(Level,String,Throwable);;Argument[1];logging",
        "java.util.logging;Logger;true;log;(Level,Supplier);;Argument[1];logging",
        "java.util.logging;Logger;true;log;(Level,Throwable,Supplier);;Argument[2];logging",
        "java.util.logging;Logger;true;log;(LogRecord);;Argument[0];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,String);;Argument[1..3];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,String,Object);;Argument[1..4];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,String,Object[]);;Argument[1..4];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,String,Throwable);;Argument[1..3];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,Supplier);;Argument[1..3];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,Throwable,Supplier);;Argument[1..2];logging",
        "java.util.logging;Logger;true;logp;(Level,String,String,Throwable,Supplier);;Argument[4];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Object[]);;Argument[1..2];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Object[]);;Argument[4..5];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Throwable);;Argument[1..2];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,ResourceBundle,String,Throwable);;Argument[4];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String);;Argument[1..4];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String,Object);;Argument[1..5];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String,Object[]);;Argument[1..5];logging",
        "java.util.logging;Logger;true;logrb;(Level,String,String,String,String,Throwable);;Argument[1..4];logging",
        // android.util.Log
        "android.util;Log;true;" + ["d", "v", "i", "w", "e", "wtf"] + ";;;Argument[1];logging"
      ]
  }
}
