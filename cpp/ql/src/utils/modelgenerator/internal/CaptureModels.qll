/**
 * Provides predicates related to capturing summary models of the Standard or a 3rd party library.
 */

private import cpp
private import semmle.code.cpp.ir.IR
private import semmle.code.cpp.dataflow.ExternalFlow as ExternalFlow
private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon
private import semmle.code.cpp.ir.dataflow.internal.DataFlowImplSpecific
private import semmle.code.cpp.ir.dataflow.internal.DataFlowPrivate as DataFlowPrivate
private import semmle.code.cpp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.code.cpp.ir.dataflow.internal.TaintTrackingImplSpecific
private import semmle.code.cpp.dataflow.new.TaintTracking
private import codeql.mad.modelgenerator.internal.ModelGeneratorImpl

module ModelGeneratorInput implements ModelGeneratorInputSig<Location, CppDataFlow> {
  class Type = DataFlowPrivate::DataFlowType;

  // Note: This also includes `this`
  class Parameter = DataFlow::ParameterNode;

  class Callable = Declaration;

  class NodeExtended extends DataFlow::Node {
    Callable getAsExprEnclosingCallable() { result = this.asExpr().getEnclosingDeclaration() }
  }

  Parameter asParameter(NodeExtended n) { result = n }

  Callable getEnclosingCallable(NodeExtended n) {
    result = n.getEnclosingCallable().asSourceCallable()
  }

  Callable getAsExprEnclosingCallable(NodeExtended n) {
    result = n.asExpr().getEnclosingDeclaration()
  }

  /** Gets `api` if it is relevant. */
  private Callable liftedImpl(Callable api) { result = api and relevant(api) }

  private predicate hasManualSummaryModel(Callable api) {
    api = any(FlowSummaryImpl::Public::SummarizedCallable sc | sc.applyManualModel()) or
    api = any(FlowSummaryImpl::Public::NeutralSummaryCallable sc | sc.hasManualModel())
  }

  private predicate hasManualSourceModel(Callable api) {
    api = any(FlowSummaryImpl::Public::NeutralSourceCallable sc | sc.hasManualModel())
  }

  private predicate hasManualSinkModel(Callable api) {
    api = any(FlowSummaryImpl::Public::NeutralSinkCallable sc | sc.hasManualModel())
  }

  /**
   * Holds if `f` is a "private" function.
   *
   * A "private" function does not contribute any models as it is assumed
   * to be an implementation detail of some other "public" function for which
   * we will generate a summary.
   */
  private predicate isPrivate(Function f) {
    f.getNamespace().getParentNamespace*().isAnonymous()
    or
    exists(MemberFunction mf | mf = f |
      mf.isPrivate()
      or
      mf.isProtected()
    )
    or
    f.isStatic()
  }

  private predicate isUninterestingForModels(Callable api) {
    // Note: This also makes all global/static-local variables
    // not relevant (which is good!)
    not api.(Function).hasDefinition()
    or
    isPrivate(api)
    or
    api instanceof Destructor
    or
    api = any(LambdaExpression lambda).getLambdaFunction()
    or
    api.isFromUninstantiatedTemplate(_)
  }

