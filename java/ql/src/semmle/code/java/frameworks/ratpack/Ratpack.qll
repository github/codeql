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
abstract class RatpackGetRequestDataMethod extends Method { }

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
  }
}

/**
 * Ratpack methods that propagate user-supplied request data as tainted.
 */
private class RatpackHttpModel extends SummaryModelCsv {
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
        ["UploadedFile;true;getFileName;;;Argument[-1];ReturnValue;taint"]
  }
}
