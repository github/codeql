import java
import semmle.code.java.dataflow.ExternalFlowConfiguration


string kind() {
  result = [
    "remote",
    "local",
    "android",
    "sql",
    "android-external-storage-dir",
    "standard",
    "expansive",
    "hucairz",
    "request",
    "response",
  ]
}

from string a, string b
where (a = kind())
 and ((supportedSourceModel(a) and b = "YES") or (not supportedSourceModel(a) and b = "NO"))
select a, b
