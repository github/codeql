/**
 * Provides classes and predicates for defining flow summaries.
 */

private import python
private import codeql.dataflow.internal.FlowSummaryImpl
private import codeql.dataflow.internal.AccessPathSyntax as AccessPath
private import DataFlowImplSpecific as DataFlowImplSpecific
private import DataFlowImplSpecific::Private
private import DataFlowImplSpecific::Public

module Input implements InputSig<Location, DataFlowImplSpecific::PythonDataFlow> {
  private import codeql.util.Void

  class SummarizedCallableBase = string;

  class SourceBase = Void;

  class SinkBase = Void;

  ArgumentPosition callbackSelfParameterPosition() { result.isLambdaSelf() }

  ReturnKind getStandardReturnValueKind() { any() }

  string encodeParameterPosition(ParameterPosition pos) {
    pos.isSelf() and result = "self"
    or
    pos.isLambdaSelf() and
    result = "lambda-self"
    or
    exists(int i |
      pos.isPositional(i) and
      result = i.toString()
    )
    or
    exists(int i |
      pos.isPositionalLowerBound(i) and
      result = i + ".."
    )
    or
    exists(string name |
      pos.isKeyword(name) and
      result = name + ":"
    )
  }

  string encodeArgumentPosition(ArgumentPosition pos) {
    pos.isSelf() and result = "self"
    or
    pos.isLambdaSelf() and
    result = "lambda-self"
    or
    exists(int i |
      pos.isPositional(i) and
      result = i.toString()
    )
    or
    exists(string name |
      pos.isKeyword(name) and
      result = name + ":"
    )
  }

  string encodeContent(ContentSet cs, string arg) {
    cs = TListElementContent() and result = "ListElement" and arg = ""
    or
    cs = TSetElementContent() and result = "SetElement" and arg = ""
    or
    exists(int index |
      cs = TTupleElementContent(index) and result = "TupleElement" and arg = index.toString()
    )
    or
    exists(string key |
      cs = TDictionaryElementContent(key) and result = "DictionaryElement" and arg = key
    )
    or
    cs = TDictionaryElementAnyContent() and result = "DictionaryElementAny" and arg = ""
    or
    exists(string attr | cs = TAttributeContent(attr) and result = "Attribute" and arg = attr)
  }

  bindingset[token]
  ParameterPosition decodeUnknownParameterPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Argument[x..y]` ranges
    token.getName() = "Argument" and
    result.isPositional(AccessPath::parseInt(token.getAnArgument()))
  }

  bindingset[token]
  ArgumentPosition decodeUnknownArgumentPosition(AccessPath::AccessPathTokenBase token) {
    // needed to support `Parameter[x..y]` ranges
    token.getName() = "Parameter" and
    result.isPositional(AccessPath::parseInt(token.getAnArgument()))
  }
}

private import Make<Location, DataFlowImplSpecific::PythonDataFlow, Input> as Impl

private module StepsInput implements Impl::Private::StepsInputSig {
  DataFlowCall getACall(Public::SummarizedCallable sc) {
    result =
      TPotentialLibraryCall([
          sc.(LibraryCallable).getACall().asCfgNode(),
          sc.(LibraryCallable).getACallSimple().asCfgNode()
        ])
  }

  Node getSourceNode(Input::SourceBase source, Impl::Private::SummaryComponent sc) { none() }

  Node getSinkNode(Input::SinkBase sink, Impl::Private::SummaryComponent sc) { none() }
}

module Private {
  import Impl::Private

  module Steps = Impl::Private::Steps<StepsInput>;

  /**
   * Provides predicates for constructing summary components.
   */
  module SummaryComponent {
    private import Impl::Private::SummaryComponent as SC

    predicate parameter = SC::parameter/1;

    predicate argument = SC::argument/1;

    predicate content = SC::content/1;

    predicate withoutContent = SC::withoutContent/1;

    predicate withContent = SC::withContent/1;

    /** Gets a summary component that represents a list element. */
    SummaryComponent listElement() { result = content(any(ListElementContent c)) }

    /** Gets a summary component that represents a set element. */
    SummaryComponent setElement() { result = content(any(SetElementContent c)) }

    /** Gets a summary component that represents a tuple element. */
    SummaryComponent tupleElement(int index) {
      exists(TupleElementContent c | c.getIndex() = index and result = content(c))
    }

    /** Gets a summary component that represents a dictionary element. */
    SummaryComponent dictionaryElement(string key) {
      exists(DictionaryElementContent c | c.getKey() = key and result = content(c))
    }

    /** Gets a summary component that represents a dictionary element at any key. */
    SummaryComponent dictionaryElementAny() { result = content(any(DictionaryElementAnyContent c)) }

    /** Gets a summary component that represents an attribute element. */
    SummaryComponent attribute(string attr) {
      exists(AttributeContent c | c.getAttribute() = attr and result = content(c))
    }

    /** Gets a summary component that represents the return value of a call. */
    SummaryComponent return() { result = SC::return(any(ReturnKind rk)) }
  }

  /**
   * Provides predicates for constructing stacks of summary components.
   */
  module SummaryComponentStack {
    private import Impl::Private::SummaryComponentStack as SCS

    predicate singleton = SCS::singleton/1;

    predicate push = SCS::push/2;

    predicate argument = SCS::argument/1;

    /** Gets a singleton stack representing the return value of a call. */
    SummaryComponentStack return() { result = singleton(SummaryComponent::return()) }
  }
}

module Public = Impl::Public;

module ParsePositions {
  private import Private

  private predicate isParamBody(string body) {
    exists(AccessPathToken tok |
      tok.getName() = "Parameter" and
      body = tok.getAnArgument()
    )
  }

  private predicate isArgBody(string body) {
    exists(AccessPathToken tok |
      tok.getName() = "Argument" and
      body = tok.getAnArgument()
    )
  }

  predicate isParsedPositionalParameterPosition(string c, int i) {
    isParamBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedKeywordParameterPosition(string c, string paramName) {
    isParamBody(c) and
    c = paramName + ":"
  }

  predicate isParsedPositionalArgumentPosition(string c, int i) {
    isArgBody(c) and
    i = AccessPath::parseInt(c)
  }

  predicate isParsedArgumentLowerBoundPosition(string c, int i) {
    isArgBody(c) and
    i = AccessPath::parseLowerBound(c)
  }

  predicate isParsedKeywordArgumentPosition(string c, string argName) {
    isArgBody(c) and
    c = argName + ":"
  }
}
