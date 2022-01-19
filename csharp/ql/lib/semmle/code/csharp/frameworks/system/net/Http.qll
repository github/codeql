/** Provides definitions related to the `System.Net.Http` namespace. */

private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for `System.Net.Http.HttpRequestOptions`. */
private class SystemNetHttpHttpRequestOptionsFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Net.Http;HttpRequestOptions;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Property[System.Collections.Generic.KeyValuePair<,>.Key] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[Qualifier];value",
        "System.Net.Http;HttpRequestOptions;false;Add;(System.Collections.Generic.KeyValuePair<System.String,System.Object>);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[Qualifier];value",
      ]
  }
}

/** Data flow for `System.Net.Http.MultipartContent`. */
private class SystemNetHttpMultipartContentFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Net.Http;MultipartContent;false;Add;(System.Net.Http.HttpContent);;Argument[0];Element of Argument[Qualifier];value"
  }
}

/** Data flow for `System.Net.Http.MultipartFormDataContent`. */
private class SystemNetHttpMultipartFormDataContentFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Net.Http;MultipartFormDataContent;false;Add;(System.Net.Http.HttpContent);;Argument[0];Element of Argument[Qualifier];value"
  }
}
