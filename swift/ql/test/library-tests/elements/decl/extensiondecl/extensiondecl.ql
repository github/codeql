import swift

string describe(ExtensionDecl e) {
  result = "getExtendedTypeDecl:" + e.getExtendedTypeDecl().toString()
  or
  exists(int ix | result = "getProtocol(" + ix.toString() + "):" + e.getProtocol(ix).toString())
}

from ExtensionDecl e
where not e.getFile() instanceof UnknownFile
select e, concat(describe(e), ", ")
