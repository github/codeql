/**
 * Provides classes and predicates related to `ratpack.*`.
 */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Ratpack methods that access user-supplied request data.
 */
private class RatpackHttpSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      ["ratpack.http;", "ratpack.core.http;"] +
        [
          "Request;true;getContentLength;;;ReturnValue;remote",
          "Request;true;getCookies;;;ReturnValue;remote",
          "Request;true;oneCookie;;;ReturnValue;remote",
          "Request;true;getHeaders;;;ReturnValue;remote",
          "Request;true;getPath;;;ReturnValue;remote", "Request;true;getQuery;;;ReturnValue;remote",
          "Request;true;getQueryParams;;;ReturnValue;remote",
          "Request;true;getRawUri;;;ReturnValue;remote", "Request;true;getUri;;;ReturnValue;remote",
          "Request;true;getBody;;;ReturnValue;remote"
        ]
    or
    // All Context#parse methods that return a Promise are remote flow sources.
    row =
      ["ratpack.handling;", "ratpack.core.handling;"] + "Context;true;parse;" +
        [
          "(java.lang.Class);", "(com.google.common.reflect.TypeToken);",
          "(java.lang.Class,java.lang.Object);",
          "(com.google.common.reflect.TypeToken,java.lang.Object);", "(ratpack.core.parse.Parse);",
          "(ratpack.parse.Parse);"
        ] + ";ReturnValue;remote"
  }
}

/**
 * Ratpack methods that propagate user-supplied request data as tainted.
 */
private class RatpackModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["ratpack.http;", "ratpack.core.http;"] +
        [
          "TypedData;true;getBuffer;;;Argument[-1];ReturnValue;taint",
          "TypedData;true;getBytes;;;Argument[-1];ReturnValue;taint",
          "TypedData;true;getContentType;;;Argument[-1];ReturnValue;taint",
          "TypedData;true;getInputStream;;;Argument[-1];ReturnValue;taint",
          "TypedData;true;getText;;;Argument[-1];ReturnValue;taint",
          "TypedData;true;writeTo;;;Argument[-1];Argument[0];taint",
          "Headers;true;get;;;Argument[-1];ReturnValue;taint",
          "Headers;true;getAll;;;Argument[-1];ReturnValue;taint",
          "Headers;true;getNames;;;Argument[-1];ReturnValue;taint",
          "Headers;true;asMultiValueMap;;;Argument[-1];ReturnValue;taint"
        ]
    or
    row =
      ["ratpack.form;", "ratpack.core.form;"] +
        [
          "UploadedFile;true;getFileName;;;Argument[-1];ReturnValue;taint",
          "Form;true;file;;;Argument[-1];ReturnValue;taint",
          "Form;true;files;;;Argument[-1];ReturnValue;taint"
        ]
    or
    row =
      ["ratpack.handling;", "ratpack.core.handling;"] +
        [
          "Context;true;parse;(ratpack.http.TypedData,ratpack.parse.Parse);;Argument[0];ReturnValue;taint",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];ReturnValue;taint",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];MapKey of ReturnValue;taint",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];MapValue of ReturnValue;taint"
        ]
    or
    row =
      ["ratpack.util;", "ratpack.func;"] +
        [
          "MultiValueMap;true;getAll;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          "MultiValueMap;true;getAll;();;MapValue of Argument[-1];Element of MapValue of ReturnValue;value",
          "MultiValueMap;true;getAll;(Object);;MapValue of Argument[-1];Element of ReturnValue;value",
          "MultiValueMap;true;asMultimap;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          "MultiValueMap;true;asMultimap;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
        ]
  }
}
