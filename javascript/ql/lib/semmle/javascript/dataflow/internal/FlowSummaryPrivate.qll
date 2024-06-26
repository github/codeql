/**
 * Provides JS specific classes and predicates for defining flow summaries.
 */

private import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate
private import semmle.javascript.dataflow.internal.Contents::Private
private import semmle.javascript.dataflow.FlowSummary as FlowSummary
private import sharedlib.DataFlowImplCommon
private import sharedlib.FlowSummaryImpl::Private as Private
private import sharedlib.FlowSummaryImpl::Public
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax

private class Node = DataFlow::Node;

/**
 * A class of callables that are candidates for flow summary modeling.
 */
class SummarizedCallableBase = string;

/**
 * A class of callables that are candidates for neutral modeling.
 */
class NeutralCallableBase = string;

/**
 * Holds if a neutral model exists for `c` of kind `kind` and with provenance `provenance`.
 * Note: Neutral models have not been implemented for Javascript.
 */
predicate neutralElement(NeutralCallableBase c, string kind, string provenance) { none() }

DataFlowCallable inject(SummarizedCallable c) { result.asLibraryCallable() = c }

/** Gets the parameter position representing a callback itself, if any. */
ArgumentPosition callbackSelfParameterPosition() { result.isFunctionSelfReference() }

/** Gets the synthesized data-flow call for `receiver`. */
SummaryCall summaryDataFlowCall(Private::SummaryNode receiver) { receiver = result.getReceiver() }

/** Gets the type of content `c`. */
DataFlowType getContentType(ContentSet c) { result = TAnyType() and exists(c) }

/** Gets the type of the parameter at the given position. */
bindingset[c, pos]
DataFlowType getParameterType(SummarizedCallable c, ParameterPosition pos) {
  // TODO: we could assign a more precise type to the function self-reference parameter
  result = TAnyType() and exists(c) and exists(pos)
}

/** Gets the return type of kind `rk` for callable `c`. */
bindingset[c, rk]
DataFlowType getReturnType(SummarizedCallable c, ReturnKind rk) {
  result = TAnyType() and exists(c) and exists(rk)
}

/**
 * Gets the type of the `i`th parameter in a synthesized call that targets a
 * callback of type `t`.
 */
bindingset[t, pos]
DataFlowType getCallbackParameterType(DataFlowType t, ArgumentPosition pos) {
  result = TAnyType() and exists(t) and exists(pos)
}

/**
 * Gets the return type of kind `rk` in a synthesized call that targets a
 * callback of type `t`.
 */
DataFlowType getCallbackReturnType(DataFlowType t, ReturnKind rk) {
  result = TAnyType() and exists(t) and exists(rk)
}

/**
 * Holds if an external flow summary exists for `c` with input specification
 * `input`, output specification `output`, kind `kind`, and provenance `provenance`.
 */
predicate summaryElement(
  FlowSummary::SummarizedCallable c, string input, string output, string kind, string provenance
) {
  exists(boolean preservesValue |
    c.propagatesFlowExt(input, output, preservesValue) and
    (if preservesValue = true then kind = "value" else kind = "taint") and
    provenance = "manual"
  )
}

/**
 * Holds if a neutral summary model exists for `c` with provenance `provenance`,
 * which means that there is no flow through `c`.
 * Note. Neutral models have not been implemented for JS.
 */
predicate neutralSummaryElement(FlowSummary::SummarizedCallable c, string provenance) { none() }

pragma[inline]
private Private::SummaryComponent makeContentComponents(
  Private::AccessPathToken token, string name, ContentSet contents
) {
  token.getName() = name and
  result = Private::SummaryComponent::content(contents)
  or
  token.getName() = "With" + name and
  result = Private::SummaryComponent::withContent(contents)
  or
  token.getName() = "Without" + name and
  result = Private::SummaryComponent::withoutContent(contents)
}

pragma[inline]
private Private::SummaryComponent makePropertyContentComponents(
  Private::AccessPathToken token, string name, PropertyName content
) {
  result = makeContentComponents(token, name, ContentSet::property(content))
}

