import java
private import semmle.code.java.dataflow.ExternalFlow

private class Jdk11DiffSinksCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.rmi.server;RMIClassLoader;true;loadClass;(URL,String);;Argument[0];open-url;generated",
        "javax.management.loading;MLetMBean;true;getMBeansFromURL;(URL);;Argument[0];open-url;generated",
        "javax.xml.stream;XMLResolver;true;resolveEntity;(String,String,String,String);;Argument[1];open-url;generated"
      ]
  }
}
