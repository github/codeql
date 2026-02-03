private import cpp
private import semmle.code.cpp.ir.dataflow.FlowSteps
private import semmle.code.cpp.dataflow.new.DataFlow

/** The `WINHTTP_HEADER_NAME` class from `winhttp.h`. */
class WinHttpHeaderName extends Class {
  WinHttpHeaderName() { this.hasGlobalName("_WINHTTP_HEADER_NAME") }
}

/** The `WINHTTP_EXTENDED_HEADER` class from `winhttp.h`. */
class WinHttpExtendedHeader extends Class {
  WinHttpExtendedHeader() { this.hasGlobalName("_WINHTTP_EXTENDED_HEADER") }
}

private class WinHttpHeaderNameInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  WinHttpHeaderNameInheritingContent() {
    this.getIndirectionIndex() = 2 and
    (
      this.getAField().getDeclaringType() instanceof WinHttpHeaderName
      or
      // The extended header looks like:
      // struct WINHTTP_EXTENDED_HEADER {
      //   union { [...] };
      //   union { [...] };
      // };
      // So the first declaring type is the anonymous unions, and the declaring
      // type of those anonymous unions is the `WINHTTP_EXTENDED_HEADER` struct.
      this.getAField().getDeclaringType().getDeclaringType() instanceof WinHttpExtendedHeader
    )
  }
}

/** The `URL_COMPONENTS` class from `winhttp.h`. */
class WinHttpUrlComponents extends Class {
  WinHttpUrlComponents() { this.hasGlobalName("_WINHTTP_URL_COMPONENTS") }
}

private class WinHttpUrlComponentsInheritingContent extends TaintInheritingContent,
  DataFlow::FieldContent
{
  WinHttpUrlComponentsInheritingContent() {
    exists(Field f | f = this.getField() and f.getDeclaringType() instanceof WinHttpUrlComponents |
      if f.getType().getUnspecifiedType() instanceof PointerType
      then this.getIndirectionIndex() = 2
      else this.getIndirectionIndex() = 1
    )
  }
}
