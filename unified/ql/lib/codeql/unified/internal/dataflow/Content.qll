private import unified
private import AllDataFlow

private newtype TContent =
  TArrayElement() or
  TNamedMember(string name) {
    name = any(Identifier id).getValue()
    or
    // Tuple elements can be accessed as named members, e.g. `tuple.0`, `tuple.1`, etc,
    // so just model their elements as named members.
    name = [0 .. 20].toString()
    or
    name = getEnumCaseParameterFieldFromArgument(_, _)
  } or
  TCapturedVariable(CaptureSsaInput::CapturedVariable v)

class Content extends TContent {
  string asNamedMember() { this = TNamedMember(result) }

  predicate isArrayElement() { this = TArrayElement() }

  string toString() {
    result = this.asNamedMember()
    or
    this.isArrayElement() and result = "ArrayElement"
    or
    result = this.asCapturedVariable().toString()
  }

  LocalVariable asCapturedVariable() { this = TCapturedVariable(result) }

  Location getLocation() { result = this.asCapturedVariable().getLocation() }
}

private newtype TContentSet = TSingleton(Content content)

class ContentSet extends TContentSet {
  Content asSingleton() { this = TSingleton(result) }

  string toString() { result = this.asSingleton().toString() }

  Location getLocation() { result = this.asSingleton().getLocation() }

  Content getAStoreContent() { result = this.asSingleton() }

  Content getAReadContent() { result = this.asSingleton() }
}

module ContentSet {
  ContentSet namedMember(string name) { result.asSingleton().asNamedMember() = name }

  ContentSet arrayElement() { result.asSingleton().isArrayElement() }

  ContentSet capturedVariable(LocalVariable v) { result.asSingleton().asCapturedVariable() = v }
}
