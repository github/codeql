import java
private import semmle.code.java.dataflow.ExternalFlow

private class Jdk9DiffSinksCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.stream;XMLResolver;true;resolveEntity;(String,String,String,String);;Argument[1];open-url;generated"
      ]
  }
}