/**
 * Gets the content set corresponding to `Awaited[arg]`.
 */
private ContentSet getPromiseContent(string arg) {
  arg = "value" and result = ContentSet::promiseValue()
  or
  arg = "error" and result = ContentSet::promiseError()
}

pragma[nomagic]
private predicate positionName(ParameterPosition pos, string operand) {
  operand = pos.asPositional().toString()
  or
  pos.isThis() and operand = "this"
  or
  pos.isFunctionSelfReference() and operand = "function"
  or
  pos.isArgumentsArray() and operand = "arguments-array"
  or
  operand = pos.asPositionalLowerBound() + ".."
}

/**
 * Holds if `operand` desugars to the given `pos`. Only used for parsing.
 */
bindingset[operand]
private predicate desugaredPositionName(ParameterPosition pos, string operand) {
  operand = "any" and
  pos.asPositionalLowerBound() = 0
  or
  pos.asPositional() = AccessPathSyntax::parseInt(operand) // parse closed intervals
}

bindingset[operand]
private ParameterPosition parsePosition(string operand) {
  positionName(result, operand) or desugaredPositionName(result, operand)
}

/**
 * Gets the summary component for specification component `c`, if any.
 *
 * This covers all the JS-specific components of a flow summary.
 */
Private::SummaryComponent interpretComponentSpecific(Private::AccessPathToken c) {
  c.getName() = "Argument" and
  result = Private::SummaryComponent::argument(parsePosition(c.getAnArgument()))
  or
  c.getName() = "Parameter" and
  result = Private::SummaryComponent::parameter(parsePosition(c.getAnArgument()))
  or
  result = makePropertyContentComponents(c, "Member", c.getAnArgument())
  or
  result = makeContentComponents(c, "Awaited", getPromiseContent(c.getAnArgument()))
  or
  c.getNumArgument() = 0 and
  result = makeContentComponents(c, "ArrayElement", ContentSet::arrayElement())
  or
  c.getAnArgument() = "?" and
  result = makeContentComponents(c, "ArrayElement", ContentSet::arrayElementUnknown())
  or
  exists(int n |
    n = c.getAnArgument().toInt() and
    result = makeContentComponents(c, "ArrayElement", ContentSet::arrayElementKnown(n))
    or
    // ArrayElement[n!] refers to index n, and never the unknown content
    c.getAnArgument().regexpCapture("(\\d+)!", 1).toInt() = n and
    result = makePropertyContentComponents(c, "ArrayElement", n.toString())
    or
    // ArrayElement[n..] refers to index n or greater
    n = AccessPathSyntax::parseLowerBound(c.getAnArgument()) and
    result = makeContentComponents(c, "ArrayElement", ContentSet::arrayElementLowerBoundFromInt(n))
  )
  or
  c.getNumArgument() = 0 and
  result = makeContentComponents(c, "SetElement", ContentSet::setElement())
  or
  c.getNumArgument() = 0 and
  result = makeContentComponents(c, "IteratorElement", ContentSet::iteratorElement())
  or
  c.getNumArgument() = 0 and
  result = makeContentComponents(c, "IteratorError", ContentSet::iteratorError())
  or
  c.getNumArgument() = 0 and
  result = makeContentComponents(c, "MapKey", ContentSet::mapKey())
  or
  //
  // Note: although it is supported internally, we currently do not expose a syntax for MapValue with a known key
  //
  c.getNumArgument() = 0 and
  result = makeContentComponents(c, "MapValue", ContentSet::mapValueAll())
  or
  c.getName() = "ReturnValue" and
  c.getAnArgument() = "exception" and
  result = Private::SummaryComponent::return(MkExceptionalReturnKind())
  or
  // Awaited is mapped down to a combination steps that handle coercion and promise-flattening.
  c.getName() = "Awaited" and
  c.getNumArgument() = 0 and
  result = Private::SummaryComponent::content(MkAwaited())
  or
  c.getName() = "AnyMemberDeep" and
  c.getNumArgument() = 0 and
  result = Private::SummaryComponent::content(MkAnyPropertyDeep())
  or
  c.getName() = "ArrayElementDeep" and
  c.getNumArgument() = 0 and
  result = Private::SummaryComponent::content(MkArrayElementDeep())
}

