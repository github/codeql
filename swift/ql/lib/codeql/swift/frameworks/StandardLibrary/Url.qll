import swift
private import codeql.swift.dataflow.FlowSources

/**
 * Model certain members of `URL` as sources of remote flow.
 */
class UrlRemoteFlowSource extends RemoteFlowSource {
  UrlRemoteFlowSource() {
    exists(StructDecl urlClass, ConcreteVarDecl memberDecl |
      urlClass.getName() = "URL" and
      (
        urlClass.getAMember() = memberDecl and
        memberDecl.getName() = ["resourceBytes", "lines"]
        or
        exists(StructDecl asyncBytesClass |
          urlClass.getAMember() = asyncBytesClass and
          asyncBytesClass.getName() = "AsyncBytes" and
          asyncBytesClass.getAMember() = memberDecl and
          memberDecl.getName() = "lines"
        )
      ) and
      this.asExpr().(MemberRefExpr).getMember() = memberDecl
    )
  }

  override string getSourceType() { result = "external" }
}
