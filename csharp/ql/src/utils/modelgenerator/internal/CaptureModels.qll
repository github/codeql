private import csharp as CS
private import semmle.code.csharp.commons.Util as Util
private import semmle.code.csharp.commons.Collections as Collections
private import semmle.code.csharp.commons.QualifiedName as QualifiedName
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.csharp.dataflow.internal.TaintTrackingPrivate as TaintTrackingPrivate
private import semmle.code.csharp.dataflow.internal.ExternalFlow as ExternalFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import semmle.code.csharp.frameworks.system.linq.Expressions
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.Location
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl

module ModelGeneratorInput implements ModelGeneratorInputSig<Location, CsharpDataFlow> {
  class Type = CS::Type;

  class Parameter = CS::Parameter;

  class Callable = CS::Callable;

  class NodeExtended extends CS::DataFlow::Node {
    Callable getAsExprEnclosingCallable() { result = this.asExpr().getEnclosingCallable() }
  }

  /**
   * Holds if any of the parameters of `api` are `System.Func<>`.
   */
  private predicate isHigherOrder(Callable api) {
    exists(Type t | t = api.getAParameter().getType().getUnboundDeclaration() |
      t instanceof SystemLinqExpressions::DelegateExtType
    )
  }

  private predicate irrelevantAccessor(CS::Accessor a) {
    a.getDeclaration().(CS::Property).isReadWrite()
  }

  private predicate isUninterestingForModels(Callable api) {
    api.getDeclaringType().getNamespace().getFullName() = ""
    or
    api instanceof CS::ConversionOperator
    or
    api instanceof Util::MainMethod
    or
    api instanceof CS::Destructor
    or
    api instanceof CS::AnonymousFunctionExpr
    or
    api.(CS::Constructor).isParameterless()
    or
    exists(Type decl | decl = api.getDeclaringType() |
      decl instanceof SystemObjectClass or
      decl instanceof SystemValueTypeClass
    )
    or
    // Disregard properties that have both a get and a set accessor,
    // which implicitly means auto implemented properties.
    irrelevantAccessor(api)
  }

  private predicate relevant(Callable api) {
    [api.(CS::Modifiable), api.(CS::Accessor).getDeclaration()].isEffectivelyPublic() and
    api.fromSource() and
    api.isUnboundDeclaration() and
    not isUninterestingForModels(api)
  }

  private Callable getARelevantOverrideeOrImplementee(Overridable m) {
    m.overridesOrImplements(result) and relevant(result)
  }

  /**
   * Gets the super implementation of `api` if it is relevant.
   * If such a super implementation does not exist, returns `api` if it is relevant.
   */
  private Callable liftedImpl(Callable api) {
    (
      result = getARelevantOverrideeOrImplementee(api)
      or
      result = api and relevant(api)
    ) and
    not exists(getARelevantOverrideeOrImplementee(result))
  }

  private predicate hasManualSummaryModel(Callable api) {
    api = any(FlowSummaryImpl::Public::SummarizedCallable sc | sc.applyManualModel()) or
    api = any(FlowSummaryImpl::Public::NeutralSummaryCallable sc | sc.hasManualModel())
  }

  private predicate hasManualSourceModel(Callable api) {
    api = any(ExternalFlow::SourceCallable sc | sc.hasManualModel()) or
    api = any(FlowSummaryImpl::Public::NeutralSourceCallable sc | sc.hasManualModel())
  }

  private predicate hasManualSinkModel(Callable api) {
    api = any(ExternalFlow::SinkCallable sc | sc.hasManualModel()) or
    api = any(FlowSummaryImpl::Public::NeutralSinkCallable sc | sc.hasManualModel())
  }

  predicate isUninterestingForDataFlowModels(Callable api) { none() }

  predicate isUninterestingForHeuristicDataFlowModels(Callable api) { isHigherOrder(api) }

  class SourceOrSinkTargetApi extends Callable {
    SourceOrSinkTargetApi() { relevant(this) }
  }

  class SinkTargetApi extends SourceOrSinkTargetApi {
    SinkTargetApi() { not hasManualSinkModel(this) }
  }

  class SourceTargetApi extends SourceOrSinkTargetApi {
    SourceTargetApi() {
      not hasManualSourceModel(this) and
      // Do not generate source models for overridable callables
      // as virtual dispatch implies that too many methods
      // will be considered sources.
      not this.(Overridable).overridesOrImplements(_)
    }
  }

  class SummaryTargetApi extends Callable {
    private Callable lift;

    SummaryTargetApi() {
      lift = liftedImpl(this) and
      not hasManualSummaryModel(lift)
    }