private string encodeContentAux(ContentSet cs, string arg) {
  cs = ContentSet::arrayElement() and
  result = "ArrayElement" and
  arg = ""
  or
  cs = ContentSet::arrayElementUnknown() and
  result = "ArrayElement" and
  arg = "?"
  or
  exists(int n |
    cs = ContentSet::arrayElementLowerBound(n) and
    result = "ArrayElement" and
    arg = n + ".." and
    n > 0 // n=0 is just 'ArrayElement'
    or
    cs = ContentSet::arrayElementKnown(n) and
    result = "ArrayElement" and
    arg = n.toString()
    or
    n = cs.asPropertyName().toInt() and
    n >= 0 and
    result = "ArrayElement" and
    arg = n + "!"
  )
  or
  arg = "" and
  (
    cs = ContentSet::mapValueAll() and result = "MapValue"
    or
    cs = ContentSet::mapKey() and result = "MapKey"
    or
    cs = ContentSet::setElement() and result = "SetElement"
    or
    cs = ContentSet::iteratorElement() and result = "IteratorElement"
    or
    cs = ContentSet::iteratorError() and result = "IteratorError"
  )
  or
  cs = getPromiseContent(arg) and
  result = "Awaited"
  or
  cs = MkAwaited() and result = "Awaited" and arg = ""
}

/**
 * Gets the textual representation of content `cs` used in MaD.
 *
 * `arg` will be printed in square brackets (`[]`) after the result, unless
 * `arg` is the empty string.
 */
string encodeContent(ContentSet cs, string arg) {
  result = encodeContentAux(cs, arg)
  or
  not exists(encodeContentAux(cs, _)) and
  result = "Member" and
  arg = cs.asSingleton().toString()
}

/** Gets the textual representation of a parameter position in the format used for flow summaries. */
string encodeParameterPosition(ParameterPosition pos) {
  positionName(pos, result) and result != "any"
}

/** Gets the textual representation of an argument position in the format used for flow summaries. */
string encodeArgumentPosition(ArgumentPosition pos) {
  positionName(pos, result) and result != "any"
}

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
ReturnKind getStandardReturnValueKind() { result = MkNormalReturnKind() }

/** Holds if input specification component `c` needs a reference. */
predicate inputNeedsReferenceSpecific(string c) { none() }

/** Holds if output specification component `c` needs a reference. */
predicate outputNeedsReferenceSpecific(string c) { none() }

/** Gets the return kind corresponding to specification `"ReturnValue"`. */
MkNormalReturnKind getReturnValueKind() { any() }

/**
 * All definitions in this module are required by the shared implementation
 * (for source/sink interpretation), but they are unused for JS, where
 * we rely on API graphs instead.
 */
private module UnusedSourceSinkInterpretation {
  /**
   * Holds if an external source specification exists for `n` with output specification
   * `output`, kind `kind`, and provenance `provenance`.
   */
  predicate sourceElement(AstNode n, string output, string kind, string provenance) { none() }

  /**
   * Holds if an external sink specification exists for `n` with input specification
   * `input`, kind `kind` and provenance `provenance`.
   */
  predicate sinkElement(AstNode n, string input, string kind, string provenance) { none() }

  class SourceOrSinkElement = AstNode;

  /** An entity used to interpret a source/sink specification. */
  class InterpretNode extends AstNode {
    /** Gets the element that this node corresponds to, if any. */
    SourceOrSinkElement asElement() { none() }

    /** Gets the data-flow node that this node corresponds to, if any. */
    Node asNode() { none() }

    /** Gets the call that this node corresponds to, if any. */
    DataFlowCall asCall() { none() }

    /** Gets the callable that this node corresponds to, if any. */
    DataFlowCallable asCallable() { none() }

    /** Gets the target of this call, if any. */
    StmtContainer getCallTarget() { none() }
  }

  /** Provides additional sink specification logic. */
  predicate interpretOutputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }

  /** Provides additional source specification logic. */
  predicate interpretInputSpecific(string c, InterpretNode mid, InterpretNode node) { none() }
}

