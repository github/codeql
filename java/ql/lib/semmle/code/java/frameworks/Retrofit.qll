/**
 * Provides classes and predicates for working with the Retrofit API client.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class RetrofitOpenUrlSinks extends SinkModelCsv {
  override predicate row(string row) {
    row = "retrofit2;Retrofit$Builder;true;baseUrl;;;Argument[0];open-url;manual"
  }
}
