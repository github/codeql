/**
 * Provides models for standard library Swift classses related to security
 * (certificate, key and trust services).
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

private class SensitiveSources extends SourceModelCsv {
  override predicate row(string row) {
    row = ";;false;SecKeyCopyExternalRepresentation(_:_:);;;ReturnValue;sensitive-password"
  }
}
