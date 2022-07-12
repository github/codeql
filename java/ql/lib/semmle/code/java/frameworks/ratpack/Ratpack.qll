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
          "Request;true;getContentLength;;;ReturnValue;remote;manual",
          "Request;true;getCookies;;;ReturnValue;remote;manual",
          "Request;true;oneCookie;;;ReturnValue;remote;manual",
          "Request;true;getHeaders;;;ReturnValue;remote;manual",
          "Request;true;getPath;;;ReturnValue;remote;manual",
          "Request;true;getQuery;;;ReturnValue;remote;manual",
          "Request;true;getQueryParams;;;ReturnValue;remote;manual",
          "Request;true;getRawUri;;;ReturnValue;remote;manual",
          "Request;true;getUri;;;ReturnValue;remote;manual",
          "Request;true;getBody;;;ReturnValue;remote;manual"
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
        ] + ";ReturnValue;remote;manual"
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
          "TypedData;true;getBuffer;;;Argument[-1];ReturnValue;taint;manual",
          "TypedData;true;getBytes;;;Argument[-1];ReturnValue;taint;manual",
          "TypedData;true;getContentType;;;Argument[-1];ReturnValue;taint;manual",
          "TypedData;true;getInputStream;;;Argument[-1];ReturnValue;taint;manual",
          "TypedData;true;getText;;;Argument[-1];ReturnValue;taint;manual",
          "TypedData;true;writeTo;;;Argument[-1];Argument[0];taint;manual",
          "Headers;true;get;;;Argument[-1];ReturnValue;taint;manual",
          "Headers;true;getAll;;;Argument[-1];ReturnValue;taint;manual",
          "Headers;true;getNames;;;Argument[-1];ReturnValue;taint;manual",
          "Headers;true;asMultiValueMap;;;Argument[-1];ReturnValue;taint;manual"
        ]
    or
    row =
      ["ratpack.form;", "ratpack.core.form;"] +
        [
          "UploadedFile;true;getFileName;;;Argument[-1];ReturnValue;taint;manual",
          "Form;true;file;;;Argument[-1];ReturnValue;taint;manual",
          "Form;true;files;;;Argument[-1];ReturnValue;taint;manual"
        ]
    or
    row =
      ["ratpack.handling;", "ratpack.core.handling;"] +
        [
          "Context;true;parse;(ratpack.http.TypedData,ratpack.parse.Parse);;Argument[0];ReturnValue;taint;manual",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];ReturnValue;taint;manual",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];ReturnValue.MapKey;taint;manual",
          "Context;true;parse;(ratpack.core.http.TypedData,ratpack.core.parse.Parse);;Argument[0];ReturnValue.MapValue;taint;manual"
        ]
    or
    row =
      ["ratpack.util;", "ratpack.func;"] +
        [
          "MultiValueMap;true;getAll;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          "MultiValueMap;true;getAll;();;Argument[-1].MapValue;ReturnValue.MapValue.Element;value;manual",
          "MultiValueMap;true;getAll;(Object);;Argument[-1].MapValue;ReturnValue.Element;value;manual",
          "MultiValueMap;true;asMultimap;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          "MultiValueMap;true;asMultimap;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual"
        ]
    or
    exists(string left, string right |
      left = "Field[ratpack.func.Pair.left]" and
      right = "Field[ratpack.func.Pair.right]"
    |
      row =
        ["ratpack.util;", "ratpack.func;"] + "Pair;true;" +
          [
            "of;;;Argument[0];ReturnValue." + left + ";value;manual",
            "of;;;Argument[1];ReturnValue." + right + ";value;manual",
            "pair;;;Argument[0];ReturnValue." + left + ";value;manual",
            "pair;;;Argument[1];ReturnValue." + right + ";value;manual",
            "left;();;Argument[-1]." + left + ";ReturnValue;value;manual",
            "right;();;Argument[-1]." + right + ";ReturnValue;value;manual",
            "getLeft;;;Argument[-1]." + left + ";ReturnValue;value;manual",
            "getRight;;;Argument[-1]." + right + ";ReturnValue;value;manual",
            "left;(Object);;Argument[0];ReturnValue." + left + ";value;manual",
            "left;(Object);;Argument[-1]." + right + ";ReturnValue." + right + ";value;manual",
            "right;(Object);;Argument[0];ReturnValue." + right + ";value;manual",
            "right;(Object);;Argument[-1]." + left + ";ReturnValue." + left + ";value;manual",
            "pushLeft;(Object);;Argument[-1];ReturnValue." + right + ";value;manual",
            "pushRight;(Object);;Argument[-1];ReturnValue." + left + ";value;manual",
            "pushLeft;(Object);;Argument[0];ReturnValue." + left + ";value;manual",
            "pushRight;(Object);;Argument[0];ReturnValue." + right + ";value;manual",
            // `nestLeft` Pair<A, B>.nestLeft(C) -> Pair<Pair<C, A>, B>
            "nestLeft;(Object);;Argument[0];ReturnValue." + left + "." + left + ";value;manual",
            "nestLeft;(Object);;Argument[-1]." + left + ";ReturnValue." + left + "." + right +
              ";value;manual",
            "nestLeft;(Object);;Argument[-1]." + right + ";ReturnValue." + right + ";value;manual",
            // `nestRight` Pair<A, B>.nestRight(C) -> Pair<A, Pair<C, B>>
            "nestRight;(Object);;Argument[0];ReturnValue." + right + "." + left + ";value;manual",
            "nestRight;(Object);;Argument[-1]." + left + ";ReturnValue." + left + ";value;manual",
            "nestRight;(Object);;Argument[-1]." + right + ";ReturnValue." + right + "." + right +
              ";value;manual",
            // `mapLeft` & `mapRight` map over their respective fields
            "mapLeft;;;Argument[-1]." + left + ";Argument[0].Parameter[0];value;manual",
            "mapLeft;;;Argument[-1]." + right + ";ReturnValue." + right + ";value;manual",
            "mapRight;;;Argument[-1]." + right + ";Argument[0].Parameter[0];value;manual",
            "mapRight;;;Argument[-1]." + left + ";ReturnValue." + left + ";value;manual",
            "mapLeft;;;Argument[0].ReturnValue;ReturnValue." + left + ";value;manual",
            "mapRight;;;Argument[0].ReturnValue;ReturnValue." + right + ";value;manual",
            // `map` maps over the `Pair`
            "map;;;Argument[-1];Argument[0].Parameter[0];value;manual",
            "map;;;Argument[0].ReturnValue;ReturnValue;value;manual"
          ]
    )
  }
}
