/** Models construction of BDE character views. */

private import cpp
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl::Public

/** Only pointer-based constructors read character data from their first argument. */
private class CharacterViewConstructor extends SummarizedCallable {
  CharacterViewConstructor() {
    this instanceof Constructor and
    this.getDeclaringType().hasQualifiedName("BloombergLP::bslstl", "StringRefImp") and
    this.getParameter(0).getUnspecifiedType() instanceof PointerType
  }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, Provenance provenance, boolean isExact,
    string model
  ) {
    input = "Argument[*0]" and
    output = "Argument[-1].Element[]" and
    preservesValue = true and
    provenance = "manual" and
    isExact = true and
    model = ""
  }
}
