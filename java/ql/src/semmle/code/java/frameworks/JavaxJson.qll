/**
 * Provides models for the `javax.json` package.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class FlowSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.json;JsonArray;false;getBoolean;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getBoolean;;;Argument[1];ReturnValue;value",
        "javax.json;JsonArray;false;getInt;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getInt;;;Argument[1];ReturnValue;value",
        "javax.json;JsonArray;false;getJsonArray;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getJsonNumber;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getJsonObject;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getJsonString;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getString;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArray;false;getString;;;Argument[1];ReturnValue;value",
        "javax.json;JsonArray;false;getValuesAs;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonArrayBuilder;false;add;;;Argument[-1];ReturnValue;value",
        "javax.json;JsonArrayBuilder;false;add;;;Argument[0];Argument[-1];taint",
        "javax.json;JsonArrayBuilder;false;addNull;;;Argument[-1];ReturnValue;value",
        "javax.json;JsonArrayBuilder;false;build;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;bigDecimalValue;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;bigIntegerValue;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;bigIntegerValueExact;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;doubleValue;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;intValue;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;intValueExact;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;longValue;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonNumber;false;longValueExact;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getBoolean;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getBoolean;;;Argument[1];ReturnValue;value",
        "javax.json;JsonObject;false;getInt;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getInt;;;Argument[1];ReturnValue;value",
        "javax.json;JsonObject;false;getJsonArray;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getJsonNumber;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getJsonObject;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getJsonString;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getString;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonObject;false;getString;;;Argument[1];ReturnValue;value",
        "javax.json;JsonObjectBuilder;false;add;;;Argument[-1];ReturnValue;value",
        "javax.json;JsonObjectBuilder;false;add;;;Argument[1];Argument[-1];taint",
        "javax.json;JsonObjectBuilder;false;addNull;;;Argument[-1];ReturnValue;value",
        "javax.json;JsonObjectBuilder;false;build;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonReader;false;read;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonReader;false;readArray;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonReader;false;readObject;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonReaderFactory;false;createReader;;;Argument[0];ReturnValue;taint",
        "javax.json;JsonString;false;getChars;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonString;false;getString;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonValue;false;toString;;;Argument[-1];ReturnValue;taint",
        "javax.json;JsonWriter;false;write;;;Argument[0];Argument[-1];taint",
        "javax.json;JsonWriter;false;writeArray;;;Argument[0];Argument[-1];taint",
        "javax.json;JsonWriter;false;writeObject;;;Argument[0];Argument[-1];taint",
        "javax.json;JsonWriterFactory;false;createWriter;;;Argument[-1];Argument[0];taint"
      ]
  }
}
