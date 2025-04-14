/**
 * Provides JS specific classes and predicates for defining flow summaries.
 */

private import javascript
private import semmle.javascript.dataflow.internal.DataFlowPrivate
private import semmle.javascript.dataflow.internal.Contents::Private
private import sharedlib.DataFlowImplCommon
private import sharedlib.FlowSummaryImpl::Private as Private
private import sharedlib.FlowSummaryImpl::Public
private import codeql.dataflow.internal.AccessPathSyntax as AccessPathSyntax
private import semmle.javascript.internal.flow_summaries.ExceptionFlow

/**
 * A class of callables that are candidates for flow summary modeling.
 */
class SummarizedCallableBase = string;

class SourceBase extends Unit {
  SourceBase() { none() }
}

class SinkBase extends Unit {
  SinkBase() { none() }
}

/** Gets the parameter position representing a callback itself, if any. */
ArgumentPosition callbackSelfParameterPosition() { result.isFunctionSelfReference() }

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
  or
  cs = MkAnyPropertyDeep() and result = "AnyMemberDeep" and arg = ""
  or
  cs = MkArrayElementDeep() and result = "ArrayElementDeep" and arg = ""
  or
  cs = MkOptionalStep(arg) and result = "OptionalStep"
  or
  cs = MkOptionalBarrier(arg) and result = "OptionalBarrier"
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
ReturnKind getStandardReturnValueKind() { result = MkNormalReturnKind() and Stage::ref() }

private module FlowSummaryStepInput implements Private::StepsInputSig {
  DataFlowCall getACall(SummarizedCallable sc) {
    exists(LibraryCallable callable | callable = sc |
      result.asOrdinaryCall() =
        [
          callable.getACall(), callable.getACallSimple(),
          callable.(LibraryCallableInternal).getACallStage2()
        ]
    )
  }

  DataFlow::Node getSourceNode(SourceBase source, Private::SummaryComponent sc) { none() }

  DataFlow::Node getSinkNode(SinkBase sink, Private::SummaryComponent sc) { none() }
}

module Steps = Private::Steps<FlowSummaryStepInput>;

module RenderSummarizedCallable = Private::RenderSummarizedCallable<FlowSummaryStepInput>;

class AccessPath = Private::AccessPath;

class AccessPathToken = Private::AccessPathToken;

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
  token.getName() = "Argument" and
  desugaredPositionName(result, token.getAnArgument())
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
  token.getName() = "Parameter" and
  desugaredPositionName(result, token.getAnArgument())
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

cached
module Stage {
  cached
  predicate ref() { 1 = 1 }

  cached
  predicate backref() { optionalStep(_, _, _) }
}
