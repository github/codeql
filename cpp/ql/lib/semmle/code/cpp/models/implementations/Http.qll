private import cpp
private import semmle.code.cpp.ir.dataflow.FlowSteps
private import semmle.code.cpp.dataflow.new.DataFlow

private class HttpRequest extends Class {
  HttpRequest() { this.hasGlobalName("_HTTP_REQUEST_V1") }
}

private class HttpRequestInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  HttpRequestInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpRequest and
    (
      this.getAField().hasName("pRawUrl") and
      this.getIndirectionIndex() = 2
      or
      this.getAField().hasName("CookedUrl") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("Headers") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("pEntityChunks") and
      this.getIndirectionIndex() = 2
      or
      this.getAField().hasName("pSslInfo") and
      this.getIndirectionIndex() = 2
    )
  }
}

private class HttpCookedUrl extends Class {
  HttpCookedUrl() { this.hasGlobalName("_HTTP_COOKED_URL") }
}

private class HttpCookedUrlInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  HttpCookedUrlInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpCookedUrl and
    this.getAField().hasName(["pFullUrl", "pHost", "pAbsPath", "pQueryString"]) and
    this.getIndirectionIndex() = 2
  }
}

private class HttpRequestHeaders extends Class {
  HttpRequestHeaders() { this.hasGlobalName("_HTTP_REQUEST_HEADERS") }
}

private class HttpRequestHeadersInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  HttpRequestHeadersInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpRequestHeaders and
    (
      this.getAField().hasName("KnownHeaders") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("pUnknownHeaders") and
      this.getIndirectionIndex() = 2
    )
  }
}

private class HttpKnownHeader extends Class {
  HttpKnownHeader() { this.hasGlobalName("_HTTP_KNOWN_HEADER") }
}

private class HttpKnownHeaderInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  HttpKnownHeaderInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpKnownHeader and
    this.getAField().hasName("pRawValue") and
    this.getIndirectionIndex() = 2
  }
}

private class HttpUnknownHeader extends Class {
  HttpUnknownHeader() { this.hasGlobalName("_HTTP_UNKNOWN_HEADER") }
}

private class HttpUnknownHeaderInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  HttpUnknownHeaderInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpUnknownHeader and
    this.getAField().hasName(["pName", "pRawValue"]) and
    this.getIndirectionIndex() = 2
  }
}

private class HttpDataChunk extends Class {
  HttpDataChunk() { this.hasGlobalName("_HTTP_DATA_CHUNK") }
}

private class HttpDataChunkInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  HttpDataChunkInheritingContent() {
    this.getAField().getDeclaringType().(Union).getDeclaringType() instanceof HttpDataChunk and
    (
      this.getAField().hasName("FromMemory") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("FromFileHandle") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("FromFragmentCache") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("FromFragmentCacheEx") and
      this.getIndirectionIndex() = 1
      or
      this.getAField().hasName("Trailers") and
      this.getIndirectionIndex() = 1
    )
  }
}

private class FromMemory extends Class {
  FromMemory() {
    this.getDeclaringType().(Union).getDeclaringType() instanceof HttpDataChunk and
    this.getAField().hasName("pBuffer")
  }
}

private class FromMemoryInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  FromMemoryInheritingContent() {
    this.getAField().getDeclaringType() instanceof FromMemory and
    this.getAField().hasName("pBuffer") and
    this.getIndirectionIndex() = 2
  }
}

private class FromFileHandle extends Class {
  FromFileHandle() {
    this.getDeclaringType().(Union).getDeclaringType() instanceof HttpDataChunk and
    this.getAField().hasName("FileHandle")
  }
}

private class FromFileHandleInheritingContent extends TaintInheritingContent, DataFlow::FieldContent
{
  FromFileHandleInheritingContent() {
    this.getAField().getDeclaringType() instanceof FromFileHandle and
    this.getIndirectionIndex() = 1 and
    this.getAField().hasName("FileHandle")
  }
}

private class FromFragmentCacheOrCacheEx extends Class {
  FromFragmentCacheOrCacheEx() {
    this.getDeclaringType().(Union).getDeclaringType() instanceof HttpDataChunk and
    this.getAField().hasName("pFragmentName")
  }
}

private class FromFragmentCacheInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  FromFragmentCacheInheritingContent() {
    this.getAField().getDeclaringType() instanceof FromFragmentCacheOrCacheEx and
    this.getIndirectionIndex() = 2 and
    this.getAField().hasName("pFragmentName")
  }
}

private class HttpSslInfo extends Class {
  HttpSslInfo() { this.hasGlobalName("_HTTP_SSL_INFO") }
}

private class HttpSslInfoInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  HttpSslInfoInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpSslInfo and
    this.getAField().hasName(["pServerCertIssuer", "pServerCertSubject", "pClientCertInfo"]) and
    this.getIndirectionIndex() = 2
  }
}

private class HttpSslClientCertInfo extends Class {
  HttpSslClientCertInfo() { this.hasGlobalName("_HTTP_SSL_CLIENT_CERT_INFO") }
}

private class HttpSslClientCertInfoInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  HttpSslClientCertInfoInheritingContent() {
    this.getAField().getDeclaringType() instanceof HttpSslClientCertInfo and
    (
      this.getAField().hasName("pCertEncoded") and
      this.getIndirectionIndex() = 2
      or
      this.getAField().hasName("Token") and
      this.getIndirectionIndex() = 1
    )
  }
}