  private predicate relevant(Callable api) {
    api.fromSource() and
    not isUninterestingForModels(api)
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

  class SourceOrSinkTargetApi extends Callable {
    SourceOrSinkTargetApi() { relevant(this) }
  }

  class SinkTargetApi extends SourceOrSinkTargetApi {
    SinkTargetApi() { not hasManualSinkModel(this) }
  }

  class SourceTargetApi extends SourceOrSinkTargetApi {
    SourceTargetApi() { not hasManualSourceModel(this) }
  }

  class InstanceParameterNode extends DataFlow::ParameterNode {
    InstanceParameterNode() {
      DataFlowPrivate::nodeHasInstruction(this,
        any(InitializeParameterInstruction i | i.hasIndex(-1)), 1)
    }
  }

  private predicate isFinalMemberFunction(MemberFunction mf) {
    mf.isFinal()
    or
    mf.getDeclaringType().isFinal()
  }

  /**
   * Holds if the summary generated for `c` should also apply to overrides
   * of `c`.
   */
  private string isExtensible(Callable c) {
    if isFinalMemberFunction(c) then result = "false" else result = "true"
  }

  /**
   * Gets the string representing the list of template parameters declared
   * by `template`.
   *
   * `template` must either be:
   * - An uninstantiated template, or
   * - A declaration that is not from a template instantiation.
   */
  private string templateParams(Declaration template) {
    exists(string params |
      params =
        concat(int i |
          |
          template.getTemplateArgument(i).(TypeTemplateParameter).getName(), "," order by i
        )
    |
      if params = "" then result = "" else result = "<" + params + ">"
    )
  }

  /**
   * Gets the string representing the list of parameters declared
   * by `functionTemplate`.
   *
   * `functionTemplate` must either be:
   * - An uninstantiated template, or
   * - A declaration that is not from a template instantiation.
   */
  private string params(Function functionTemplate) {
    exists(string params |
      params =
        concat(int i |
          |
          ExternalFlow::getParameterTypeWithoutTemplateArguments(functionTemplate, i, true), ","
          order by
            i
        ) and
      result = "(" + params + ")"
    )
  }

  /**
   * Holds if the callable `c` is:
   * - In the namespace represented by `namespace`, and
   * - Has a declaring type represented by `type`, and
   * - Has the name `name`, and
   * - Has a list of parameters represented by `params`
   *
   * This is the predicate that computes the columns that it put into the MaD
   * row for `callable`.
   */
  private predicate qualifiedName(
    Callable callable, string namespace, string type, string name, string params
  ) {
    exists(
      Function functionTemplate, string typeWithoutTemplateArgs, string nameWithoutTemplateArgs
    |
      functionTemplate = ExternalFlow::getFullyTemplatedFunction(callable) and
      functionTemplate.hasQualifiedName(namespace, typeWithoutTemplateArgs, nameWithoutTemplateArgs) and
      nameWithoutTemplateArgs = functionTemplate.getName() and
      name = nameWithoutTemplateArgs + templateParams(functionTemplate) and
      params = params(functionTemplate)
    |
      exists(Class classTemplate |
        classTemplate = functionTemplate.getDeclaringType() and
        type = typeWithoutTemplateArgs + templateParams(classTemplate)
      )
      or
      not exists(functionTemplate.getDeclaringType()) and
      type = ""
    )
  }

  predicate isRelevantType(Type t) { any() }

  Type getUnderlyingContentType(DataFlow::ContentSet c) {
    result = c.(DataFlow::FieldContent).getField().getUnspecifiedType() or
    result = c.(DataFlow::UnionContent).getUnion().getUnspecifiedType()
  }

  string qualifierString() { result = "Argument[-1]" }

  private predicate parameterContentAccessImpl(Parameter p, string argument) {
    exists(int indirectionIndex, int argumentIndex, DataFlowPrivate::Position pos |
      p.isSourceParameterOf(_, pos) and
      pos.getArgumentIndex() = argumentIndex and
      argumentIndex != -1 and // handled elsewhere
      pos.getIndirectionIndex() = indirectionIndex
    |
      indirectionIndex = 0 and
      argument = "Argument[" + argumentIndex + "]"
      or
      indirectionIndex > 0 and
      argument = "Argument[" + DataFlow::repeatStars(indirectionIndex) + argumentIndex + "]"
    )
  }

  string parameterAccess(Parameter p) { parameterContentAccessImpl(p, result) }

  string parameterContentAccess(Parameter p) { parameterContentAccessImpl(p, result) }

  bindingset[c]
  string paramReturnNodeAsOutput(Callable c, DataFlowPrivate::Position pos) {
    exists(Parameter p |
      p.isSourceParameterOf(c, pos) and
      result = parameterAccess(p)
    )
    or
    pos.getArgumentIndex() = -1 and
    result = qualifierString() and
    pos.getIndirectionIndex() = 1
  }

  bindingset[c]
  string paramReturnNodeAsContentOutput(Callable c, DataFlowPrivate::ParameterPosition pos) {
    result = paramReturnNodeAsOutput(c, pos)
  }

  pragma[nomagic]
  Callable returnNodeEnclosingCallable(DataFlow::Node ret) {
    result = DataFlowImplCommon::getNodeEnclosingCallable(ret).asSourceCallable()
  }

  /** Holds if this instance access is to an enclosing instance of type `t`. */
  pragma[nomagic]
  private predicate isEnclosingInstanceAccess(DataFlowPrivate::ReturnNode n, Class t) {
    n.getKind().isIndirectReturn(-1) and
    t = n.getType().stripType() and
    t != n.getEnclosingCallable().asSourceCallable().(Function).getDeclaringType()
  }

  pragma[nomagic]
  predicate isOwnInstanceAccessNode(DataFlowPrivate::ReturnNode node) {
    node.getKind().isIndirectReturn(-1) and
    not isEnclosingInstanceAccess(node, _)
  }

  predicate sinkModelSanitizer(DataFlow::Node node) { none() }

  predicate apiSource(DataFlow::Node source) {
    DataFlowPrivate::nodeHasOperand(source, any(DataFlow::FieldAddress fa), 1)
    or
    source instanceof DataFlow::ParameterNode
  }

  string getInputArgument(DataFlow::Node source) {
    exists(DataFlowPrivate::Position pos, int argumentIndex, int indirectionIndex |
      source.(DataFlow::ParameterNode).isParameterOf(_, pos) and
      argumentIndex = pos.getArgumentIndex() and
      indirectionIndex = pos.getIndirectionIndex() and
      result = "Argument[" + DataFlow::repeatStars(indirectionIndex) + argumentIndex + "]"
    )
    or
    DataFlowPrivate::nodeHasOperand(source, any(DataFlow::FieldAddress fa), 1) and
    result = qualifierString()
  }

  string getReturnValueString(DataFlowPrivate::ReturnKind k) {
    k.isNormalReturn() and
    exists(int indirectionIndex | indirectionIndex = k.getIndirectionIndex() |
      indirectionIndex = 0 and
      result = "ReturnValue"
      or
      indirectionIndex > 0 and
      result = "ReturnValue[" + DataFlow::repeatStars(indirectionIndex) + "]"
    )
  }

  predicate irrelevantSourceSinkApi(Callable source, SourceTargetApi api) { none() }

  bindingset[kind]
  predicate isRelevantSourceKind(string kind) { any() }

  bindingset[kind]
  predicate isRelevantSinkKind(string kind) { any() }

  predicate containerContent(DataFlow::ContentSet cs) { cs instanceof DataFlow::ElementContent }

  predicate isAdditionalContentFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    TaintTracking::defaultAdditionalTaintStep(node1, node2, _) and
    not exists(DataFlow::Content f |
      DataFlowPrivate::readStep(node1, f, node2) and containerContent(f)
    )
  }

