/**
 * Models for the Alamofire networking library.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources

private class StringSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // `DataResponse.data`, `.value`, `.result`
        ";DataResponse;true;data;;;;remote", ";DataResponse;true;value;;;;remote",
        ";DataResponse;true;result;;;;remote",
        // `DownloadResponse.data`, `.value`, `.result`
        ";DownloadResponse;true;data;;;;remote", ";DownloadResponse;true;value;;;;remote",
        ";DownloadResponse;true;result;;;;remote",
      ]
  }
}
