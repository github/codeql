package my.qltest.synth;

public class A {
  void storeInArray(String x) { }
  void storeTaintInArray(String x) { }
  void storeValue(String x) { }

  String readValue() { return null; }
  String readArray() { return null; }

  String source(String tag) { return "tainted"; }

  void sink(Object o) { }

  void stores() {
    storeInArray(source("A"));
    storeTaintInArray(source("B"));
    storeValue(source("C"));
  }

  void reads() {
    sink(readValue()); // $ hasValueFlow=C
    sink(readArray()); // $ hasValueFlow=A hasTaintFlow=B hasTaintFlow=C
  }
}