  predicate isField(DataFlow::ContentSet cs) {
    exists(DataFlow::Content c | cs.isSingleton(c) |
      c instanceof DataFlow::FieldContent or
      c instanceof DataFlow::UnionContent
    )
  }

  predicate isCallback(DataFlow::ContentSet c) { none() }

  string getSyntheticName(DataFlow::ContentSet c) {
    exists(Field f |
      not f.isPublic() and
      f = c.(DataFlow::FieldContent).getField() and
      result = f.getName()
    )
  }

  string printContent(DataFlow::ContentSet c) {
    exists(int indirectionIndex, string name, string kind |
      exists(DataFlow::UnionContent uc |
        c.isSingleton(uc) and
        name = uc.getUnion().getName() and
        indirectionIndex = uc.getIndirectionIndex() and
        // Note: We don't actually support the union string in MaD, but we should do that eventually
        kind = "Union["
      )
      or
      exists(DataFlow::FieldContent fc |
        c.isSingleton(fc) and
        name = fc.getField().getName() and
        indirectionIndex = fc.getIndirectionIndex() and
        kind = "Field["
      )
    |
      result = kind + DataFlow::repeatStars(indirectionIndex) + name + "]"
    )
    or
    exists(DataFlow::ElementContent ec |
      c.isSingleton(ec) and
      result = "Element[" + ec.getIndirectionIndex() + "]"
    )
  }

  predicate isUninterestingForDataFlowModels(Callable api) { none() }

  predicate isUninterestingForHeuristicDataFlowModels(Callable api) {
    isUninterestingForDataFlowModels(api)
  }

  string partialModelRow(Callable api, int i) {
    i = 0 and qualifiedName(api, result, _, _, _) // namespace
    or
    i = 1 and qualifiedName(api, _, result, _, _) // type
    or
    i = 2 and result = isExtensible(api) // extensible
    or
    i = 3 and qualifiedName(api, _, _, result, _) // name
    or
    i = 4 and qualifiedName(api, _, _, _, result) // parameters
    or
    i = 5 and result = "" and exists(api) // ext
  }

  string partialNeutralModelRow(Callable api, int i) {
    i = 0 and qualifiedName(api, result, _, _, _) // namespace
    or
    i = 1 and qualifiedName(api, _, result, _, _) // type
    or
    i = 2 and qualifiedName(api, _, _, result, _) // name
    or
    i = 3 and qualifiedName(api, _, _, _, result) // parameters
  }

  predicate sourceNode = ExternalFlow::sourceNode/2;

  predicate sinkNode = ExternalFlow::sinkNode/2;
}

import MakeModelGenerator<Location, CppDataFlow, CppTaintTracking, ModelGeneratorInput>
