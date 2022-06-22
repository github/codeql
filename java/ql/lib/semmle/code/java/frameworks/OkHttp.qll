/**
 * Provides classes and predicates for working with the OkHttp client.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class OkHttpOpenUrlSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "okhttp3;Request;true;Request;;;Argument[0];open-url;manual",
        "okhttp3;Request$Builder;true;url;;;Argument[0];open-url;manual"
      ]
  }
}

private class OKHttpSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "okhttp3;HttpUrl;false;parse;;;Argument[0];ReturnValue;taint;manual",
        "okhttp3;HttpUrl;false;uri;;;Argument[-1];ReturnValue;taint;manual",
        "okhttp3;HttpUrl;false;url;;;Argument[-1];ReturnValue;taint;manual",
        "okhttp3;HttpUrl$Builder;false;addEncodedPathSegment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;addEncodedPathSegment;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;addEncodedPathSegments;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;addEncodedPathSegments;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;addEncodedQueryParameter;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;addEncodedQueryParameter;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;addPathSegment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;addPathSegment;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;addPathSegments;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;addPathSegments;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;addQueryParameter;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;addQueryParameter;;;Argument[0..1];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;build;;;Argument[-1];ReturnValue;taint;manual",
        "okhttp3;HttpUrl$Builder;false;encodedFragment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;encodedFragment;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;encodedPassword;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;encodedPath;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;encodedPath;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;encodedQuery;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;encodedQuery;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;encodedUsername;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;fragment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;fragment;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;host;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;host;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;password;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;port;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;port;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;query;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;query;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;removeAllEncodedQueryParameters;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;removeAllQueryParameters;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;removePathSegment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;scheme;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;scheme;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;setEncodedPathSegment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;setEncodedPathSegment;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;setEncodedQueryParameter;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;setEncodedQueryParameter;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;setPathSegment;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;setPathSegment;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;setQueryParameter;;;Argument[-1];ReturnValue;value;manual",
        "okhttp3;HttpUrl$Builder;false;setQueryParameter;;;Argument[0];Argument[-1];taint;manual",
        "okhttp3;HttpUrl$Builder;false;username;;;Argument[-1];ReturnValue;value;manual",
      ]
  }
}