    Callable lift() { result = lift }

    predicate isRelevant() {
      relevant(this) and
      not hasManualSummaryModel(this)
    }
  }

  /**
   * Holds if `t` is a type that is generally used for bulk data in collection types.
   * Eg. char[] is roughly equivalent to string and thus a highly
   * relevant type for model generation.
   */
  private predicate isPrimitiveTypeUsedForBulkData(CS::Type t) {
    t instanceof CS::ByteType or
    t instanceof CS::CharType
  }

  /**
   * Holds if the collection type `ct` is irrelevant for model generation.
   * Collection types where the type of the elements are
   * (1) unknown - are considered relevant.
   * (2) known - at least one the child types should be relevant (a non-simple type
   * or a type used for bulk data)
   */
  private predicate irrelevantCollectionType(CS::Type ct) {
    Collections::isCollectionType(ct) and
    forex(CS::Type child | child = ct.getAChild() |
      child instanceof CS::SimpleType and
      not isPrimitiveTypeUsedForBulkData(child)
    )
  }

  predicate isRelevantType(CS::Type t) {
    not t instanceof CS::SimpleType and
    not t instanceof CS::Enum and
    not t instanceof SystemDateTimeStruct and
    not t instanceof SystemTypeClass and
    not irrelevantCollectionType(t)
  }

  /**
   * Gets the underlying type of the content `c`.
   */
  private CS::Type getUnderlyingContType(DataFlow::Content c) {
    result = c.(DataFlow::FieldContent).getField().getType()
    or
    result = c.(DataFlow::SyntheticFieldContent).getField().getType()
    or
    // Use System.Object as the type of delegate arguments and returns as the content doesn't
    // contain any type information.
    c instanceof DataFlow::DelegateCallArgumentContent and result instanceof ObjectType
    or
    c instanceof DataFlow::DelegateCallReturnContent and result instanceof ObjectType
  }

  Type getUnderlyingContentType(DataFlow::ContentSet c) {
    exists(DataFlow::Content cont |
      c.isSingleton(cont) and
      result = getUnderlyingContType(cont)
    )
    or
    exists(CS::Property p |
      c.isProperty(p) and
      result = p.getType()
    )
  }

  string qualifierString() { result = "Argument[this]" }

  string parameterAccess(CS::Parameter p) {
    if Collections::isCollectionType(p.getType())
    then result = "Argument[" + p.getPosition() + "].Element"
    else result = "Argument[" + p.getPosition() + "]"
  }

  string parameterContentAccess(CS::Parameter p) { result = "Argument[" + p.getPosition() + "]" }

  class InstanceParameterNode = DataFlowPrivate::InstanceParameterNode;

  private signature string parameterAccessSig(Parameter p);

  private module ParamReturnNodeAsOutput<parameterAccessSig/1 getParamAccess> {
    bindingset[c]
    string paramReturnNodeAsOutput(CS::Callable c, ParameterPosition pos) {
      result = getParamAccess(c.getParameter(pos.getPosition()))
      or
      pos.isThisParameter() and
      result = qualifierString()
    }
  }

