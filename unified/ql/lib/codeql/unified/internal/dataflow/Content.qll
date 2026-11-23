private import unified
private import AllDataFlow
private import codeql.unified.internal.typeinference.TypeInference as T
private import codeql.unified.internal.typeinference.TypeInferencePlugin as TP

/**
 * Holds if a MaD access path token of form `name[arg]` exists.
 */
predicate isAccessPathTokenPresent(string name, string arg) {
  arg = any(FlowSummaryOutput::Private::AccessPathToken tok).getAnArgument(name)
}

private class ResolvedField extends VariableDeclaration {
  ResolvedField() { this = T::resolveFieldAccess(_) }

  string getName() {
    result = super.getName() and
    not this = any(TP::TupleType tt).getField(_)
    or
    this = any(TP::TupleType tt).getField(result)
  }
}

private newtype TContent =
  TArrayElement() or
  TFieldContent(ResolvedField field) or
  TNamedMember(string name) {
    name = any(Identifier id).getValue()
    or
    // Tuple elements can be accessed as named members, e.g. `tuple.0`, `tuple.1`, etc,
    // so just model their elements as named members.
    name = [0 .. 20].toString()
    or
    name = getEnumCaseParameterFieldFromArgument(_, _)
    or
    isAccessPathTokenPresent("Member", name)
  } or
  TCapturedVariable(CaptureSsaInput::CapturedVariable v)

class Content extends TContent {
  ResolvedField asField() { this = TFieldContent(result) }

  string asNamedMember() { this = TNamedMember(result) }

  predicate isArrayElement() { this = TArrayElement() }

  string toString() {
    result = this.asNamedMember()
    or
    result = this.asField().getName()
    or
    this.isArrayElement() and result = "ArrayElement"
    or
    result = this.asCapturedVariable().toString()
  }

  LocalVariable asCapturedVariable() { this = TCapturedVariable(result) }

  Location getLocation() {
    result = this.asCapturedVariable().getLocation()
    or
    result = this.asField().getLocation()
  }
}

private class TContentApprox = TArrayElement or TNamedMember or TCapturedVariable;

class ContentApprox extends Content, TContentApprox { }

private newtype TContentSet = TSingleton(Content content)

class ContentSet extends TContentSet {
  Content asSingleton() { this = TSingleton(result) }

  string toString() { result = this.asSingleton().toString() }

  Location getLocation() { result = this.asSingleton().getLocation() }

  Content getAStoreContent() { result = this.asSingleton() }

  Content getAReadContent() {
    result = this.asSingleton()
    or
    result.asNamedMember() = this.asSingleton().asField().getName()
    or
    result.asField().getName() = this.asSingleton().asNamedMember()
  }
}

module ContentSet {
  /**
   * Gets the member name to use for `access`, if any.
   *
   * Only returns a member name if it cannot be resolved uniquely to a field.
   */
  private string getMemberName(Expr access) {
    access =
      any(MemberAccessExpr mae |
        result = mae.getMemberName() and
        if exists(T::inferTypeUnique(mae.getBase()))
        then not exists(T::resolveFieldAccess(mae))
        else any()
      )
    or
    result = access.(UnqualifiedMemberAccess).getMemberName() and
    not exists(T::resolveFieldAccess(access))
  }

  ContentSet member(Expr access) {
    result.asSingleton().asField() = T::resolveFieldAccess(access) and
    not exists(getMemberName(access))
    or
    result = namedMember(getMemberName(access))
  }

  ContentSet namedMember(string name) { result.asSingleton().asNamedMember() = name }

  ContentSet arrayElement() { result.asSingleton().isArrayElement() }

  ContentSet capturedVariable(LocalVariable v) { result.asSingleton().asCapturedVariable() = v }
}
