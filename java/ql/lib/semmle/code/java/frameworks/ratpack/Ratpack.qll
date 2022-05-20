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
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];ReturnValue.MapKey;taint",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];ReturnValue.MapValue;taint"
        ]
    or
    row =
      ["ratpack.util;", "ratpack.func;"] +
        [
          "MultiValueMap;true;getAll;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          "MultiValueMap;true;getAll;();;Argument[-1].MapValue;ReturnValue.MapValue.Element;value",
          "MultiValueMap;true;getAll;(Object);;Argument[-1].MapValue;ReturnValue.Element;value",
          "MultiValueMap;true;asMultimap;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          "MultiValueMap;true;asMultimap;;;Argument[-1].MapValue;ReturnValue.MapValue;value"
        ]
    or
    exists(string left, string right |
      left = "Field[ratpack.func.Pair.left]" and
      right = "Field[ratpack.func.Pair.right]"
    |
      row =
        ["ratpack.util;", "ratpack.func;"] + "Pair;true;" +
          [
            "of;;;Argument[0];ReturnValue." + left + ";value",
            "of;;;Argument[1];ReturnValue." + right + ";value",
            "pair;;;Argument[0];ReturnValue." + left + ";value",
            "pair;;;Argument[1];ReturnValue." + right + ";value",
            "left;();;Argument[-1]." + left + ";ReturnValue;value",
            "right;();;Argument[-1]." + right + ";ReturnValue;value",
            "getLeft;;;Argument[-1]." + left + ";ReturnValue;value",
            "getRight;;;Argument[-1]." + right + ";ReturnValue;value",
            "left;(Object);;Argument[0];ReturnValue." + left + ";value",
            "left;(Object);;Argument[-1]." + right + ";ReturnValue." + right + ";value",
            "right;(Object);;Argument[0];ReturnValue." + right + ";value",
            "right;(Object);;Argument[-1]." + left + ";ReturnValue." + left + ";value",
            "pushLeft;(Object);;Argument[-1];ReturnValue." + right + ";value",
            "pushRight;(Object);;Argument[-1];ReturnValue." + left + ";value",
            "pushLeft;(Object);;Argument[0];ReturnValue." + left + ";value",
            "pushRight;(Object);;Argument[0];ReturnValue." + right + ";value",
            // `nestLeft` Pair<A, B>.nestLeft(C) -> Pair<Pair<C, A>, B>
            "nestLeft;(Object);;Argument[0];ReturnValue." + left + "." + left + ";value",
            "nestLeft;(Object);;Argument[-1]." + left + ";ReturnValue." + left + "." + right +
              ";value",
            "nestLeft;(Object);;Argument[-1]." + right + ";ReturnValue." + right + ";value",
            // `nestRight` Pair<A, B>.nestRight(C) -> Pair<A, Pair<C, B>>
            "nestRight;(Object);;Argument[0];ReturnValue." + right + "." + left + ";value",
            "nestRight;(Object);;Argument[-1]." + left + ";ReturnValue." + left + ";value",
            "nestRight;(Object);;Argument[-1]." + right + ";ReturnValue." + right + "." + right +
              ";value",
            // `mapLeft` & `mapRight` map over their respective fields
            "mapLeft;;;Argument[-1]." + left + ";Argument[0].Parameter[0];value",
            "mapLeft;;;Argument[-1]." + right + ";ReturnValue." + right + ";value",
            "mapRight;;;Argument[-1]." + right + ";Argument[0].Parameter[0];value",
            "mapRight;;;Argument[-1]." + left + ";ReturnValue." + left + ";value",
            "mapLeft;;;Argument[0].ReturnValue;ReturnValue." + left + ";value",
            "mapRight;;;Argument[0].ReturnValue;ReturnValue." + right + ";value",
            // `map` maps over the `Pair`
            "map;;;Argument[-1];Argument[0].Parameter[0];value",
            "map;;;Argument[0].ReturnValue;ReturnValue;value"
          ]
    )
  }
}