  bindingset[c]
  string paramReturnNodeAsOutput(CS::Callable c, ParameterPosition pos) {
    result = ParamReturnNodeAsOutput<parameterAccess/1>::paramReturnNodeAsOutput(c, pos)
  }

  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, ParameterPosition pos) {
    result = ParamReturnNodeAsOutput<parameterContentAccess/1>::paramReturnNodeAsOutput(c, pos)
  }

  Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
    result = DataFlowImplCommon::getNodeEnclosingCallable(ret).asCallable(_)
  }

  predicate isOwnInstanceAccessNode(DataFlowPrivate::ReturnNode node) {
    node.asExpr() instanceof CS::ThisAccess
  }

  private predicate isRelevantMemberAccess(DataFlow::Node node) {
    exists(CS::MemberAccess access | access = node.asExpr() |
      access.hasThisQualifier() and
      access.getTarget().isEffectivelyPublic() and
      (
        access instanceof CS::FieldAccess
        or
        access.getTarget().(CS::Property).getSetter().isPublic()
      )
    )
  }

  predicate sinkModelSanitizer(DataFlow::Node node) { none() }

  predicate apiSource(DataFlow::Node source) {
    isRelevantMemberAccess(source) or source instanceof DataFlow::ParameterNode
  }

  private predicate uniquelyCalls(DataFlowCallable dc1, DataFlowCallable dc2) {
    exists(DataFlowCall call |
      dc1 = call.getEnclosingCallable() and
      dc2 = unique(DataFlowCallable dc0 | dc0 = viableCallable(call) | dc0)
    )
  }

  bindingset[dc1, dc2]
  private predicate uniquelyCallsPlus(DataFlowCallable dc1, DataFlowCallable dc2) =
    fastTC(uniquelyCalls/2)(dc1, dc2)

  bindingset[sourceEnclosing, api]
  predicate irrelevantSourceSinkApi(Callable sourceEnclosing, SourceTargetApi api) {
    not exists(DataFlowCallable dc1, DataFlowCallable dc2 |
      uniquelyCallsPlus(dc1, dc2) or dc1 = dc2
    |
      dc1.getUnderlyingCallable() = api and
      dc2.getUnderlyingCallable() = sourceEnclosing
    )
  }

  string getInputArgument(DataFlow::Node source) {
    exists(int pos |
      pos = source.(DataFlow::ParameterNode).getParameter().getPosition() and
      result = "Argument[" + pos + "]"
    )
    or
    source.asExpr() instanceof DataFlowPrivate::FieldOrPropertyAccess and
    result = qualifierString()
  }

  bindingset[kind]
  predicate isRelevantSinkKind(string kind) { any() }

  bindingset[kind]
  predicate isRelevantSourceKind(string kind) { any() }

  predicate containerContent(DataFlow::ContentSet c) { c.isElement() }

  predicate isAdditionalContentFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    TaintTrackingPrivate::defaultAdditionalTaintStep(nodeFrom, nodeTo, _) and
    not nodeTo.asExpr() instanceof CS::ElementAccess and
    not exists(DataFlow::ContentSet c |
      DataFlowPrivate::readStep(nodeFrom, c, nodeTo) and containerContent(c)
    )
  }

  bindingset[d]
  private string getFullyQualifiedName(Declaration d) {
    exists(string qualifier, string name |
      d.hasFullyQualifiedName(qualifier, name) and
      result = QualifiedName::getQualifiedName(qualifier, name)
    )
  }

  predicate isField(DataFlow::ContentSet c) {
    c.isField(_) or c.isSyntheticField(_) or c.isProperty(_)
  }

  predicate isCallback(DataFlow::ContentSet c) {
    c.isDelegateCallArgument(_) or c.isDelegateCallReturn()
  }

  string getSyntheticName(DataFlow::ContentSet c) {
    exists(CS::Field f |
      not f.isEffectivelyPublic() and
      c.isField(f) and
      result = getFullyQualifiedName(f)
    )
    or
    exists(CS::Property p |
      not p.isEffectivelyPublic() and
      c.isProperty(p) and
      result = getFullyQualifiedName(p)
    )
    or
    c.isSyntheticField(result)
  }

  string printContent(DataFlow::ContentSet c) {
    exists(CS::Field f, string name | name = getFullyQualifiedName(f) |
      c.isField(f) and
      f.isEffectivelyPublic() and
      result = "Field[" + name + "]"
    )
    or
    exists(CS::Property p, string name | name = getFullyQualifiedName(p) |
      c.isProperty(p) and
      p.isEffectivelyPublic() and
      result = "Property[" + name + "]"
    )
    or
    result = "SyntheticField[" + getSyntheticName(c) + "]"
    or
    c.isElement() and
    result = "Element"
    or
    exists(int i | c.isDelegateCallArgument(i) and result = "Parameter[" + i + "]")
    or
    c.isDelegateCallReturn() and result = "ReturnValue"
  }

  string partialModelRow(Callable api, int i) {
    i = 0 and ExternalFlow::partialModel(api, result, _, _, _, _) // package
    or
    i = 1 and ExternalFlow::partialModel(api, _, result, _, _, _) // type
    or
    i = 2 and ExternalFlow::partialModel(api, _, _, result, _, _) // extensible
    or
    i = 3 and ExternalFlow::partialModel(api, _, _, _, result, _) // name
    or
    i = 4 and ExternalFlow::partialModel(api, _, _, _, _, result) // parameters
    or
    i = 5 and result = "" and exists(api) // ext
  }

  string partialNeutralModelRow(Callable api, int i) {
    i = 0 and result = partialModelRow(api, 0) // package
    or
    i = 1 and result = partialModelRow(api, 1) // type
    or
    i = 2 and result = partialModelRow(api, 3) // name
    or
    i = 3 and result = partialModelRow(api, 4) // parameters
  }

  predicate sourceNode = ExternalFlow::sourceNode/2;

  predicate sinkNode = ExternalFlow::sinkNode/2;
}

import MakeModelGenerator<Location, CsharpDataFlow, CsharpTaintTracking, ModelGeneratorInput>