import UnusedSourceSinkInterpretation

/** Gets the argument position obtained by parsing `X` in `Parameter[X]`. */
bindingset[s]
ArgumentPosition parseParamBody(string s) {
  s = "this" and result.isThis()
  or
  s = "function" and result.isFunctionSelfReference()
  or
  result.asPositional() = AccessPathSyntax::parseInt(s)
}

/** Gets the parameter position obtained by parsing `X` in `Argument[X]`. */
bindingset[s]
ParameterPosition parseArgBody(string s) {
  result = parseParamBody(s) // Currently these are identical
}

private module FlowSummaryStepInput implements Private::StepsInputSig {
  DataFlowCall getACall(SummarizedCallable sc) {
    exists(LibraryCallable callable | callable = sc |
      result.asOrdinaryCall() = [callable.getACall(), callable.getACallSimple()]
    )
  }
}

module Steps = Private::Steps<FlowSummaryStepInput>;

/**
 * Gets the textual representation of return kind `rk` used in MaD.
 *
 * `arg` will be printed in square brackets (`[]`) after the result, unless
 * `arg` is the empty string.
 */
string encodeReturn(ReturnKind rk, string arg) {
  result = "ReturnValue" and
  (
    rk = MkNormalReturnKind() and arg = ""
    or
    rk = MkExceptionalReturnKind() and arg = "exception"
  )
}

/**
 * Gets the textual representation of without-content `c` used in MaD.
 *
 * `arg` will be printed in square brackets (`[]`) after the result, unless
 * `arg` is the empty string.
 */
string encodeWithoutContent(ContentSet c, string arg) { result = "Without" + encodeContent(c, arg) }

/**
 * Gets the textual representation of with-content `c` used in MaD.
 *
 * `arg` will be printed in square brackets (`[]`) after the result, unless
 * `arg` is the empty string.
 */
string encodeWithContent(ContentSet c, string arg) { result = "With" + encodeContent(c, arg) }

/**
 * Gets a parameter position corresponding to the unknown token `token`.
 *
 * The token is unknown because it could not be reverse-encoded using the
 * `encodeParameterPosition` predicate. This is useful for example when a
 * single token gives rise to multiple parameter positions, such as ranges
 * `0..n`.
 */
bindingset[token]
ParameterPosition decodeUnknownParameterPosition(AccessPathSyntax::AccessPathTokenBase token) {
  none()
}

/**
 * Gets an argument position corresponding to the unknown token `token`.
 *
 * The token is unknown because it could not be reverse-encoded using the
 * `encodeArgumentPosition` predicate. This is useful for example when a
 * single token gives rise to multiple argument positions, such as ranges
 * `0..n`.
 */
bindingset[token]
ArgumentPosition decodeUnknownArgumentPosition(AccessPathSyntax::AccessPathTokenBase token) {
  none()
}

/**
 * Gets a content corresponding to the unknown token `token`.
 *
 * The token is unknown because it could not be reverse-encoded using the
 * `encodeContent` predicate.
 */
bindingset[token]
ContentSet decodeUnknownContent(AccessPathSyntax::AccessPathTokenBase token) { none() }

/**
 * Gets a return kind corresponding to the unknown token `token`.
 *
 * The token is unknown because it could not be reverse-encoded using the
 * `encodeReturn` predicate.
 */
bindingset[token]
ReturnKind decodeUnknownReturn(AccessPathSyntax::AccessPathTokenBase token) { none() }

/**
 * Gets a without-content corresponding to the unknown token `token`.
 *
 * The token is unknown because it could not be reverse-encoded using the
 * `encodeWithoutContent` predicate.
 */
bindingset[token]
ContentSet decodeUnknownWithoutContent(AccessPathSyntax::AccessPathTokenBase token) { none() }

/**
 * Gets a with-content corresponding to the unknown token `token`.
 *
 * The token is unknown because it could not be reverse-encoded using the
 * `encodeWithContent` predicate.
 */
bindingset[token]
ContentSet decodeUnknownWithContent(AccessPathSyntax::AccessPathTokenBase token) { none() }
