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
    or
    exists(string left, string right |
      left = "Field[ratpack.func.Pair.left]" and
      right = "Field[ratpack.func.Pair.right]"
    |
      row =
        ["ratpack.util;", "ratpack.func;"] + "Pair;true;" +
          [
            "of;;;Argument[0];" + left + " of ReturnValue;value",
            "of;;;Argument[1];" + right + " of ReturnValue;value",
            "pair;;;Argument[0];" + left + " of ReturnValue;value",
            "pair;;;Argument[1];" + right + " of ReturnValue;value",
            "left;();;" + left + " of Argument[-1];ReturnValue;value",
            "right;();;" + right + " of Argument[-1];ReturnValue;value",
            "getLeft;;;" + left + " of Argument[-1];ReturnValue;value",
            "getRight;;;" + right + " of Argument[-1];ReturnValue;value",
            "left;(Object);;Argument[0];" + left + " of ReturnValue;value",
            "left;(Object);;" + right + " of Argument[-1];" + right + " of ReturnValue;value",
            "right;(Object);;Argument[0];" + right + " of ReturnValue;value",
            "right;(Object);;" + left + " of Argument[-1];" + left + " of ReturnValue;value",
            "pushLeft;(Object);;Argument[-1];" + right + " of ReturnValue;value",
            "pushRight;(Object);;Argument[-1];" + left + " of ReturnValue;value",
            "pushLeft;(Object);;Argument[0];" + left + " of ReturnValue;value",
            "pushRight;(Object);;Argument[0];" + right + " of ReturnValue;value",
            // `nestLeft` Pair<A, B>.nestLeft(C) -> Pair<Pair<C, A>, B>
            "nestLeft;(Object);;Argument[0];" + left + " of " + left + " of ReturnValue;value",
            "nestLeft;(Object);;" + left + " of Argument[-1];" + right + " of " + left +
              " of ReturnValue;value",
            "nestLeft;(Object);;" + right + " of Argument[-1];" + right + " of ReturnValue;value",
            // `nestRight` Pair<A, B>.nestRight(C) -> Pair<A, Pair<C, B>>
            "nestRight;(Object);;Argument[0];" + left + " of " + right + " of ReturnValue;value",
            "nestRight;(Object);;" + left + " of Argument[-1];" + left + " of ReturnValue;value",
            "nestRight;(Object);;" + right + " of Argument[-1];" + right + " of " + right +
              " of ReturnValue;value",
            // `mapLeft` & `mapRight` map over their respective fields
            "mapLeft;;;" + left + " of Argument[-1];Parameter[0] of Argument[0];value",
            "mapLeft;;;" + right + " of Argument[-1];" + right + " of ReturnValue;value",
            "mapRight;;;" + right + " of Argument[-1];Parameter[0] of Argument[0];value",
            "mapRight;;;" + left + " of Argument[-1];" + left + " of ReturnValue;value",
            "mapLeft;;;ReturnValue of Argument[0];" + left + " of ReturnValue;value",
            "mapRight;;;ReturnValue of Argument[0];" + right + " of ReturnValue;value",
            // `map` maps over the `Pair`
            "map;;;Argument[-1];Parameter[0] of Argument[0];value",
            "map;;;ReturnValue of Argument[0];ReturnValue;value"
          ]
    )
  }
}
