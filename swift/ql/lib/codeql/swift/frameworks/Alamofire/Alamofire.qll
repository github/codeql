/**
 * Models for the Alamofire networking library.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSources

/**
 * An Alamofire response handler type.
 */
private class AlamofireResponseType extends NominalTypeDecl {
  AlamofireResponseType() {
    this.getFullName() = ["DataResponse", "DownloadResponse"] or
    this.getABaseTypeDecl() instanceof AlamofireResponseType
  }

  /**
   * A response handler field that contains remote data.
   */
  FieldDecl getADataField() {
    result = this.getAMember() and
    result.getName() = ["data", "value", "result"]
  }
}

/**
 * A remote flow source that is an access to remote data from an Alamofire response handler.
 */
private class AlamofireResponseSource extends RemoteFlowSource {
  AlamofireResponseSource() {
    exists(AlamofireResponseType responseType |
      this.asExpr().(MemberRefExpr).getMember() = responseType.getADataField()
    )
  }

  override string getSourceType() { result = "Data from an Alamofire response" }
}
