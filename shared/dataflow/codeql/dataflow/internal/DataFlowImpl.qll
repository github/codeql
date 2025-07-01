/**
 * INTERNAL: Do not use.
 *
 * Provides an implementation of global (interprocedural) data flow.
 */
overlay[local?]
module;

private import codeql.util.Unit
private import codeql.util.Option
private import codeql.util.Boolean
private import codeql.util.Location
private import codeql.dataflow.DataFlow
private import DataFlowImplStage1

module MakeImpl<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import DataFlowMake<Location, Lang>
  private import MakeImplStage1<Location, Lang>
  private import DataFlowImplCommon::MakeImplCommon<Location, Lang>
  private import DataFlowImplCommonPublic
  private import Aliases

  /**
   * An input configuration for data flow using flow state. This signature equals
   * `StateConfigSig`, but requires explicit implementation of all predicates.
   */
  signature module FullStateConfigSig {
    bindingset[this]
    class FlowState;

    /**
     * Holds if `source` is a relevant data flow source with the given initial
     * `state`.
     */
    predicate isSource(Node source, FlowState state);

    /**
     * Holds if `sink` is a relevant data flow sink accepting `state`.
     */
    predicate isSink(Node sink, FlowState state);

    /**
     * Holds if `sink` is a relevant data flow sink for any state.
     */
    predicate isSink(Node sink);

    /**
     * Holds if data flow through `node` is prohibited. This completely removes
     * `node` from the data flow graph.
     */
    predicate isBarrier(Node node);

    /**
     * Holds if data flow through `node` is prohibited when the flow state is
     * `state`.
     */
    predicate isBarrier(Node node, FlowState state);

    /** Holds if data flow into `node` is prohibited. */
    predicate isBarrierIn(Node node);

    /** Holds if data flow into `node` is prohibited when the target flow state is `state`. */
    predicate isBarrierIn(Node node, FlowState state);

    /** Holds if data flow out of `node` is prohibited. */
    predicate isBarrierOut(Node node);

    /** Holds if data flow out of `node` is prohibited when the originating flow state is `state`. */
    predicate isBarrierOut(Node node, FlowState state);

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    predicate isAdditionalFlowStep(Node node1, Node node2, string model);

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     * This step is only applicable in `state1` and updates the flow state to `state2`.
     */
    predicate isAdditionalFlowStep(
      Node node1, FlowState state1, Node node2, FlowState state2, string model
    );

    /**
     * Holds if an arbitrary number of implicit read steps of content `c` may be
     * taken at `node`.
     */
    predicate allowImplicitRead(Node node, ContentSet c);

    /**
     * Holds if `node` should never be skipped over in the `PathGraph` and in path
     * explanations.
     */
    predicate neverSkip(Node node);

    /**
     * Gets the virtual dispatch branching limit when calculating field flow.
     * This can be overridden to a smaller value to improve performance (a
     * value of 0 disables field flow), or a larger value to get more results.
     */
    int fieldFlowBranchLimit();

    /** Gets the access path limit. */
    int accessPathLimit();

    /**
     * Gets a data flow configuration feature to add restrictions to the set of
     * valid flow paths.
     *
     * - `FeatureHasSourceCallContext`:
     *    Assume that sources have some existing call context to disallow
     *    conflicting return-flow directly following the source.
     * - `FeatureHasSinkCallContext`:
     *    Assume that sinks have some existing call context to disallow
     *    conflicting argument-to-parameter flow directly preceding the sink.
     * - `FeatureEqualSourceSinkCallContext`:
     *    Implies both of the above and additionally ensures that the entire flow
     *    path preserves the call context.
     *
     * These features are generally not relevant for typical end-to-end data flow
     * queries, but should only be used for constructing paths that need to
     * somehow be pluggable in another path context.
     */
    FlowFeature getAFeature();

    /**
     * Holds if hidden nodes should be included in the data flow graph.
     *
     * This feature should only be used for debugging or when the data flow graph
     * is not visualized (as it is in a `path-problem` query).
     */
    predicate includeHiddenNodes();

    /**
     * Holds if sources and sinks should be filtered to only include those that
     * may lead to a flow path with either a source or a sink in the location
     * range given by `AlertFiltering`. This only has an effect when running
     * in diff-informed incremental mode.
     *
     * This flag should only be applied to flow configurations whose results
     * are used directly in a query result.
     */
    predicate observeDiffInformedIncrementalMode();

    Location getASelectedSourceLocation(Node source);

    Location getASelectedSourceLocationApprox(Node source);

    Location getASelectedSinkLocation(Node sink);

    Location getASelectedSinkLocationApprox(Node sink);
  }

  /**
   * Provides default `FlowState` implementations given a `StateConfigSig`.
   */
  module DefaultState<ConfigSig Config> {
    class FlowState = Unit;

    predicate isSource(Node source, FlowState state) { Config::isSource(source) and exists(state) }

    predicate isSink(Node sink, FlowState state) { Config::isSink(sink) and exists(state) }

    predicate isBarrier(Node node, FlowState state) { none() }

    predicate isBarrierIn(Node node, FlowState state) { none() }

    predicate isBarrierOut(Node node, FlowState state) { none() }

    predicate isAdditionalFlowStep(
      Node node1, FlowState state1, Node node2, FlowState state2, string model
    ) {
      none()
    }
  }

  /**
   * Constructs a data flow computation given a full input configuration, and
   * an initial stage 1 pruning.
   */
  module Impl<FullStateConfigSig Config, Stage1Output<Config::FlowState> Stage1> {
    private class FlowState = Config::FlowState;

    private class Nd = Stage1::Nd;

    private class ArgNd = Stage1::ArgNd;

    private class ParamNd = Stage1::ParamNd;

    private class RetNd = Stage1::RetNd;

    private class OutNd = Stage1::OutNd;

    private class CastingNd = Stage1::CastingNd;

    private predicate toNormalSinkNode = Stage1::toNormalSinkNode/1;

    private predicate sourceNode = Stage1::sourceNode/1;

    private predicate sinkNode = Stage1::sinkNode/1;

    private predicate hasSourceCallCtx = Stage1::hasSourceCallCtx/0;

    private predicate hasSinkCallCtx = Stage1::hasSinkCallCtx/0;

    private predicate jumpStepEx = Stage1::jumpStepEx/2;

    private predicate additionalJumpStep = Stage1::additionalJumpStep/3;

    private predicate localStep1 = Stage1::localStep1/6;

    private predicate isStateStep = Stage1::isStateStep/2;

    private predicate sourceModel(Nd n, string model) {
      exists(NodeEx node | sourceNode(n) and node = n.getNodeEx() |
        model = getSourceModel(node)
        or
        not exists(getSourceModel(node)) and model = ""
      )
    }

    private predicate sinkModel(Nd n, string model) {
      exists(NodeEx node | sinkNode(n) and node = n.getNodeEx() |
        model = getSinkModel(node)
        or
        not exists(getSinkModel(node)) and model = ""
      )
    }

    bindingset[label1, label2]
    pragma[inline_late]
    private string mergeLabels(string label1, string label2) {
      if label2.matches("Sink:%")
      then if label1 = "" then result = label2 else result = label1 + " " + label2
      else
        // Big-step, hidden nodes, and summaries all may need to merge labels.
        // These cases are expected to involve at most one non-empty label, so
        // we'll just discard the 2nd+ label for now.
        if label1 = ""
        then result = label2
        else result = label1
    }

    pragma[nomagic]
    private predicate allowsFieldFlowThrough(Call call, Callable c) {
      Stage1::callEdgeReturn(call, c, _, _, _, true)
    }

    private signature module StageSig {
      class Ap;

      class ApNil extends Ap;

      predicate revFlow(Nd node);

      predicate revFlow(Nd node, Ap ap);

      predicate callMayFlowThroughRev(Call call);

      predicate parameterMayFlowThrough(ParamNd p, boolean emptyAp);

      predicate returnMayFlowThrough(RetNd ret, ReturnKindExt kind);

      predicate storeStepCand(Nd node1, Content c, Nd node2, Type contentType, Type containerType);

      predicate readStepCand(Nd n1, Content c, Nd n2);

      predicate callEdgeArgParam(Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp);

      predicate callEdgeReturn(
        Call call, Callable c, RetNd ret, ReturnKindExt kind, Nd out, boolean allowsFieldFlow
      );

      predicate relevantCallEdgeIn(Call call, Callable c);

      predicate relevantCallEdgeOut(Call call, Callable c);
    }

    private module MkStage<StageSig PrevStage> {
      class ApApprox = PrevStage::Ap;

      signature module StageParam {
        class Typ {
          string toString();
        }

        class Ap {
          string toString();
        }

        class ApNil extends Ap;

        bindingset[result, ap]
        ApApprox getApprox(Ap ap);

        Typ getTyp(Type t);

        bindingset[c, tail]
        Ap apCons(Content c, Ap tail);

        /**
         * An approximation of `Content` that corresponds to the precision level of
         * `Ap`, such that the mappings from both `Ap` and `Content` to this type
         * are functional.
         */
        class ApHeadContent;

        ApHeadContent getHeadContent(Ap ap);

        ApHeadContent projectToHeadContent(Content c);

        class ApOption;

        ApOption apNone();

        ApOption apSome(Ap ap);

        class Cc {
          string toString();
        }

        class CcCall extends Cc;

        // TODO: member predicate on CcCall
        predicate matchesCall(CcCall cc, Call call);

        class CcNoCall extends Cc;

        Cc ccNone();

        CcCall ccSomeCall();

        /*
         * The following `instanceof` predicates are necessary for proper
         * caching, since we're able to cache predicates, but not the underlying
         * types.
         */

        predicate instanceofCc(Cc cc);

        predicate instanceofCcCall(CcCall cc);

        predicate instanceofCcNoCall(CcNoCall cc);

        class LocalCc;

        Callable viableImplCallContextReduced(Call call, CcCall ctx);

        bindingset[call, ctx]
        predicate viableImplNotCallContextReduced(Call call, Cc ctx);

        bindingset[call, c]
        CcCall getCallContextCall(Call call, Callable c);

        Call viableImplCallContextReducedReverse(Callable c, CcNoCall ctx);

        predicate viableImplNotCallContextReducedReverse(CcNoCall ctx);

        bindingset[call, c]
        CcNoCall getCallContextReturn(Callable c, Call call);

        bindingset[cc]
        LocalCc getLocalCc(Cc cc);

        predicate localStep(
          Nd node1, Nd node2, boolean preservesValue, Typ t, LocalCc lcc, string label
        );

        bindingset[node, t0, ap]
        predicate filter(Nd node, Typ t0, Ap ap, Typ t);

        bindingset[node, ap, isStoreStep]
        predicate stepFilter(Nd node, Ap ap, boolean isStoreStep);

        bindingset[t1, t2]
        predicate typecheck(Typ t1, Typ t2);

        default predicate enableTypeFlow() { any() }
      }

      module Stage<StageParam Param> implements StageSig {
        import Param

        private module TypOption = Option<Typ>;

        private class TypOption = TypOption::Option;

        private string ppStored(TypOption stored) {
          exists(string ppt | ppt = stored.toString() |
            if stored.isNone() or ppt = "" then result = "" else result = " : " + ppt
          )
        }

        bindingset[ap]
        private boolean isNil(Ap ap) {
          if ap instanceof ApNil then result = true else result = false
        }

        /* Begin: Stage logic. */
        pragma[nomagic]
        private Typ getNodeTyp(Nd node) {
          PrevStage::revFlow(node) and result = getTyp(node.getType())
        }

        pragma[nomagic]
        private predicate flowThroughOutOfCall(Call call, RetNd ret, Nd out, boolean allowsFieldFlow) {
          exists(ReturnKindExt kind |
            PrevStage::callEdgeReturn(call, _, ret, kind, out, allowsFieldFlow) and
            PrevStage::callMayFlowThroughRev(call) and
            PrevStage::returnMayFlowThrough(ret, kind)
          )
        }

        pragma[nomagic]
        private predicate compatibleContainer0(ApHeadContent apc, Type containerType) {
          exists(Type containerType0, Content c |
            PrevStage::storeStepCand(_, c, _, _, containerType0) and
            not topTypeContent(apc) and
            compatibleTypesCached(containerType0, containerType) and
            apc = projectToHeadContent(c)
          )
        }

        pragma[nomagic]
        private predicate topTypeContent(ApHeadContent apc) {
          exists(Type containerType0, Content c |
            PrevStage::storeStepCand(_, c, _, _, containerType0) and
            isTopType(containerType0) and
            apc = projectToHeadContent(c)
          )
        }

        bindingset[apc, containerType]
        pragma[inline_late]
        private predicate compatibleContainer(ApHeadContent apc, Type containerType) {
          compatibleContainer0(apc, containerType)
        }

        /**
         * Holds if `node` is reachable with access path `ap` from a source.
         *
         * The call context `cc` records whether the node is reached through an
         * argument in a call, and if so, `summaryCtx` records the
         * corresponding parameter position and access path of that argument.
         */
        pragma[nomagic]
        additional predicate fwdFlow(
          Nd node, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
        ) {
          fwdFlow1(node, cc, summaryCtx, _, t, ap, stored)
        }

        private predicate fwdFlow1(
          Nd node, Cc cc, SummaryCtx summaryCtx, Typ t0, Typ t, Ap ap, TypOption stored
        ) {
          exists(ApApprox apa |
            fwdFlow0(node, cc, summaryCtx, t0, ap, apa, stored) and
            PrevStage::revFlow(node, apa) and
            filter(node, t0, ap, t) and
            (
              if node instanceof CastingNd
              then
                ap instanceof ApNil or
                compatibleContainer(getHeadContent(ap), node.getType()) or
                topTypeContent(getHeadContent(ap))
              else any()
            )
          )
        }

        pragma[nomagic]
        private predicate fwdFlow0(
          Nd node, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, ApApprox apa, TypOption stored
        ) {
          sourceNode(node) and
          (if hasSourceCallCtx() then cc = ccSomeCall() else cc = ccNone()) and
          summaryCtx = TSummaryCtxNone() and
          t = getNodeTyp(node) and
          ap instanceof ApNil and
          apa = getApprox(ap) and
          stored.isNone()
          or
          exists(Nd mid, Typ t0, LocalCc localCc |
            fwdFlow(mid, cc, summaryCtx, t0, ap, stored) and
            apa = getApprox(ap) and
            localCc = getLocalCc(cc)
          |
            localStep(mid, node, true, _, localCc, _) and
            t = t0
            or
            localStep(mid, node, false, t, localCc, _) and
            ap instanceof ApNil
          )
          or
          fwdFlowJump(node, t, ap, stored) and
          apa = getApprox(ap) and
          cc = ccNone() and
          summaryCtx = TSummaryCtxNone()
          or
          // store
          exists(Content c, Ap ap0 |
            fwdFlowStore(_, _, ap0, _, c, t, stored, node, cc, summaryCtx) and
            ap = apCons(c, ap0) and
            apa = getApprox(ap)
          )
          or
          // read
          fwdFlowRead(_, _, _, _, _, node, t, ap, stored, cc, summaryCtx) and
          apa = getApprox(ap)
          or
          // flow into a callable without summary context
          fwdFlowInNoFlowThrough(node, cc, t, ap, stored) and
          apa = getApprox(ap) and
          summaryCtx = TSummaryCtxNone() and
          // When the call contexts of source and sink needs to match then there's
          // never any reason to enter a callable except to find a summary. See also
          // the comment in `PathNodeMid::isAtSink`.
          not Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
          or
          // flow into a callable with summary context (non-linear recursion)
          fwdFlowInFlowThrough(node, cc, t, ap, stored) and
          apa = getApprox(ap) and
          summaryCtx = TSummaryCtxSome(node, t, ap, stored)
          or
          // flow out of a callable
          fwdFlowOut(_, _, node, cc, summaryCtx, t, ap, stored) and
          apa = getApprox(ap)
          or
          // flow through a callable
          exists(Call call, RetNd ret, boolean allowsFieldFlow |
            fwdFlowThrough(call, cc, summaryCtx, t, ap, stored, ret) and
            flowThroughOutOfCall(call, ret, node, allowsFieldFlow) and
            apa = getApprox(ap) and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        private newtype TSummaryCtx =
          TSummaryCtxNone() or
          TSummaryCtxSome(ParamNd p, Typ t, Ap ap, TypOption stored) {
            fwdFlowInFlowThrough(p, _, t, ap, stored)
          }

        /**
         * A context for generating flow summaries. This represents flow entry through
         * a specific parameter with an access path of a specific shape.
         *
         * Summaries are only created for parameters that may flow through.
         */
        private class SummaryCtx extends TSummaryCtx {
          abstract string toString();

          abstract Location getLocation();
        }

        /** A summary context from which no flow summary can be generated. */
        private class SummaryCtxNone extends SummaryCtx, TSummaryCtxNone {
          override string toString() { result = "<none>" }

          override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }
        }

        /** A summary context from which a flow summary can be generated. */
        private class SummaryCtxSome extends SummaryCtx, TSummaryCtxSome {
          private ParamNd p;
          private Typ t;
          private Ap ap;
          private TypOption stored;

          SummaryCtxSome() { this = TSummaryCtxSome(p, t, ap, stored) }

          ParamNd getParamNode() { result = p }

          private string ppTyp() { result = t.toString() and result != "" }

          override string toString() {
            result = p + concat(" : " + this.ppTyp()) + " " + ap + ppStored(stored)
          }

          override Location getLocation() { result = p.getLocation() }
        }

        private predicate fwdFlowJump(Nd node, Typ t, Ap ap, TypOption stored) {
          exists(Nd mid |
            fwdFlow(mid, _, _, t, ap, stored) and
            jumpStepEx(mid, node)
          )
          or
          exists(Nd mid |
            fwdFlow(mid, _, _, _, ap, stored) and
            additionalJumpStep(mid, node, _) and
            t = getNodeTyp(node) and
            ap instanceof ApNil
          )
        }

        pragma[nomagic]
        private predicate fwdFlowStore(
          Nd node1, Typ t1, Ap ap1, TypOption stored1, Content c, Typ t2, TypOption stored2,
          Nd node2, Cc cc, SummaryCtx summaryCtx
        ) {
          exists(Type contentType, Type containerType |
            fwdFlow(node1, cc, summaryCtx, t1, ap1, stored1) and
            PrevStage::storeStepCand(node1, c, node2, contentType, containerType) and
            t2 = getTyp(containerType) and
            // We need to typecheck stores here, since reverse flow through a getter
            // might have a different type here compared to inside the getter.
            typecheck(t1, getTyp(contentType)) and
            if ap1 instanceof ApNil then stored2.asSome() = t1 else stored2 = stored1
          )
        }

        /**
         * Holds if forward flow with access path `tail` and type `t1` reaches a
         * store of `c` on a container of type `t2` resulting in access path
         * `cons`.
         */
        pragma[nomagic]
        private predicate fwdFlowConsCand(Typ t2, Ap cons, Content c, Typ t1, Ap tail) {
          fwdFlowStore(_, t1, tail, _, c, t2, _, _, _, _) and
          cons = apCons(c, tail)
        }

        pragma[nomagic]
        private predicate readStepCand(Nd node1, ApHeadContent apc, Content c, Nd node2) {
          PrevStage::readStepCand(node1, c, node2) and
          apc = projectToHeadContent(c)
        }

        bindingset[node1, apc]
        pragma[inline_late]
        private predicate readStepCand0(Nd node1, ApHeadContent apc, Content c, Nd node2) {
          readStepCand(node1, apc, c, node2)
        }

        pragma[nomagic]
        private predicate fwdFlowRead0(
          Typ t, Ap ap, TypOption stored, Content c, Nd node1, Nd node2, Cc cc,
          SummaryCtx summaryCtx
        ) {
          exists(ApHeadContent apc |
            fwdFlow(node1, cc, summaryCtx, t, ap, stored) and
            apc = getHeadContent(ap) and
            readStepCand0(node1, apc, c, node2)
          )
        }

        pragma[nomagic]
        private predicate fwdFlowRead(
          Nd node1, Typ t1, Ap ap1, TypOption stored1, Content c, Nd node2, Typ t2, Ap ap2,
          TypOption stored2, Cc cc, SummaryCtx summaryCtx
        ) {
          exists(Typ ct1, Typ ct2 |
            fwdFlowRead0(t1, ap1, stored1, c, node1, node2, cc, summaryCtx) and
            fwdFlowConsCand(ct1, ap1, c, ct2, ap2) and
            typecheck(t1, ct1) and
            typecheck(t2, ct2) and
            if ap2 instanceof ApNil
            then stored2.isNone() and stored1.asSome() = t2
            else (
              stored2 = stored1 and t2 = getNodeTyp(node2)
            )
          )
        }

        pragma[nomagic]
        private predicate fwdFlowIntoArg(
          ArgNd arg, Cc outercc, SummaryCtx summaryCtx, Typ t, Ap ap, boolean emptyAp,
          TypOption stored, boolean cc
        ) {
          fwdFlow(arg, outercc, summaryCtx, t, ap, stored) and
          (if instanceofCcCall(outercc) then cc = true else cc = false) and
          emptyAp = isNil(ap)
        }

        private signature predicate flowThroughSig();

        /**
         * Exposes the inlined predicate `fwdFlowIn`, which is used to calculate both
         * flow in and flow through.
         *
         * For flow in, only a subset of the columns are needed, specifically we don't
         * need to record the argument that flows into the parameter.
         *
         * For flow through, we do need to record the argument, however, we can restrict
         * this to arguments that may actually flow through, which reduces the
         * argument-to-parameter fan-in significantly.
         */
        private module FwdFlowIn<flowThroughSig/0 flowThrough> {
          pragma[nomagic]
          private predicate callEdgeArgParamRestricted(
            Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp
          ) {
            PrevStage::callEdgeArgParam(call, c, arg, p, emptyAp) and
            if
              PrevStage::callMayFlowThroughRev(call) and
              PrevStage::parameterMayFlowThrough(p, emptyAp)
            then
              emptyAp = true and
              flowThrough()
              or
              emptyAp = false and
              if allowsFieldFlowThrough(call, c) then flowThrough() else not flowThrough()
            else not flowThrough()
          }

          pragma[nomagic]
          private Callable viableImplCallContextReducedRestricted(Call call, CcCall ctx) {
            result = viableImplCallContextReduced(call, ctx) and
            callEdgeArgParamRestricted(call, result, _, _, _)
          }

          bindingset[call, ctx]
          pragma[inline_late]
          private Callable viableImplCallContextReducedInlineLate(Call call, CcCall ctx) {
            result = viableImplCallContextReducedRestricted(call, ctx)
          }

          bindingset[arg, ctx]
          pragma[inline_late]
          private Callable viableImplCallContextReducedInlineLate(Call call, ArgNd arg, CcCall ctx) {
            callEdgeArgParamRestricted(call, _, arg, _, _) and
            instanceofCcCall(ctx) and
            result = viableImplCallContextReducedInlineLate(call, ctx)
          }

          bindingset[call]
          pragma[inline_late]
          private predicate callEdgeArgParamRestrictedInlineLate(
            Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp
          ) {
            callEdgeArgParamRestricted(call, c, arg, p, emptyAp)
          }

          bindingset[call, ctx]
          pragma[inline_late]
          private predicate viableImplNotCallContextReducedInlineLate(Call call, Cc ctx) {
            instanceofCc(ctx) and
            viableImplNotCallContextReduced(call, ctx)
          }

          bindingset[arg, outercc]
          pragma[inline_late]
          private predicate viableImplArgNotCallContextReduced(Call call, ArgNd arg, Cc outercc) {
            callEdgeArgParamRestricted(call, _, arg, _, _) and
            instanceofCc(outercc) and
            viableImplNotCallContextReducedInlineLate(call, outercc)
          }

          pragma[inline]
          private predicate fwdFlowInCand(
            Call call, ArgNd arg, Cc outercc, Callable inner, ParamNd p, SummaryCtx summaryCtx,
            Typ t, Ap ap, boolean emptyAp, TypOption stored, boolean cc
          ) {
            fwdFlowIntoArg(arg, outercc, summaryCtx, t, ap, emptyAp, stored, cc) and
            (
              inner = viableImplCallContextReducedInlineLate(call, arg, outercc)
              or
              viableImplArgNotCallContextReduced(call, arg, outercc)
            ) and
            callEdgeArgParamRestrictedInlineLate(call, inner, arg, p, emptyAp)
          }

          pragma[inline]
          private predicate fwdFlowInCandTypeFlowDisabled(
            Call call, ArgNd arg, Cc outercc, Callable inner, ParamNd p, SummaryCtx summaryCtx,
            Typ t, Ap ap, TypOption stored, boolean cc
          ) {
            not enableTypeFlow() and
            fwdFlowInCand(call, arg, outercc, inner, p, summaryCtx, t, ap, _, stored, cc)
          }

          pragma[nomagic]
          private predicate fwdFlowInCandTypeFlowEnabled(
            Call call, ArgNd arg, Cc outercc, Callable inner, ParamNd p, boolean emptyAp, boolean cc
          ) {
            enableTypeFlow() and
            fwdFlowInCand(call, arg, outercc, inner, p, _, _, _, emptyAp, _, cc)
          }

          pragma[nomagic]
          private predicate fwdFlowInValidEdgeTypeFlowDisabled(
            Call call, Callable inner, CcCall innercc, boolean cc
          ) {
            not enableTypeFlow() and
            FwdTypeFlow::typeFlowValidEdgeIn(call, inner, cc) and
            innercc = getCallContextCall(call, inner)
          }

          pragma[nomagic]
          private predicate fwdFlowInValidEdgeTypeFlowEnabled(
            Call call, ArgNd arg, Cc outercc, Callable inner, ParamNd p, CcCall innercc,
            boolean emptyAp, boolean cc
          ) {
            fwdFlowInCandTypeFlowEnabled(call, arg, outercc, inner, p, emptyAp, cc) and
            FwdTypeFlow::typeFlowValidEdgeIn(call, inner, cc) and
            innercc = getCallContextCall(call, inner)
          }

          overlay[caller?]
          pragma[inline]
          predicate fwdFlowIn(
            Call call, ArgNd arg, Callable inner, ParamNd p, Cc outercc, CcCall innercc,
            SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, boolean cc
          ) {
            // type flow disabled: linear recursion
            fwdFlowInCandTypeFlowDisabled(call, arg, outercc, inner, p, summaryCtx, t, ap, stored,
              cc) and
            fwdFlowInValidEdgeTypeFlowDisabled(call, inner, innercc, pragma[only_bind_into](cc))
            or
            // type flow enabled: non-linear recursion
            exists(boolean emptyAp |
              fwdFlowIntoArg(arg, outercc, summaryCtx, t, ap, emptyAp, stored, cc) and
              fwdFlowInValidEdgeTypeFlowEnabled(call, arg, outercc, inner, p, innercc, emptyAp, cc)
            )
          }
        }

        private predicate bottom() { none() }

        private module FwdFlowInNoThrough = FwdFlowIn<bottom/0>;

        pragma[nomagic]
        private predicate fwdFlowInNoFlowThrough(
          ParamNd p, CcCall innercc, Typ t, Ap ap, TypOption stored
        ) {
          FwdFlowInNoThrough::fwdFlowIn(_, _, _, p, _, innercc, _, t, ap, stored, _)
        }

        private predicate top() { any() }

        private module FwdFlowInThrough = FwdFlowIn<top/0>;

        pragma[nomagic]
        private predicate fwdFlowInFlowThrough(
          ParamNd p, CcCall innercc, Typ t, Ap ap, TypOption stored
        ) {
          FwdFlowInThrough::fwdFlowIn(_, _, _, p, _, innercc, _, t, ap, stored, _)
        }

        pragma[nomagic]
        private Call viableImplCallContextReducedReverseRestricted(Callable c, CcNoCall ctx) {
          result = viableImplCallContextReducedReverse(c, ctx) and
          PrevStage::callEdgeReturn(result, c, _, _, _, _)
        }

        bindingset[c, ctx]
        pragma[inline_late]
        private Call viableImplCallContextReducedReverseInlineLate(Callable c, CcNoCall ctx) {
          result = viableImplCallContextReducedReverseRestricted(c, ctx)
        }

        bindingset[call]
        pragma[inline_late]
        private predicate flowOutOfCallInlineLate(
          Call call, Callable c, RetNd ret, Nd out, boolean allowsFieldFlow
        ) {
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow)
        }

        bindingset[c, ret, innercc]
        pragma[inline_late]
        pragma[noopt]
        private predicate flowOutOfCallNotCallContextReduced(
          Call call, Callable c, RetNd ret, Nd out, boolean allowsFieldFlow, CcNoCall innercc
        ) {
          viableImplNotCallContextReducedReverse(innercc) and
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow)
        }

        pragma[nomagic]
        private predicate fwdFlowIntoRet(
          RetNd ret, CcNoCall cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
        ) {
          instanceofCcNoCall(cc) and
          fwdFlow(ret, cc, summaryCtx, t, ap, stored)
        }

        pragma[nomagic]
        private predicate fwdFlowOutCand(
          Call call, RetNd ret, CcNoCall innercc, Callable inner, Nd out, boolean allowsFieldFlow
        ) {
          fwdFlowIntoRet(ret, innercc, _, _, _, _) and
          inner = ret.getEnclosingCallable() and
          (
            call = viableImplCallContextReducedReverseInlineLate(inner, innercc) and
            flowOutOfCallInlineLate(call, inner, ret, out, allowsFieldFlow)
            or
            flowOutOfCallNotCallContextReduced(call, inner, ret, out, allowsFieldFlow, innercc)
          )
        }

        pragma[nomagic]
        private predicate fwdFlowOutValidEdge(
          Call call, RetNd ret, CcNoCall innercc, Callable inner, Nd out, CcNoCall outercc,
          boolean allowsFieldFlow
        ) {
          fwdFlowOutCand(call, ret, innercc, inner, out, allowsFieldFlow) and
          FwdTypeFlow::typeFlowValidEdgeOut(call, inner) and
          outercc = getCallContextReturn(inner, call)
        }

        pragma[inline]
        private predicate fwdFlowOut(
          Call call, Callable inner, Nd out, CcNoCall outercc, SummaryCtx summaryCtx, Typ t, Ap ap,
          TypOption stored
        ) {
          exists(RetNd ret, CcNoCall innercc, boolean allowsFieldFlow |
            fwdFlowIntoRet(ret, innercc, summaryCtx, t, ap, stored) and
            fwdFlowOutValidEdge(call, ret, innercc, inner, out, outercc, allowsFieldFlow) and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        private module FwdTypeFlowInput implements TypeFlowInput {
          predicate enableTypeFlow = Param::enableTypeFlow/0;

          predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

          predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

          pragma[nomagic]
          private predicate dataFlowTakenCallEdgeIn0(
            Call call, Callable c, ParamNd p, CcCall innercc, Typ t, Ap ap, TypOption stored,
            boolean cc
          ) {
            FwdFlowInNoThrough::fwdFlowIn(call, _, c, p, _, innercc, _, t, ap, stored, cc)
            or
            FwdFlowInThrough::fwdFlowIn(call, _, c, p, _, innercc, _, t, ap, stored, cc)
          }

          pragma[nomagic]
          private predicate fwdFlow1Param(ParamNd p, CcCall cc, Typ t0, Ap ap, TypOption stored) {
            instanceofCcCall(cc) and
            fwdFlow1(p, cc, _, t0, _, ap, stored)
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeIn(Call call, Callable c, boolean cc) {
            exists(ParamNd p, CcCall innercc, Typ t, Ap ap, TypOption stored |
              dataFlowTakenCallEdgeIn0(call, c, p, innercc, t, ap, stored, cc) and
              fwdFlow1Param(p, innercc, t, ap, stored)
            )
          }

          pragma[nomagic]
          private predicate dataFlowTakenCallEdgeOut0(
            Call call, Callable c, Nd node, Cc cc, Typ t, Ap ap, TypOption stored
          ) {
            fwdFlowOut(call, c, node, cc, _, t, ap, stored)
          }

          pragma[nomagic]
          private predicate fwdFlow1Out(Nd node, Cc cc, Typ t0, Ap ap, TypOption stored) {
            fwdFlow1(node, cc, _, t0, _, ap, stored) and
            PrevStage::callEdgeReturn(_, _, _, _, node, _)
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeOut(Call call, Callable c) {
            exists(Nd node, Cc cc, Typ t, Ap ap, TypOption stored |
              dataFlowTakenCallEdgeOut0(call, c, node, cc, t, ap, stored) and
              fwdFlow1Out(node, cc, t, ap, stored)
            )
          }

          predicate dataFlowNonCallEntry(Callable c, boolean cc) {
            exists(Nd node |
              sourceNode(node) and
              (if hasSourceCallCtx() then cc = true else cc = false) and
              PrevStage::revFlow(node, any(PrevStage::ApNil nil)) and
              c = node.getEnclosingCallable()
            )
            or
            exists(Nd node |
              cc = false and
              fwdFlowJump(node, _, _, _) and
              c = node.getEnclosingCallable()
            )
          }
        }

        private module FwdTypeFlow = TypeFlow<FwdTypeFlowInput>;

        private predicate flowIntoCallTaken(
          Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp
        ) {
          PrevStage::callEdgeArgParam(call, c, arg, p, emptyAp) and
          FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _)
        }

        pragma[nomagic]
        private predicate fwdFlowRetFromArg(
          RetNd ret, CcCall ccc, SummaryCtxSome summaryCtx, Typ t, Ap ap, TypOption stored
        ) {
          exists(ReturnKindExt kind, ParamNd p, Ap argAp |
            instanceofCcCall(ccc) and
            fwdFlow(pragma[only_bind_into](ret), ccc, summaryCtx, t, ap, stored) and
            summaryCtx =
              TSummaryCtxSome(pragma[only_bind_into](p), _, pragma[only_bind_into](argAp), _) and
            kind = ret.getKind() and
            Stage1::parameterFlowThroughAllowed(p, kind) and
            PrevStage::returnMayFlowThrough(ret, kind)
          )
        }

        pragma[inline]
        private predicate fwdFlowThrough0(
          Call call, ArgNd arg, Cc cc, CcCall ccc, SummaryCtx summaryCtx, Typ t, Ap ap,
          TypOption stored, RetNd ret, SummaryCtxSome innerSummaryCtx
        ) {
          fwdFlowRetFromArg(ret, ccc, innerSummaryCtx, t, ap, stored) and
          fwdFlowIsEntered(call, arg, cc, ccc, summaryCtx, innerSummaryCtx)
        }

        pragma[nomagic]
        private predicate fwdFlowThrough(
          Call call, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, RetNd ret
        ) {
          fwdFlowThrough0(call, _, cc, _, summaryCtx, t, ap, stored, ret, _)
        }

        pragma[nomagic]
        private predicate fwdFlowIsEntered0(
          Call call, ArgNd arg, Cc cc, CcCall innerCc, SummaryCtx summaryCtx, ParamNd p, Typ t,
          Ap ap, TypOption stored
        ) {
          FwdFlowInThrough::fwdFlowIn(call, arg, _, p, cc, innerCc, summaryCtx, t, ap, stored, _)
        }

        /**
         * Holds if an argument to `call` is reached in the flow covered by `fwdFlow`
         * and data might flow through the target callable and back out at `call`.
         */
        pragma[nomagic]
        private predicate fwdFlowIsEntered(
          Call call, ArgNd arg, Cc cc, CcCall innerCc, SummaryCtx summaryCtx,
          SummaryCtxSome innerSummaryCtx
        ) {
          exists(ParamNd p, Typ t, Ap ap, TypOption stored |
            fwdFlowIsEntered0(call, arg, cc, innerCc, summaryCtx, p, t, ap, stored) and
            innerSummaryCtx = TSummaryCtxSome(p, t, ap, stored)
          )
        }

        pragma[nomagic]
        private predicate storeStepFwd(Nd node1, Ap ap1, Content c, Nd node2, Ap ap2) {
          fwdFlowStore(node1, _, ap1, _, c, _, _, node2, _, _) and
          readStepFwd(_, ap2, c, _, ap1)
        }

        pragma[nomagic]
        private predicate readStepFwd(Nd n1, Ap ap1, Content c, Nd n2, Ap ap2) {
          fwdFlowRead(n1, _, ap1, _, c, n2, _, ap2, _, _, _)
        }

        pragma[nomagic]
        private predicate returnFlowsThrough0(
          Call call, CcCall ccc, Ap ap, RetNd ret, SummaryCtxSome innerSummaryCtx
        ) {
          fwdFlowThrough0(call, _, _, ccc, _, _, ap, _, ret, innerSummaryCtx)
        }

        pragma[nomagic]
        private predicate returnFlowsThrough(
          RetNd ret, ReturnPosition pos, CcCall ccc, ParamNd p, Typ argT, Ap argAp,
          TypOption argStored, Ap ap
        ) {
          exists(Call call, boolean allowsFieldFlow |
            returnFlowsThrough0(call, ccc, ap, ret, TSummaryCtxSome(p, argT, argAp, argStored)) and
            flowThroughOutOfCall(call, ret, _, allowsFieldFlow) and
            pos = ret.getReturnPosition() and
            if allowsFieldFlow = false then ap instanceof ApNil else any()
          )
        }

        pragma[nomagic]
        private predicate flowThroughIntoCall(Call call, ArgNd arg, ParamNd p, Ap argAp) {
          exists(Typ argT, TypOption argStored |
            returnFlowsThrough(_, _, _, pragma[only_bind_into](p), pragma[only_bind_into](argT),
              pragma[only_bind_into](argAp), pragma[only_bind_into](argStored), _) and
            flowIntoCallTaken(call, _, pragma[only_bind_into](arg), p, isNil(argAp)) and
            fwdFlow(arg, _, _, pragma[only_bind_into](argT), pragma[only_bind_into](argAp),
              pragma[only_bind_into](argStored))
          )
        }

        pragma[nomagic]
        private predicate flowIntoCallAp(Call call, Callable c, ArgNd arg, ParamNd p, Ap ap) {
          flowIntoCallTaken(call, c, arg, p, isNil(ap)) and
          fwdFlow(arg, _, _, _, ap, _)
        }

        pragma[nomagic]
        private predicate flowOutOfCallAp(
          Call call, Callable c, RetNd ret, ReturnPosition pos, Nd out, Ap ap,
          boolean allowsFieldFlow
        ) {
          PrevStage::callEdgeReturn(call, c, ret, _, out, allowsFieldFlow) and
          fwdFlow(ret, _, _, _, ap, _) and
          pos = ret.getReturnPosition() and
          (if allowsFieldFlow = false then ap instanceof ApNil else any()) and
          (
            // both directions are needed for flow-through
            FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
            FwdTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
          )
        }

        /**
         * Holds if `node` with access path `ap` is part of a path from a source to a
         * sink.
         *
         * The parameter `returnCtx` records whether (and how) the node must be returned
         * from the enclosing callable in order to reach a sink, and if so, `returnAp`
         * records the access path of the returned value.
         */
        pragma[nomagic]
        additional predicate revFlow(Nd node, ReturnCtx returnCtx, ApOption returnAp, Ap ap) {
          revFlow0(node, returnCtx, returnAp, ap) and
          fwdFlow(node, _, _, _, ap, _)
        }

        pragma[nomagic]
        private predicate revFlow0(Nd node, ReturnCtx returnCtx, ApOption returnAp, Ap ap) {
          fwdFlow(node, _, _, _, ap, _) and
          sinkNode(node) and
          (
            if hasSinkCallCtx()
            then returnCtx = TReturnCtxNoFlowThrough()
            else returnCtx = TReturnCtxNone()
          ) and
          returnAp = apNone() and
          ap instanceof ApNil
          or
          exists(Nd mid |
            localStep(node, mid, true, _, _, _) and
            revFlow(mid, returnCtx, returnAp, ap)
          )
          or
          exists(Nd mid |
            localStep(node, mid, false, _, _, _) and
            revFlow(mid, returnCtx, returnAp, ap) and
            ap instanceof ApNil
          )
          or
          revFlowJump(node, ap) and
          returnCtx = TReturnCtxNone() and
          returnAp = apNone()
          or
          // store
          exists(Ap ap0, Content c |
            revFlowStore(ap0, c, ap, node, _, returnCtx, returnAp) and
            revFlowConsCand(ap0, c, ap)
          )
          or
          // read
          exists(Nd mid, Ap ap0 |
            revFlow(mid, returnCtx, returnAp, ap0) and
            readStepFwd(node, ap, _, mid, ap0)
          )
          or
          // flow into a callable
          revFlowIn(_, _, node, ap) and
          returnCtx = TReturnCtxNone() and
          returnAp = apNone()
          or
          // flow through a callable
          exists(Call call, ParamNd p |
            revFlowThrough(call, returnCtx, p, returnAp, ap) and
            flowThroughIntoCall(call, node, p, ap)
          )
          or
          // flow out of a callable
          exists(ReturnPosition pos |
            revFlowOut(_, node, pos, _, _, _, ap) and
            if returnFlowsThrough(node, pos, _, _, _, _, _, ap)
            then (
              returnCtx = TReturnCtxMaybeFlowThrough(pos) and
              returnAp = apSome(ap)
            ) else (
              returnCtx = TReturnCtxNoFlowThrough() and returnAp = apNone()
            )
          )
        }

        private predicate revFlowJump(Nd node, Ap ap) {
          exists(Nd mid |
            jumpStepEx(node, mid) and
            revFlow(mid, _, _, ap)
          )
          or
          exists(Nd mid |
            additionalJumpStep(node, mid, _) and
            revFlow(pragma[only_bind_into](mid), _, _, ap) and
            ap instanceof ApNil
          )
        }

        pragma[nomagic]
        private predicate revFlowStore(
          Ap ap0, Content c, Ap ap, Nd node, Nd mid, ReturnCtx returnCtx, ApOption returnAp
        ) {
          revFlow(mid, returnCtx, returnAp, ap0) and
          storeStepFwd(node, ap, c, mid, ap0)
        }

        /**
         * Holds if reverse flow with access path `tail` reaches a read of `c`
         * resulting in access path `cons`.
         */
        pragma[nomagic]
        private predicate revFlowConsCand(Ap cons, Content c, Ap tail) {
          exists(Nd mid, Ap tail0 |
            revFlow(mid, _, _, tail) and
            tail = pragma[only_bind_into](tail0) and
            readStepFwd(_, cons, c, mid, tail0)
          )
        }

        private module RevTypeFlowInput implements TypeFlowInput {
          predicate enableTypeFlow = Param::enableTypeFlow/0;

          predicate relevantCallEdgeIn(Call call, Callable c) {
            flowOutOfCallAp(call, c, _, _, _, _, _)
          }

          predicate relevantCallEdgeOut(Call call, Callable c) { flowIntoCallAp(call, c, _, _, _) }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeIn(Call call, Callable c, boolean cc) {
            exists(RetNd ret |
              revFlowOut(call, ret, _, _, cc, _, _) and
              c = ret.getEnclosingCallable()
            )
          }

          pragma[nomagic]
          predicate dataFlowTakenCallEdgeOut(Call call, Callable c) { revFlowIn(call, c, _, _) }

          predicate dataFlowNonCallEntry(Callable c, boolean cc) {
            exists(Nd node, ApNil nil |
              fwdFlow(node, _, _, _, nil, _) and
              sinkNode(node) and
              (if hasSinkCallCtx() then cc = true else cc = false) and
              c = node.getEnclosingCallable()
            )
            or
            exists(Nd node |
              cc = false and
              revFlowJump(node, _) and
              c = node.getEnclosingCallable()
            )
          }
        }

        private module RevTypeFlow = TypeFlow<RevTypeFlowInput>;

        pragma[nomagic]
        private predicate flowIntoCallApValid(Call call, Callable c, ArgNd arg, ParamNd p, Ap ap) {
          flowIntoCallAp(call, c, arg, p, ap) and
          RevTypeFlow::typeFlowValidEdgeOut(call, c)
        }

        pragma[nomagic]
        private predicate flowOutOfCallApValid(
          Call call, RetNd ret, ReturnPosition pos, Nd out, Ap ap, boolean cc
        ) {
          exists(Callable c |
            flowOutOfCallAp(call, c, ret, pos, out, ap, _) and
            RevTypeFlow::typeFlowValidEdgeIn(call, c, cc)
          )
        }

        private predicate revFlowIn(Call call, Callable c, ArgNd arg, Ap ap) {
          exists(ParamNd p |
            revFlow(p, TReturnCtxNone(), _, ap) and
            flowIntoCallApValid(call, c, arg, p, ap)
          )
        }

        pragma[nomagic]
        private predicate revFlowOut(
          Call call, RetNd ret, ReturnPosition pos, ReturnCtx returnCtx, boolean cc,
          ApOption returnAp, Ap ap
        ) {
          exists(Nd out |
            revFlow(out, returnCtx, returnAp, ap) and
            flowOutOfCallApValid(call, ret, pos, out, ap, cc) and
            if returnCtx instanceof TReturnCtxNone then cc = false else cc = true
          )
        }

        pragma[nomagic]
        private predicate revFlowParamToReturn(ParamNd p, ReturnPosition pos, Ap returnAp, Ap ap) {
          revFlow(pragma[only_bind_into](p), TReturnCtxMaybeFlowThrough(pos), apSome(returnAp),
            pragma[only_bind_into](ap)) and
          Stage1::parameterFlowThroughAllowed(p, pos.getKind()) and
          PrevStage::parameterMayFlowThrough(p, isNil(ap))
        }

        pragma[nomagic]
        private predicate revFlowThrough(
          Call call, ReturnCtx returnCtx, ParamNd p, ApOption returnAp, Ap ap
        ) {
          exists(ReturnPosition pos, Ap innerReturnAp |
            revFlowParamToReturn(p, pos, innerReturnAp, ap) and
            revFlowIsReturned(call, returnCtx, returnAp, pos, innerReturnAp)
          )
        }

        /**
         * Holds if an output from `call` is reached in the flow covered by `revFlow`
         * and data might flow through the target callable resulting in reverse flow
         * reaching an argument of `call`.
         */
        pragma[nomagic]
        private predicate revFlowIsReturned(
          Call call, ReturnCtx returnCtx, ApOption returnAp, ReturnPosition pos, Ap ap
        ) {
          exists(RetNd ret, CcCall ccc |
            revFlowOut(call, ret, pos, returnCtx, _, returnAp, ap) and
            returnFlowsThrough(ret, pos, ccc, _, _, _, _, ap) and
            matchesCall(ccc, call)
          )
        }

        pragma[nomagic]
        predicate storeStepCand(Nd node1, Content c, Nd node2, Type contentType, Type containerType) {
          exists(Ap ap2, Ap ap1 |
            PrevStage::storeStepCand(node1, c, node2, contentType, containerType) and
            revFlowStore(ap2, c, ap1, node1, node2, _, _) and
            revFlowConsCand(ap2, c, ap1)
          )
        }

        predicate readStepCand(Nd node1, Content c, Nd node2) {
          exists(Ap ap1, Ap ap2 |
            revFlow(node2, _, _, pragma[only_bind_into](ap2)) and
            readStepFwd(node1, ap1, c, node2, ap2) and
            revFlowStore(ap1, c, pragma[only_bind_into](ap2), _, _, _, _)
          )
        }

        predicate revFlow(Nd node, Ap ap) { revFlow(node, _, _, ap) }

        pragma[nomagic]
        predicate revFlow(Nd node) { revFlow(node, _, _, _) }

        private predicate fwdConsCand(Content c, Ap ap) { storeStepFwd(_, ap, c, _, _) }

        private predicate revConsCand(Content c, Ap ap) {
          exists(Ap ap2 |
            revFlowStore(ap2, c, ap, _, _, _, _) and
            revFlowConsCand(ap2, c, ap)
          )
        }

        private predicate validAp(Ap ap) {
          revFlow(_, _, _, ap) and ap instanceof ApNil
          or
          exists(Content head, Ap tail |
            consCand(head, tail) and
            ap = apCons(head, tail)
          )
        }

        additional predicate consCand(Content c, Ap ap) {
          revConsCand(c, ap) and
          validAp(ap)
        }

        pragma[nomagic]
        private predicate parameterFlowsThroughRev(ParamNd p, Ap ap, ReturnPosition pos, Ap returnAp) {
          revFlow(p, TReturnCtxMaybeFlowThrough(pos), apSome(returnAp), ap) and
          Stage1::parameterFlowThroughAllowed(p, pos.getKind())
        }

        pragma[nomagic]
        private predicate parameterMayFlowThroughAp(ParamNd p, Ap ap) {
          exists(ReturnPosition pos |
            returnFlowsThrough(_, pos, _, p, _, ap, _, _) and
            parameterFlowsThroughRev(p, ap, pos, _)
          )
        }

        pragma[nomagic]
        predicate parameterMayFlowThrough(ParamNd p, boolean emptyAp) {
          exists(Ap ap |
            parameterMayFlowThroughAp(p, ap) and
            emptyAp = isNil(ap)
          )
        }

        pragma[nomagic]
        private predicate nodeMayUseSummary0(Nd n, ParamNd p, Ap ap) {
          exists(Ap ap0 |
            parameterMayFlowThrough(p, _) and
            revFlow(n, TReturnCtxMaybeFlowThrough(_), _, ap0) and
            fwdFlow(n, any(CcCall ccc), TSummaryCtxSome(p, _, ap, _), _, ap0, _)
          )
        }

        /**
         * Holds if `ap` is recorded as the summary context for flow reaching `node`
         * and remains relevant for the following pruning stage.
         */
        pragma[nomagic]
        additional predicate nodeMayUseSummary(Nd n, Ap ap) {
          exists(ParamNd p |
            parameterMayFlowThroughAp(p, ap) and
            nodeMayUseSummary0(n, p, ap)
          )
        }

        pragma[nomagic]
        predicate returnMayFlowThrough(RetNd ret, ReturnKindExt kind) {
          exists(ParamNd p, ReturnPosition pos, Ap argAp, Ap ap |
            returnFlowsThrough(ret, pos, _, p, _, argAp, _, ap) and
            parameterFlowsThroughRev(p, argAp, pos, ap) and
            kind = pos.getKind()
          )
        }

        pragma[nomagic]
        private predicate revFlowThroughArg(
          Call call, ArgNd arg, ReturnCtx returnCtx, ApOption returnAp, Ap ap
        ) {
          exists(ParamNd p |
            revFlowThrough(call, returnCtx, p, returnAp, ap) and
            flowThroughIntoCall(call, arg, p, ap)
          )
        }

        pragma[nomagic]
        predicate callMayFlowThroughRev(Call call) {
          exists(ArgNd arg, ReturnCtx returnCtx, ApOption returnAp, Ap ap |
            revFlow(arg, returnCtx, returnAp, ap) and
            revFlowThroughArg(call, arg, returnCtx, returnAp, ap)
          )
        }

        predicate callEdgeArgParam(Call call, Callable c, ArgNd arg, ParamNd p, boolean emptyAp) {
          exists(Ap ap |
            flowIntoCallAp(call, c, arg, p, ap) and
            revFlow(arg, pragma[only_bind_into](ap)) and
            revFlow(p, pragma[only_bind_into](ap)) and
            emptyAp = isNil(ap)
          |
            // both directions are needed for flow-through
            RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
            RevTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
          )
        }

        predicate callEdgeReturn(
          Call call, Callable c, RetNd ret, ReturnKindExt kind, Nd out, boolean allowsFieldFlow
        ) {
          exists(ReturnPosition pos, Ap ap |
            flowOutOfCallAp(call, c, ret, pos, out, ap, allowsFieldFlow) and
            revFlow(ret, pragma[only_bind_into](ap)) and
            revFlow(out, pragma[only_bind_into](ap)) and
            kind = pos.getKind() and
            RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _)
          )
        }

        predicate relevantCallEdgeIn(Call call, Callable c) { callEdgeArgParam(call, c, _, _, _) }

        predicate relevantCallEdgeOut(Call call, Callable c) { callEdgeReturn(call, c, _, _, _, _) }

        /** Holds if `node1` can step to `node2` in one or more local steps. */
        signature predicate localStepSig(
          Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext lcc, string label
        );

        /**
         * Provides a big-step relation for local flow steps.
         *
         * The big-step releation is based on the `localStepInput` relation,
         * restricted to nodes that are forwards and backwards reachable in
         * this stage.
         */
        additional module LocalFlowBigStep<localStepSig/6 localStepInput> {
          final private class FinalNd = Nd;

          /**
           * A node where some checking is required, and hence the big-step relation
           * is not allowed to step over.
           */
          private class FlowCheckNode extends FinalNd {
            FlowCheckNode() {
              revFlow(this) and
              (
                flowCheckNode(this.getNodeEx()) or
                Config::neverSkip(this.getNodeEx().asNode())
              )
            }
          }

          private predicate additionalLocalStateStep(
            Nd node1, Nd node2, Type t, LocalCallContext lcc, string label
          ) {
            exists(ApNil nil |
              revFlow(node1, pragma[only_bind_into](nil)) and
              revFlow(node2, pragma[only_bind_into](nil)) and
              localStepInput(node1, node2, false, t, lcc, label) and
              isStateStep(node1, node2)
            )
          }

          /**
           * Holds if `node` can be the first node in a maximal subsequence of local
           * flow steps in a dataflow path.
           */
          private predicate localFlowEntry(Nd node, Ap ap) {
            revFlow(node, ap) and
            (
              sourceNode(node)
              or
              jumpStepEx(_, node)
              or
              additionalJumpStep(_, node, _)
              or
              node instanceof ParamNd
              or
              node instanceof OutNd
              or
              storeStepCand(_, _, node, _, _)
              or
              readStepCand(_, _, node)
              or
              node instanceof FlowCheckNode
              or
              additionalLocalStateStep(_, node, _, _, _)
            )
          }

          /**
           * Holds if `node` can be the last node in a maximal subsequence of local
           * flow steps in a dataflow path.
           */
          private predicate localFlowExit(Nd node, Ap ap) {
            revFlow(node, pragma[only_bind_into](ap)) and
            (
              exists(Nd next, Ap apNext | revFlow(next, apNext) |
                jumpStepEx(node, next) and
                apNext = ap
                or
                additionalJumpStep(node, next, _) and
                apNext = ap and
                ap instanceof ApNil
                or
                callEdgeArgParam(_, _, node, next, _) and
                apNext = ap
                or
                callEdgeReturn(_, _, node, _, next, _) and
                apNext = ap
                or
                storeStepCand(node, _, next, _, _)
                or
                readStepCand(node, _, next)
                or
                additionalLocalStateStep(node, next, _, _, _) and
                apNext = ap and
                ap instanceof ApNil
              )
              or
              node instanceof FlowCheckNode
              or
              sinkNode(node) and
              ap instanceof ApNil
            )
          }

          /**
           * Holds if the local path from `node1` to `node2` is a prefix of a maximal
           * subsequence of local flow steps in a dataflow path.
           *
           * This is the transitive closure of `[additional]localFlowStep` beginning
           * at `localFlowEntry`.
           */
          pragma[nomagic]
          private predicate localFlowStepPlus(
            Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext cc, string label
          ) {
            exists(Nd mid, boolean preservesValue2, Type t2, string label2, Ap ap |
              localStepInput(mid, node2, preservesValue2, t2, cc, label2) and
              not isStateStep(mid, node2) and
              revFlow(node2, pragma[only_bind_into](ap)) and
              (preservesValue = true or ap instanceof ApNil)
            |
              node1 = mid and
              localFlowEntry(node1, pragma[only_bind_into](ap)) and
              preservesValue = preservesValue2 and
              label = label2 and
              t = t2 and
              node1 != node2
              or
              exists(boolean preservesValue1, Type t1, string label1 |
                localFlowStepPlus(node1, mid, preservesValue1, t1, cc, label1) and
                not mid instanceof FlowCheckNode and
                preservesValue = preservesValue2.booleanAnd(preservesValue1) and
                label = mergeLabels(label1, label2) and
                if preservesValue2 = true then t = t1 else t = t2
              )
            )
          }

          /**
           * Holds if `node1` can step to `node2` in one or more local steps and this
           * path can occur as a maximal subsequence of local steps in a dataflow path.
           */
          pragma[nomagic]
          predicate localFlowBigStep(
            Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext callContext,
            string label
          ) {
            exists(Ap ap |
              localFlowStepPlus(node1, node2, preservesValue, t, callContext, label) and
              localFlowExit(node2, ap) and
              node1 != node2
            |
              preservesValue = true or ap instanceof ApNil
            )
            or
            additionalLocalStateStep(node1, node2, t, callContext, label) and
            preservesValue = false
          }

          /**
           * Holds if `node1` can step to `node2` in one or more local steps and this
           * path can occur as a maximal subsequence of local steps in a dataflow path.
           *
           * This predicate should be used when `localStepInput` is already a big-step
           * relation, which will do the same as `localFlowBigStep`, but avoids potential
           * worst-case quadratic complexity.
           */
          pragma[nomagic]
          predicate localFlowBigStepTc(
            Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext callContext,
            string label
          ) {
            exists(Ap ap |
              localFlowEntry(node1, pragma[only_bind_into](ap)) and
              localStepInput(node1, node2, preservesValue, t, callContext, label) and
              localFlowExit(node2, pragma[only_bind_into](ap)) and
              not isStateStep(node1, node2)
            |
              preservesValue = true or ap instanceof ApNil
            )
            or
            additionalLocalStateStep(node1, node2, t, callContext, label) and
            preservesValue = false
          }
        }

        /**
         * Provides a graph representation of the data flow in this stage suitable for use in a `path-problem` query.
         */
        additional module Graph {
          private newtype TPathNode =
            TPathNodeMid(Nd node, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored) {
              fwdFlow(node, cc, summaryCtx, t, ap, stored) and
              revFlow(node, _, _, ap)
            } or
            TPathNodeSink(Nd node) {
              exists(PathNodeMid sink |
                sink.isAtSink() and
                node = sink.toNormalSinkNode()
              )
            } or
            TPathNodeSrcGrp() or
            TPathNodeSinkGrp()

          class PathNodeImpl extends TPathNode {
            abstract NodeEx getNodeEx();

            /** Gets the `FlowState` of this node. */
            abstract FlowState getState();

            /** Holds if this node is a source. */
            abstract predicate isSource();

            /** Holds if this node is a sink. */
            predicate isSink() { this instanceof TPathNodeSink }

            abstract PathNodeImpl getASuccessorImpl(string label);

            pragma[nomagic]
            PathNodeImpl getAnImplicitReadSuccessorAtSink(string label) {
              exists(PathNodeMid readTarget |
                result = this.getASuccessorImpl(_) and
                localStep(this, readTarget, _) and
                readTarget.getNodeEx().isImplicitReadNode(_)
              |
                // last implicit read, leaving the access path empty
                result = readTarget.projectToSink(label)
                or
                // implicit read, leaving the access path non-empty
                exists(result.getAnImplicitReadSuccessorAtSink(label)) and
                result = readTarget
              )
            }

            private PathNodeImpl getASuccessorIfHidden(string label) {
              this.isHidden() and
              result = this.getASuccessorImpl(label)
              or
              result = this.getAnImplicitReadSuccessorAtSink(label)
            }

            private PathNodeImpl getASuccessorFromNonHidden(string label) {
              result = this.getASuccessorImpl(label) and
              not this.isHidden() and
              // In cases like
              //
              // ```
              // x.Field = taint;
              // Sink(x);
              // ```
              //
              // we only want the direct edge
              //
              //  `[post update] x [Field]` -> `x`
              //
              // and not the two edges
              //
              //  `[post update] x [Field]` -> `x [Field]`
              //  `x [Field]`               -> `x`
              //
              // which the restriction below ensures.
              not result = this.getAnImplicitReadSuccessorAtSink(_)
              or
              exists(string l1, string l2 |
                result = this.getASuccessorFromNonHidden(l1).getASuccessorIfHidden(l2) and
                label = mergeLabels(l1, l2)
              )
            }

            final PathNodeImpl getANonHiddenSuccessor(string label) {
              result = this.getASuccessorFromNonHidden(label) and not result.isHidden()
            }

            predicate isHidden() {
              not Config::includeHiddenNodes() and
              hiddenNode(this.getNodeEx()) and
              not this.isSource() and
              not this instanceof PathNodeSink
            }

            /** Gets a textual representation of this element. */
            abstract string toString();

            /** Gets the location of this node. */
            Location getLocation() { result = this.getNodeEx().getLocation() }

            predicate isArbitrarySource() { this instanceof TPathNodeSrcGrp }

            predicate isArbitrarySink() { this instanceof TPathNodeSinkGrp }
          }

          private class PathNodeSrcGrp extends PathNodeImpl, TPathNodeSrcGrp {
            override string toString() { result = "<any source>" }

            override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }

            override NodeEx getNodeEx() { none() }

            override FlowState getState() { none() }

            override PathNodeImpl getASuccessorImpl(string label) {
              result.isSource() and label = ""
            }

            override predicate isSource() { none() }
          }

          private class PathNodeSinkGrp extends PathNodeImpl, TPathNodeSinkGrp {
            override string toString() { result = "<any sink>" }

            override Location getLocation() { result.hasLocationInfo("", 0, 0, 0, 0) }

            override NodeEx getNodeEx() { none() }

            override FlowState getState() { none() }

            override PathNodeImpl getASuccessorImpl(string label) { none() }

            override predicate isSource() { none() }
          }

          /**
           * An intermediate flow graph node. This is a tuple consisting of a node,
           * a `FlowState`, a call context, a summary context, a tracked type, and an access path.
           */
          private class PathNodeMid extends PathNodeImpl, TPathNodeMid {
            Nd node;
            Cc cc;
            SummaryCtx summaryCtx;
            Typ t;
            Ap ap;
            TypOption stored;

            PathNodeMid() { this = TPathNodeMid(node, cc, summaryCtx, t, ap, stored) }

            override NodeEx getNodeEx() { result = node.getNodeEx() }

            override FlowState getState() { result = node.getState() }

            private PathNodeMid getSuccMid(string label) {
              localStep(this, result, label)
              or
              nonLocalStep(this, result, label)
            }

            private predicate isSourceWithLabel(string labelprefix) {
              exists(string model |
                this.isSource() and
                sourceModel(node, model) and
                model != "" and
                labelprefix = "Src:" + model + " "
              )
            }

            /** If this node corresponds to a sink, gets the normal node for that sink. */
            pragma[nomagic]
            Nd toNormalSinkNode() { result = toNormalSinkNode(node) }

            override PathNodeImpl getASuccessorImpl(string label) {
              // an intermediate step to another intermediate node
              exists(string l2 | result = this.getSuccMid(l2) |
                not this.isSourceWithLabel(_) and label = l2
                or
                exists(string l1 |
                  this.isSourceWithLabel(l1) and
                  label = l1 + l2
                )
              )
              or
              // a final step to a sink
              exists(string l2, string sinkLabel |
                result = this.getSuccMid(l2).projectToSink(sinkLabel)
              |
                not this.isSourceWithLabel(_) and
                label = mergeLabels(l2, sinkLabel)
                or
                exists(string l1 |
                  this.isSourceWithLabel(l1) and
                  label = l1 + mergeLabels(l2, sinkLabel)
                )
              )
            }

            private string ppType() {
              exists(string ppt | ppt = t.toString() |
                if ppt = "" then result = "" else result = " : " + ppt
              )
            }

            private string ppAp() {
              exists(string s | s = ap.toString() |
                if s = "" then result = "" else result = " " + s
              )
            }

            private string ppCtx() { result = " <" + cc + ">" }

            private string ppSummaryCtx() {
              summaryCtx instanceof SummaryCtxNone and result = ""
              or
              summaryCtx instanceof SummaryCtxSome and
              result = " <" + summaryCtx + ">"
            }

            override string toString() {
              result = node.toString() + this.ppType() + this.ppAp() + ppStored(stored)
            }

            /**
             * Gets a textual representation of this element, including a textual
             * representation of the call context.
             */
            string toStringWithContext() {
              result =
                node.toString() + this.ppType() + this.ppAp() + ppStored(stored) + this.ppCtx() +
                  this.ppSummaryCtx()
            }

            override predicate isSource() {
              sourceNode(node) and
              (if hasSourceCallCtx() then cc = ccSomeCall() else cc = ccNone()) and
              summaryCtx = TSummaryCtxNone() and
              t = getNodeTyp(node) and
              ap instanceof ApNil
            }

            predicate isAtSink() {
              sinkNode(node) and
              ap instanceof ApNil and
              // For `FeatureHasSinkCallContext` the condition `cc instanceof CallContextNoCall`
              // is exactly what we need to check.
              // For `FeatureEqualSourceSinkCallContext` the initial call
              // context was set to `CallContextSomeCall` and jumps are
              // disallowed, so `cc instanceof CallContextNoCall` never holds.
              // On the other hand, in this case there's never any need to
              // enter a call except to identify a summary, so the condition in
              // conjunction with setting the summary context enforces this,
              // which means that the summary context being empty holds if and
              // only if we are in the call context of the source.
              if Config::getAFeature() instanceof FeatureEqualSourceSinkCallContext
              then summaryCtx = TSummaryCtxNone()
              else
                if Config::getAFeature() instanceof FeatureHasSinkCallContext
                then instanceofCcNoCall(cc)
                else any()
            }

            PathNodeSink projectToSink(string label) {
              exists(string model |
                this.isAtSink() and
                sinkModel(node, model) and
                result = TPathNodeSink(this.toNormalSinkNode()) and
                if model != "" then label = "Sink:" + model else label = ""
              )
            }
          }

          /**
           * A flow graph node corresponding to a sink. This is disjoint from the
           * intermediate nodes in order to uniquely correspond to a given sink by
           * excluding the call context.
           */
          private class PathNodeSink extends PathNodeImpl, TPathNodeSink {
            Nd node;

            PathNodeSink() { this = TPathNodeSink(node) }

            override NodeEx getNodeEx() { result = node.getNodeEx() }

            override FlowState getState() { result = node.getState() }

            override string toString() { result = node.toString() }

            override PathNodeImpl getASuccessorImpl(string label) {
              result.isArbitrarySink() and label = ""
            }

            override predicate isSource() { sourceNode(node) }
          }

          bindingset[p, t, ap, stored]
          pragma[inline_late]
          private SummaryCtxSome mkSummaryCtxSome(ParamNd p, Typ t, Ap ap, TypOption stored) {
            result = TSummaryCtxSome(p, t, ap, stored)
          }

          pragma[nomagic]
          private predicate fwdFlowInStep(
            ArgNd arg, ParamNd p, Cc outercc, CcCall innercc, SummaryCtx outerSummaryCtx,
            SummaryCtx innerSummaryCtx, Typ t, Ap ap, TypOption stored
          ) {
            FwdFlowInNoThrough::fwdFlowIn(_, arg, _, p, outercc, innercc, outerSummaryCtx, t, ap,
              stored, _) and
            innerSummaryCtx = TSummaryCtxNone()
            or
            FwdFlowInThrough::fwdFlowIn(_, arg, _, p, outercc, innercc, outerSummaryCtx, t, ap,
              stored, _) and
            innerSummaryCtx = mkSummaryCtxSome(p, t, ap, stored)
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep0(
            Call call, ArgNd arg, Cc cc, CcCall ccc, SummaryCtx summaryCtx, Typ t, Ap ap,
            TypOption stored, RetNd ret, SummaryCtxSome innerSummaryCtx
          ) {
            fwdFlowThrough0(call, arg, cc, ccc, summaryCtx, t, ap, stored, ret, innerSummaryCtx)
          }

          bindingset[node, cc, summaryCtx, t, ap, stored]
          pragma[inline_late]
          private PathNodeImpl mkPathNode(
            Nd node, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
          ) {
            result = TPathNodeMid(node, cc, summaryCtx, t, ap, stored)
          }

          private PathNodeImpl typeStrengthenToPathNode(
            Nd node, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap, TypOption stored
          ) {
            exists(Typ t |
              fwdFlow1(node, cc, summaryCtx, t0, t, ap, stored) and
              result = TPathNodeMid(node, cc, summaryCtx, t, ap, stored)
            )
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep1(
            PathNodeImpl pn1, PathNodeImpl pn2, PathNodeImpl pn3, Call call, Cc cc,
            SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored, RetNd ret
          ) {
            exists(
              ArgNd arg, SummaryCtxSome innerSummaryCtx, ParamNd p, Typ innerArgT, Ap innerArgAp,
              TypOption innerArgStored, CcCall ccc
            |
              fwdFlowThroughStep0(call, arg, cc, ccc, summaryCtx, t, ap, stored, ret,
                innerSummaryCtx) and
              innerSummaryCtx = TSummaryCtxSome(p, innerArgT, innerArgAp, innerArgStored) and
              pn1 = mkPathNode(arg, cc, summaryCtx, innerArgT, innerArgAp, innerArgStored) and
              pn2 =
                typeStrengthenToPathNode(p, ccc, innerSummaryCtx, innerArgT, innerArgAp,
                  innerArgStored) and
              pn3 = mkPathNode(ret, ccc, innerSummaryCtx, t, ap, stored)
            )
          }

          pragma[nomagic]
          private predicate fwdFlowThroughStep2(
            PathNodeImpl pn1, PathNodeImpl pn2, PathNodeImpl pn3, Nd node, Cc cc,
            SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored
          ) {
            exists(Call call, RetNd ret, boolean allowsFieldFlow |
              fwdFlowThroughStep1(pn1, pn2, pn3, call, cc, summaryCtx, t, ap, stored, ret) and
              flowThroughOutOfCall(call, ret, node, allowsFieldFlow) and
              if allowsFieldFlow = false then ap instanceof ApNil else any()
            )
          }

          private predicate localStep(
            PathNodeImpl pn1, Nd node, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored,
            string label, boolean isStoreStep
          ) {
            exists(Nd mid, Typ t0, LocalCc localCc |
              pn1 = TPathNodeMid(mid, cc, summaryCtx, t0, ap, stored) and
              localCc = getLocalCc(cc) and
              isStoreStep = false
            |
              localStep(mid, node, true, _, localCc, label) and
              t = t0
              or
              localStep(mid, node, false, t, localCc, label) and
              ap instanceof ApNil
            )
            or
            // store
            exists(Nd mid, Content c, Typ t0, Ap ap0, TypOption stored0 |
              pn1 = TPathNodeMid(mid, cc, summaryCtx, t0, ap0, stored0) and
              fwdFlowStore(mid, t0, ap0, stored0, c, t, stored, node, cc, summaryCtx) and
              ap = apCons(c, ap0) and
              label = "" and
              isStoreStep = true
            )
            or
            // read
            exists(Nd mid, Typ t0, Ap ap0, TypOption stored0 |
              pn1 = TPathNodeMid(mid, cc, summaryCtx, t0, ap0, stored0) and
              fwdFlowRead(mid, t0, ap0, stored0, _, node, t, ap, stored, cc, summaryCtx) and
              label = "" and
              isStoreStep = false
            )
          }

          private predicate localStep(PathNodeImpl pn1, PathNodeImpl pn2, string label) {
            exists(
              Nd node, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap, TypOption stored,
              boolean isStoreStep
            |
              localStep(pn1, node, cc, summaryCtx, t0, ap, stored, label, isStoreStep) and
              pn2 = typeStrengthenToPathNode(node, cc, summaryCtx, t0, ap, stored) and
              stepFilter(node, ap, isStoreStep)
            )
            or
            summaryStep(pn1, pn2, label)
          }

          private predicate summaryLabel(PathNodeImpl pn1, PathNodeImpl pn2, string summaryLabel) {
            pn1 = pn2 and
            summaryLabel = "" and
            subpathsImpl(_, pn1, _, _)
            or
            exists(PathNodeImpl mid, string l1, string l2 |
              summaryLabel(pn1, mid, l1) and
              localStep(mid, pn2, l2) and
              summaryLabel = mergeLabels(l1, l2)
            )
          }

          private predicate summaryStep(PathNodeImpl arg, PathNodeImpl out, string label) {
            exists(PathNodeImpl par, PathNodeImpl ret |
              subpathsImpl(arg, par, ret, out) and
              summaryLabel(par, ret, label)
            )
          }

          private predicate nonLocalStep(
            PathNodeImpl pn1, Nd node, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored,
            string label
          ) {
            // jump
            exists(Nd mid, Typ t0 |
              pn1 = TPathNodeMid(mid, _, _, t0, ap, stored) and
              cc = ccNone() and
              summaryCtx = TSummaryCtxNone()
            |
              jumpStepEx(mid, node) and
              t = t0 and
              label = ""
              or
              additionalJumpStep(mid, node, label) and
              t = getNodeTyp(node) and
              ap instanceof ApNil
            )
            or
            // flow into a callable
            exists(ArgNd arg, Cc outercc, SummaryCtx outerSummaryCtx |
              pn1 = TPathNodeMid(arg, outercc, outerSummaryCtx, t, ap, stored) and
              fwdFlowInStep(arg, node, outercc, cc, outerSummaryCtx, summaryCtx, t, ap, stored) and
              label = ""
            )
            or
            // flow out of a callable
            exists(RetNd ret, CcNoCall innercc, boolean allowsFieldFlow |
              pn1 = TPathNodeMid(ret, innercc, summaryCtx, t, ap, stored) and
              fwdFlowIntoRet(ret, innercc, summaryCtx, t, ap, stored) and
              fwdFlowOutValidEdge(_, ret, innercc, _, node, cc, allowsFieldFlow) and
              label = "" and
              if allowsFieldFlow = false then ap instanceof ApNil else any()
            )
          }

          private predicate nonLocalStep(PathNodeImpl pn1, PathNodeImpl pn2, string label) {
            exists(Nd node, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap, TypOption stored |
              nonLocalStep(pn1, node, cc, summaryCtx, t0, ap, stored, label) and
              pn2 = typeStrengthenToPathNode(node, cc, summaryCtx, t0, ap, stored) and
              stepFilter(node, ap, false)
            )
          }

          /**
           * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
           *
           * All of the nodes may be hidden.
           */
          private predicate subpathsImpl(
            PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
          ) {
            exists(
              Nd node, Cc cc, SummaryCtx summaryCtx, Typ t0, Ap ap, TypOption stored,
              PathNodeImpl out0
            |
              fwdFlowThroughStep2(arg, par, ret, node, cc, summaryCtx, t0, ap, stored) and
              out0 = typeStrengthenToPathNode(node, cc, summaryCtx, t0, ap, stored) and
              stepFilter(node, ap, false)
            |
              out = out0 or out = out0.(PathNodeMid).projectToSink(_)
            )
          }

          module StagePathGraph {
            predicate edges(PathNodeImpl a, PathNodeImpl b, string key, string val) {
              a.getASuccessorImpl(val) = b and
              key = "provenance"
            }

            query predicate nodes(PathNodeImpl n, string key, string val) {
              key = "semmle.label" and val = n.toString()
            }

            query predicate subpaths = subpathsImpl/4;
          }

          module Public {
            private PathNodeImpl localStep(PathNodeImpl n) { localStep(n, result, _) }

            private predicate localStepToHidden(PathNodeImpl n1, PathNodeImpl n2) {
              n2 = localStep(n1) and
              n2.isHidden()
            }

            private predicate localStepFromHidden(PathNodeImpl n1, PathNodeImpl n2) {
              n2 = localStep(n1) and
              n1.isHidden()
              or
              n2 = n1.getAnImplicitReadSuccessorAtSink(_)
            }

            bindingset[par, ret]
            pragma[inline_late]
            private predicate localStepStar(PathNodeImpl par, PathNodeImpl ret) {
              localStep*(par) = ret
            }

            /**
             * Holds if `(arg, par, ret, out)` forms a subpath-tuple.
             *
             * `par` and `ret` are not hidden.
             */
            pragma[nomagic]
            private predicate subpaths1(
              PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
            ) {
              // direct subpath
              subpathsImpl(arg, any(PathNodeImpl n | localStepFromHidden*(n, par)),
                any(PathNodeImpl n | localStepToHidden*(ret, n)), out) and
              not par.isHidden() and
              not ret.isHidden() and
              localStepStar(par, ret)
              or
              // wrapped subpath using hidden nodes, e.g. flow through a callback inside
              // a summarized callable
              exists(PathNodeImpl par0, PathNodeImpl ret0 |
                subpaths1(any(PathNodeImpl n | localStepToHidden*(par0, n)), par, ret,
                  any(PathNodeImpl n | localStepFromHidden*(n, ret0))) and
                subpathsImpl(arg, par0, ret0, out)
              )
            }

            /**
             * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
             * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
             * `ret -> out` is summarized as the edge `arg -> out`.
             *
             * None of the nodes are hidden.
             */
            pragma[nomagic]
            private predicate subpaths2(
              PathNodeImpl arg, PathNodeImpl par, PathNodeImpl ret, PathNodeImpl out
            ) {
              exists(PathNodeImpl out0 |
                subpaths1(any(PathNodeImpl n | localStepToHidden*(arg, n)), par, ret,
                  any(PathNodeImpl n | localStepFromHidden*(n, out0))) and
                not arg.isHidden() and
                not out0.isHidden()
              |
                out = out0 or out = out0.(PathNodeMid).projectToSink(_)
              )
            }

            /** Holds if `n` is reachable from a source. */
            private predicate fwdReach(PathNodeImpl n) {
              n.isArbitrarySource()
              or
              exists(PathNodeImpl mid | fwdReach(mid) and mid.getANonHiddenSuccessor(_) = n)
            }

            /** Holds if `n` is reachable from a source and can reach a sink. */
            private predicate directReach(PathNodeImpl n) {
              fwdReach(n) and
              (
                n.isArbitrarySink() or
                directReach(n.getANonHiddenSuccessor(_))
              )
            }

            /**
             * Holds if `n` can reach a return node in a summarized subpath that can reach a sink.
             */
            private predicate retReach(PathNodeImpl n) {
              fwdReach(n) and
              (
                exists(PathNodeImpl out | subpaths2(_, _, n, out) |
                  directReach(out) or retReach(out)
                )
                or
                exists(PathNodeImpl mid |
                  retReach(mid) and
                  n.getANonHiddenSuccessor(_) = mid and
                  not subpaths2(_, mid, _, _)
                )
              )
            }

            /** Holds if `n` can reach a sink or is used in a subpath that can reach a sink. */
            private predicate reach(PathNodeImpl n) { directReach(n) or retReach(n) }

            /**
             * A `Node` augmented with a call context (except for sinks) and an access path.
             * Only those `PathNode`s that are reachable from a source, and which can reach a sink, are generated.
             */
            class PathNode instanceof PathNodeImpl {
              PathNode() {
                reach(this) and
                not this instanceof PathNodeSrcGrp and
                not this instanceof PathNodeSinkGrp
              }

              /** Gets a textual representation of this element. */
              final string toString() { result = super.toString() }

              /**
               * Gets a textual representation of this element, including a textual
               * representation of the call context.
               */
              final string toStringWithContext() {
                result = this.(PathNodeMid).toStringWithContext()
                or
                not this instanceof PathNodeMid and result = this.toString()
              }

              /** Gets the location of this node. */
              Location getLocation() { result = super.getLocation() }

              /** Gets the underlying `Node`. */
              final Node getNode() { super.getNodeEx().projectToNode() = result }

              /** Gets the parameter node through which data is returned, if any. */
              final ParameterNode asParameterReturnNode() {
                result = super.getNodeEx().asParamReturnNode()
              }

              /** Gets the `FlowState` of this node. */
              final FlowState getState() { result = super.getState() }

              /** Gets a successor of this node, if any. */
              final PathNode getASuccessor() { result = super.getANonHiddenSuccessor(_) }

              /** Holds if this node is a source. */
              final predicate isSource() { super.isSource() }

              /** Holds if this node is a sink. */
              final predicate isSink() { this instanceof PathNodeSink }

              /**
               * Holds if this element is at the specified location.
               * The location spans column `startcolumn` of line `startline` to
               * column `endcolumn` of line `endline` in file `filepath`.
               * For more information, see
               * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
               */
              overlay[caller?]
              pragma[inline]
              deprecated final predicate hasLocationInfo(
                string filepath, int startline, int startcolumn, int endline, int endcolumn
              ) {
                this.getLocation()
                    .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
              }

              /**
               * DEPRECATED: This functionality is no longer available.
               *
               * Holds if this node is a grouping of source nodes.
               */
              deprecated final predicate isSourceGroup(string group) { none() }

              /**
               * DEPRECATED: This functionality is no longer available.
               *
               * Holds if this node is a grouping of sink nodes.
               */
              deprecated final predicate isSinkGroup(string group) { none() }
            }

            /** Holds if `n1.getASuccessor() = n2` and `n2` can reach a sink. */
            private predicate pathSucc(PathNodeImpl n1, PathNodeImpl n2) {
              n1.getANonHiddenSuccessor(_) = n2 and directReach(n2)
            }

            private predicate tcSrc(PathNodeImpl n) { n.isSource() }

            private predicate tcSink(PathNodeImpl n) { n.isSink() }

            private predicate pathSuccPlus(PathNodeImpl n1, PathNodeImpl n2) =
              doublyBoundedFastTC(pathSucc/2, tcSrc/1, tcSink/1)(n1, n2)

            /**
             * Holds if data can flow from `source` to `sink`.
             *
             * The corresponding paths are generated from the end-points and the graph
             * included in the module `PathGraph`.
             */
            predicate flowPath(PathNode source, PathNode sink) {
              (
                // When there are both sources and sinks in the diff range,
                // diff-informed dataflow falls back to computing all paths without
                // any filtering. To prevent significant alert flip-flopping due to
                // minor code changes triggering the fallback, we consistently apply
                // source-or-sink filtering here to ensure that we return the same
                // paths regardless of whether the fallback is triggered.
                if Config::observeDiffInformedIncrementalMode()
                then Stage1::isRelevantSourceSinkPair(source.getNode(), sink.getNode())
                else any()
              ) and
              exists(PathNodeImpl flowsource, PathNodeImpl flowsink |
                source = flowsource and sink = flowsink
              |
                flowsource.isSource() and
                (flowsource = flowsink or pathSuccPlus(flowsource, flowsink)) and
                flowsink.isSink()
              )
            }

            /**
             * Provides the query predicates needed to include a graph in a path-problem query.
             */
            module PathGraph implements PathGraphSig<PathNode> {
              /** Holds if `(a,b)` is an edge in the graph of data flow path explanations. */
              query predicate edges(PathNode a, PathNode b, string key, string val) {
                a.(PathNodeImpl).getANonHiddenSuccessor(val) = b and
                key = "provenance"
              }

              /** Holds if `n` is a node in the graph of data flow path explanations. */
              query predicate nodes(PathNode n, string key, string val) {
                key = "semmle.label" and val = n.toString()
              }

              /**
               * Holds if `(arg, par, ret, out)` forms a subpath-tuple, that is, flow through
               * a subpath between `par` and `ret` with the connecting edges `arg -> par` and
               * `ret -> out` is summarized as the edge `arg -> out`.
               */
              query predicate subpaths(PathNode arg, PathNode par, PathNode ret, PathNode out) {
                subpaths2(arg, par, ret, out)
              }
            }
          }
        }

        additional predicate stats(
          boolean fwd, int nodes, int fields, int conscand, int states, int tuples, int calledges,
          int tfnodes, int tftuples
        ) {
          fwd = true and
          nodes = count(NodeEx node | fwdFlow(any(Nd n | n.getNodeEx() = node), _, _, _, _, _)) and
          fields = count(Content f0 | fwdConsCand(f0, _)) and
          conscand = count(Content f0, Ap ap | fwdConsCand(f0, ap)) and
          states = count(FlowState state | fwdFlow(any(Nd n | n.getState() = state), _, _, _, _, _)) and
          tuples =
            count(Nd n, Cc cc, SummaryCtx summaryCtx, Typ t, Ap ap, TypOption stored |
              fwdFlow(n, cc, summaryCtx, t, ap, stored)
            ) and
          calledges =
            count(Call call, Callable c |
              FwdTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
              FwdTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
            ) and
          FwdTypeFlow::typeFlowStats(tfnodes, tftuples)
          or
          fwd = false and
          nodes = count(NodeEx node | revFlow(any(Nd n | n.getNodeEx() = node), _, _, _)) and
          fields = count(Content f0 | consCand(f0, _)) and
          conscand = count(Content f0, Ap ap | consCand(f0, ap)) and
          states = count(FlowState state | revFlow(any(Nd n | n.getState() = state), _, _, _)) and
          tuples =
            count(Nd n, ReturnCtx returnCtx, ApOption retAp, Ap ap |
              revFlow(n, returnCtx, retAp, ap)
            ) and
          calledges =
            count(Call call, Callable c |
              RevTypeFlowInput::dataFlowTakenCallEdgeIn(call, c, _) or
              RevTypeFlowInput::dataFlowTakenCallEdgeOut(call, c)
            ) and
          RevTypeFlow::typeFlowStats(tfnodes, tftuples)
        }
        /* End: Stage logic. */
      }
    }

    private module BooleanCallContext {
      class Cc = Boolean;

      class CcCall extends Cc {
        CcCall() { this = true }
      }

      /** Holds if the call context may be `call`. */
      predicate matchesCall(CcCall cc, Call call) { any() }

      class CcNoCall extends Cc {
        CcNoCall() { this = false }
      }

      Cc ccNone() { result = false }

      CcCall ccSomeCall() { result = true }

      predicate instanceofCc(Cc cc) { any() }

      predicate instanceofCcCall(CcCall cc) { any() }

      predicate instanceofCcNoCall(CcNoCall cc) { any() }

      class LocalCc = Unit;

      bindingset[cc]
      LocalCc getLocalCc(Cc cc) { any() }

      Callable viableImplCallContextReduced(Call call, CcCall ctx) { none() }

      bindingset[call, ctx]
      predicate viableImplNotCallContextReduced(Call call, Cc ctx) { any() }

      bindingset[call, c]
      CcCall getCallContextCall(Call call, Callable c) { any() }

      Call viableImplCallContextReducedReverse(Callable c, CcNoCall ctx) { none() }

      predicate viableImplNotCallContextReducedReverse(CcNoCall ctx) { any() }

      bindingset[call, c]
      CcNoCall getCallContextReturn(Callable c, Call call) { any() }
    }

    private module S1 implements StageSig {
      import Stage1
    }

    private module Stage2Param implements MkStage<S1>::StageParam {
      private module PrevStage = Stage1;

      class Typ = Unit;

      class Ap = Boolean;

      class ApNil extends Ap {
        ApNil() { this = false }
      }

      bindingset[result, ap]
      PrevStage::Ap getApprox(Ap ap) { any() }

      Typ getTyp(Type t) { any() }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) {
        result = true and
        exists(c) and
        if tail = true then Config::accessPathLimit() > 1 else any()
      }

      class ApHeadContent = Unit;

      overlay[caller?]
      pragma[inline]
      ApHeadContent getHeadContent(Ap ap) { exists(result) and ap = true }

      ApHeadContent projectToHeadContent(Content c) { any() }

      class ApOption = BooleanOption;

      ApOption apNone() { result = TBooleanNone() }

      ApOption apSome(Ap ap) { result = TBooleanSome(ap) }

      import CachedCallContextSensitivity
      import NoLocalCallContext

      predicate localStep(
        Nd node1, Nd node2, boolean preservesValue, Typ t, LocalCc lcc, string label
      ) {
        localStep1(node1, node2, preservesValue, _, _, label) and
        exists(t) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate expectsContentCand(Nd node) {
        exists(Content c |
          PrevStage::revFlow(node) and
          PrevStage::revFlowIsReadAndStored(c) and
          Stage1::expectsContentEx(node, c)
        )
      }

      bindingset[node, t0, ap]
      predicate filter(Nd node, Typ t0, Ap ap, Typ t) {
        t0 = t and
        exists(ap) and
        (
          Stage1::notExpectsContent(node)
          or
          ap = true and
          expectsContentCand(node)
        )
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(Nd node, Ap ap, boolean isStoreStep) { any() }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { any() }

      predicate enableTypeFlow() { none() }
    }

    private module Stage2 = MkStage<S1>::Stage<Stage2Param>;

    private module Stage3Param implements MkStage<Stage2>::StageParam {
      private module PrevStage = Stage2;

      class Typ = Unit;

      class Ap = ApproxAccessPathFront;

      class ApNil = ApproxAccessPathFrontNil;

      PrevStage::Ap getApprox(Ap ap) { result = ap.toBoolNonEmpty() }

      Typ getTyp(Type t) { any() }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) { result.getAHead() = c and exists(tail) }

      class ApHeadContent = ContentApprox;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      predicate projectToHeadContent = getContentApproxCached/1;

      class ApOption = ApproxAccessPathFrontOption;

      ApOption apNone() { result = TApproxAccessPathFrontNone() }

      ApOption apSome(Ap ap) { result = TApproxAccessPathFrontSome(ap) }

      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          CachedCallContextSensitivity::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand =
          CachedCallContextSensitivity::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import NoLocalCallContext

      additional predicate localFlowBigStep(
        Nd node1, Nd node2, boolean preservesValue, Type t, LocalCallContext lcc, string label
      ) {
        PrevStage::LocalFlowBigStep<localStep1/6>::localFlowBigStep(node1, node2, preservesValue, t,
          lcc, label)
      }

      predicate localStep(
        Nd node1, Nd node2, boolean preservesValue, Typ t, LocalCc lcc, string label
      ) {
        localFlowBigStep(node1, node2, preservesValue, _, _, label) and
        exists(t) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate expectsContentCand(Nd node, Ap ap) {
        exists(Content c |
          PrevStage::revFlow(node) and
          PrevStage::readStepCand(_, c, _) and
          Stage1::expectsContentEx(node, c) and
          c = ap.getAHead()
        )
      }

      bindingset[node, t0, ap]
      predicate filter(Nd node, Typ t0, Ap ap, Typ t) {
        t0 = t and
        (
          Stage1::notExpectsContent(node)
          or
          expectsContentCand(node, ap)
        )
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(Nd node, Ap ap, boolean isStoreStep) { any() }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { any() }
    }

    private module Stage3 = MkStage<Stage2>::Stage<Stage3Param>;

    bindingset[node, t0]
    private predicate strengthenType(Nd node, Type t0, Type t) {
      if node instanceof CastingNd
      then
        exists(Type nt | nt = node.getType() |
          if typeStrongerThanFilter(nt, t0)
          then t = nt
          else (
            compatibleTypesFilter(nt, t0) and t = t0
          )
        )
      else t = t0
    }

    private module Stage4Param implements MkStage<Stage3>::StageParam {
      private module PrevStage = Stage3;

      class Typ = Unit;

      class Ap = AccessPathFront;

      class ApNil = AccessPathFrontNil;

      PrevStage::Ap getApprox(Ap ap) { result = ap.toApprox() }

      Typ getTyp(Type t) { any() }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) { result.getHead() = c and exists(tail) }

      class ApHeadContent = Content;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      ApHeadContent projectToHeadContent(Content c) { result = c }

      class ApOption = AccessPathFrontOption;

      ApOption apNone() { result = TAccessPathFrontNone() }

      ApOption apSome(Ap ap) { result = TAccessPathFrontSome(ap) }

      import BooleanCallContext

      pragma[nomagic]
      predicate localStep(
        Nd node1, Nd node2, boolean preservesValue, Typ t, LocalCc lcc, string label
      ) {
        Stage3Param::localFlowBigStep(node1, node2, preservesValue, _, _, label) and
        PrevStage::revFlow(node1) and
        PrevStage::revFlow(node2) and
        exists(t) and
        exists(lcc)
      }

      pragma[nomagic]
      private predicate clearSet(Nd node, ContentSet c) {
        PrevStage::revFlow(node) and
        clearsContentSet(node.getNodeEx(), c)
      }

      pragma[nomagic]
      additional predicate clearContent(Nd node, Content c, boolean isStoreTarget) {
        exists(ContentSet cs |
          PrevStage::readStepCand(_, pragma[only_bind_into](c), _) and
          c = cs.getAReadContent() and
          clearSet(node, cs) and
          if PrevStage::storeStepCand(_, _, node, _, _)
          then isStoreTarget = true
          else isStoreTarget = false
        )
      }

      pragma[nomagic]
      private predicate clear(Nd node, Ap ap) {
        // When `node` is the target of a store, we interpret `clearsContent` as
        // only pertaining to _earlier_ store steps. In this case, we need to postpone
        // checking `clearsContent` to the step creation.
        clearContent(node, ap.getHead(), false)
      }

      pragma[nomagic]
      private predicate clearExceptStore(Nd node, Ap ap) { clearContent(node, ap.getHead(), true) }

      pragma[nomagic]
      private predicate expectsContentCand(Nd node, Ap ap) {
        exists(Content c |
          PrevStage::revFlow(node) and
          PrevStage::readStepCand(_, c, _) and
          Stage1::expectsContentEx(node, c) and
          c = ap.getHead()
        )
      }

      bindingset[node, t0, ap]
      predicate filter(Nd node, Typ t0, Ap ap, Typ t) {
        not clear(node, ap) and
        t0 = t and
        (
          Stage1::notExpectsContent(node)
          or
          expectsContentCand(node, ap)
        )
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(Nd node, Ap ap, boolean isStoreStep) {
        if clearExceptStore(node, ap) then isStoreStep = true else any()
      }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { any() }
    }

    private module Stage4 = MkStage<Stage3>::Stage<Stage4Param>;

    /**
     * Holds if a length 2 access path approximation with the head `c` is expected
     * to be expensive.
     */
    private predicate expensiveLen2unfolding(Content c) {
      exists(int tails, int nodes, int apLimit, int tupleLimit |
        tails = strictcount(AccessPathFront apf | Stage4::consCand(c, apf)) and
        nodes =
          strictcount(Nd n |
            Stage4::revFlow(n, any(AccessPathFrontHead apf | apf.getHead() = c))
            or
            Stage4::nodeMayUseSummary(n, any(AccessPathFrontHead apf | apf.getHead() = c))
          ) and
        accessPathApproxCostLimits(apLimit, tupleLimit) and
        apLimit < tails and
        tupleLimit < (tails - 1) * nodes and
        not forceHighPrecision(c)
      )
    }

    private newtype TAccessPathApprox =
      TNil() or
      TConsNil(Content c) {
        Stage4::consCand(c, TFrontNil()) and
        not expensiveLen2unfolding(c)
      } or
      TConsCons(Content c1, Content c2, int len) {
        Stage4::consCand(c1, TFrontHead(c2)) and
        len in [2 .. Config::accessPathLimit()] and
        not expensiveLen2unfolding(c1)
      } or
      TCons1(Content c, int len) {
        len in [1 .. Config::accessPathLimit()] and
        expensiveLen2unfolding(c)
      }

    /**
     * Conceptually a list of `Content`s, but only the first two elements of
     * the list and its length are tracked. If data flows from a source to a
     * given node with a given `AccessPathApprox`, this indicates the sequence
     * of dereference operations needed to get from the value in the node to
     * the tracked object.
     */
    abstract private class AccessPathApprox extends TAccessPathApprox {
      abstract string toString();

      abstract Content getHead();

      abstract int len();

      abstract AccessPathFront getFront();

      /** Holds if this is a representation of `head` followed by `tail`. */
      abstract predicate isCons(Content head, AccessPathApprox tail);
    }

    private class AccessPathApproxNil extends AccessPathApprox, TNil {
      override string toString() { result = "" }

      override Content getHead() { none() }

      override int len() { result = 0 }

      override AccessPathFront getFront() { result = TFrontNil() }

      override predicate isCons(Content head, AccessPathApprox tail) { none() }
    }

    abstract private class AccessPathApproxCons extends AccessPathApprox { }

    private class AccessPathApproxConsNil extends AccessPathApproxCons, TConsNil {
      private Content c;

      AccessPathApproxConsNil() { this = TConsNil(c) }

      override string toString() { result = "[" + c.toString() + "]" }

      override Content getHead() { result = c }

      override int len() { result = 1 }

      override AccessPathFront getFront() { result = TFrontHead(c) }

      override predicate isCons(Content head, AccessPathApprox tail) { head = c and tail = TNil() }
    }

    private class AccessPathApproxConsCons extends AccessPathApproxCons, TConsCons {
      private Content c1;
      private Content c2;
      private int len;

      AccessPathApproxConsCons() { this = TConsCons(c1, c2, len) }

      override string toString() {
        if len = 2
        then result = "[" + c1.toString() + ", " + c2.toString() + "]"
        else result = "[" + c1.toString() + ", " + c2.toString() + ", ... (" + len.toString() + ")]"
      }

      override Content getHead() { result = c1 }

      override int len() { result = len }

      override AccessPathFront getFront() { result = TFrontHead(c1) }

      override predicate isCons(Content head, AccessPathApprox tail) {
        head = c1 and
        (
          tail = TConsCons(c2, _, len - 1)
          or
          len = 2 and
          tail = TConsNil(c2)
          or
          tail = TCons1(c2, len - 1)
        )
      }
    }

    private class AccessPathApproxCons1 extends AccessPathApproxCons, TCons1 {
      private Content c;
      private int len;

      AccessPathApproxCons1() { this = TCons1(c, len) }

      override string toString() {
        if len = 1
        then result = "[" + c.toString() + "]"
        else result = "[" + c.toString() + ", ... (" + len.toString() + ")]"
      }

      override Content getHead() { result = c }

      override int len() { result = len }

      override AccessPathFront getFront() { result = TFrontHead(c) }

      override predicate isCons(Content head, AccessPathApprox tail) {
        head = c and
        (
          exists(Content c2 | Stage4::consCand(c, TFrontHead(c2)) |
            tail = TConsCons(c2, _, len - 1)
            or
            len = 2 and
            tail = TConsNil(c2)
            or
            tail = TCons1(c2, len - 1)
          )
          or
          len = 1 and
          Stage4::consCand(c, TFrontNil()) and
          tail = TNil()
        )
      }
    }

    private newtype TAccessPathApproxOption =
      TAccessPathApproxNone() or
      TAccessPathApproxSome(AccessPathApprox apa)

    private class AccessPathApproxOption extends TAccessPathApproxOption {
      string toString() {
        this = TAccessPathApproxNone() and result = "<none>"
        or
        this = TAccessPathApproxSome(any(AccessPathApprox apa | result = apa.toString()))
      }
    }

    private module Stage5Param implements MkStage<Stage4>::StageParam {
      private module PrevStage = Stage4;

      class Typ = Type;

      class Ap = AccessPathApprox;

      class ApNil = AccessPathApproxNil;

      pragma[nomagic]
      PrevStage::Ap getApprox(Ap ap) { result = ap.getFront() }

      Typ getTyp(Type t) { result = t }

      bindingset[c, tail]
      Ap apCons(Content c, Ap tail) { result.isCons(c, tail) }

      class ApHeadContent = Content;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      ApHeadContent projectToHeadContent(Content c) { result = c }

      class ApOption = AccessPathApproxOption;

      ApOption apNone() { result = TAccessPathApproxNone() }

      ApOption apSome(Ap ap) { result = TAccessPathApproxSome(ap) }

      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          Stage3Param::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand = Stage3Param::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import LocalCallContext

      predicate localStep =
        PrevStage::LocalFlowBigStep<Stage3Param::localFlowBigStep/6>::localFlowBigStepTc/6;

      bindingset[node, t0, ap]
      predicate filter(Nd node, Typ t0, Ap ap, Typ t) {
        strengthenType(node, t0, t) and
        exists(ap)
      }

      pragma[nomagic]
      private predicate clearExceptStore(Nd node, Ap ap) {
        Stage4Param::clearContent(node, ap.getHead(), true)
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(Nd node, Ap ap, boolean isStoreStep) {
        if clearExceptStore(node, ap) then isStoreStep = true else any()
      }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { compatibleTypesFilter(t1, t2) }
    }

    private module Stage5 = MkStage<Stage4>::Stage<Stage5Param>;

    pragma[nomagic]
    private predicate stage5ConsCand(Content c, AccessPathFront apf, int len) {
      Stage5::consCand(c, any(AccessPathApprox ap | ap.getFront() = apf and ap.len() = len - 1))
    }

    /**
     * Gets the number of length 2 access path approximations that correspond to `apa`.
     */
    private int count1to2unfold(AccessPathApproxCons1 apa) {
      exists(Content c, int len |
        c = apa.getHead() and
        len = apa.len() and
        result = strictcount(AccessPathFront apf | stage5ConsCand(c, apf, len))
      )
    }

    private int countNodesUsingAccessPath(AccessPathApprox apa) {
      result = strictcount(Nd n | Stage5::revFlow(n, apa) or Stage5::nodeMayUseSummary(n, apa))
    }

    /**
     * Holds if a length 2 access path approximation matching `apa` is expected
     * to be expensive.
     */
    private predicate expensiveLen1to2unfolding(AccessPathApproxCons1 apa) {
      exists(int aps, int nodes, int apLimit, int tupleLimit |
        aps = count1to2unfold(apa) and
        nodes = countNodesUsingAccessPath(apa) and
        accessPathCostLimits(apLimit, tupleLimit) and
        apLimit < aps and
        tupleLimit < (aps - 1) * nodes
      )
    }

    private predicate hasTail(AccessPathApprox apa, AccessPathApprox tail) {
      exists(Content head |
        apa.isCons(head, tail) and
        Stage5::consCand(head, tail)
      )
    }

    private predicate forceUnfold(AccessPathApprox apa) {
      forceHighPrecision(apa.getHead())
      or
      exists(Content c2 |
        apa = TConsCons(_, c2, _) and
        forceHighPrecision(c2)
      )
    }

    /**
     * Holds with `unfold = false` if a precise head-tail representation of `apa` is
     * expected to be expensive. Holds with `unfold = true` otherwise.
     */
    private predicate evalUnfold(AccessPathApprox apa, boolean unfold) {
      if forceUnfold(apa)
      then unfold = true
      else
        exists(int aps, int nodes, int apLimit, int tupleLimit |
          aps = countPotentialAps(apa) and
          nodes = countNodesUsingAccessPath(apa) and
          accessPathCostLimits(apLimit, tupleLimit) and
          if apLimit < aps and tupleLimit < (aps - 1) * nodes then unfold = false else unfold = true
        )
    }

    /**
     * Gets the number of `AccessPath`s that correspond to `apa`.
     */
    private int countAps(AccessPathApprox apa) {
      evalUnfold(apa, false) and
      result = 1 and
      (not apa instanceof AccessPathApproxCons1 or expensiveLen1to2unfolding(apa))
      or
      evalUnfold(apa, false) and
      result = count1to2unfold(apa) and
      not expensiveLen1to2unfolding(apa)
      or
      evalUnfold(apa, true) and
      result = countPotentialAps(apa)
    }

    /**
     * Gets the number of `AccessPath`s that would correspond to `apa` assuming
     * that it is expanded to a precise head-tail representation.
     */
    language[monotonicAggregates]
    private int countPotentialAps(AccessPathApprox apa) {
      apa instanceof AccessPathApproxNil and result = 1
      or
      result = strictsum(AccessPathApprox tail | hasTail(apa, tail) | countAps(tail))
    }

    private newtype TAccessPath =
      TAccessPathNil() or
      TAccessPathCons(Content head, AccessPath tail) {
        exists(AccessPathApproxCons apa |
          not evalUnfold(apa, false) and
          head = apa.getHead() and
          hasTail(apa, tail.getApprox())
        )
      } or
      TAccessPathCons2(Content head1, Content head2, int len) {
        exists(AccessPathApproxCons apa, AccessPathApprox tail |
          evalUnfold(apa, false) and
          not expensiveLen1to2unfolding(apa) and
          apa.len() = len and
          hasTail(apa, tail) and
          head1 = apa.getHead() and
          head2 = tail.getHead()
        )
      } or
      TAccessPathCons1(Content head, int len) {
        exists(AccessPathApproxCons apa |
          evalUnfold(apa, false) and
          expensiveLen1to2unfolding(apa) and
          apa.len() = len and
          head = apa.getHead()
        )
      }

    private module Stage6Param implements MkStage<Stage5>::StageParam {
      private module PrevStage = Stage5;

      class Typ = Type;

      class Ap = AccessPath;

      class ApNil = AccessPathNil;

      pragma[nomagic]
      PrevStage::Ap getApprox(Ap ap) { result = ap.getApprox() }

      Typ getTyp(Type t) { result = t }

      bindingset[c, tail]
      pragma[inline_late]
      Ap apCons(Content c, Ap tail) { result.isCons(c, tail) }

      class ApHeadContent = Content;

      pragma[noinline]
      ApHeadContent getHeadContent(Ap ap) { result = ap.getHead() }

      ApHeadContent projectToHeadContent(Content c) { result = c }

      private module ApOption = Option<AccessPath>;

      class ApOption = ApOption::Option;

      ApOption apNone() { result.isNone() }

      ApOption apSome(Ap ap) { result = ApOption::some(ap) }

      private module CallContextSensitivityInput implements CallContextSensitivityInputSig {
        predicate relevantCallEdgeIn = PrevStage::relevantCallEdgeIn/2;

        predicate relevantCallEdgeOut = PrevStage::relevantCallEdgeOut/2;

        predicate reducedViableImplInCallContextCand =
          Stage5Param::reducedViableImplInCallContext/3;

        predicate reducedViableImplInReturnCand = Stage5Param::reducedViableImplInReturn/2;
      }

      import CallContextSensitivity<CallContextSensitivityInput>
      import LocalCallContext

      predicate localStep =
        PrevStage::LocalFlowBigStep<Stage5Param::localStep/6>::localFlowBigStepTc/6;

      bindingset[node, t0, ap]
      predicate filter(Nd node, Typ t0, Ap ap, Typ t) {
        strengthenType(node, t0, t) and
        exists(ap)
      }

      pragma[nomagic]
      private predicate clearExceptStore(Nd node, Ap ap) {
        Stage4Param::clearContent(node, ap.getHead(), true)
      }

      bindingset[node, ap, isStoreStep]
      predicate stepFilter(Nd node, Ap ap, boolean isStoreStep) {
        if clearExceptStore(node, ap) then isStoreStep = true else any()
      }

      bindingset[t1, t2]
      predicate typecheck(Typ t1, Typ t2) { compatibleTypesFilter(t1, t2) }
    }

    module Stage6 = MkStage<Stage5>::Stage<Stage6Param>;

    /**
     * A list of `Content`s.
     *
     * If data flows from a source to a given node with a given `AccessPath`,
     * this indicates the sequence of dereference operations needed to get from
     * the value in the node to the tracked object.
     */
    private class AccessPath extends TAccessPath {
      /** Gets the head of this access path, if any. */
      abstract Content getHead();

      /** Holds if this is a representation of `head` followed by `tail`. */
      pragma[nomagic]
      abstract predicate isCons(Content head, AccessPath tail);

      /** Gets the front of this access path. */
      abstract AccessPathFront getFront();

      /** Gets the approximation of this access path. */
      abstract AccessPathApprox getApprox();

      /** Gets the length of this access path. */
      abstract int length();

      /** Gets a textual representation of this access path. */
      abstract string toString();
    }

    private class AccessPathNil extends AccessPath, TAccessPathNil {
      override Content getHead() { none() }

      override predicate isCons(Content head, AccessPath tail) { none() }

      override AccessPathFrontNil getFront() { result = TFrontNil() }

      override AccessPathApproxNil getApprox() { result = TNil() }

      override int length() { result = 0 }

      override string toString() { result = "" }
    }

    private class AccessPathCons extends AccessPath, TAccessPathCons {
      private Content head_;
      private AccessPath tail_;

      AccessPathCons() { this = TAccessPathCons(head_, tail_) }

      override Content getHead() { result = head_ }

      override predicate isCons(Content head, AccessPath tail) { head = head_ and tail = tail_ }

      override AccessPathFrontHead getFront() { result = TFrontHead(head_) }

      override AccessPathApproxCons getApprox() {
        result = TConsNil(head_) and tail_ = TAccessPathNil()
        or
        result = TConsCons(head_, tail_.getHead(), this.length())
        or
        result = TCons1(head_, this.length())
      }

      override int length() { result = 1 + tail_.length() }

      private string toStringImpl(boolean needsSuffix) {
        tail_ = TAccessPathNil() and
        needsSuffix = false and
        result = head_.toString() + "]"
        or
        result = head_ + ", " + tail_.(AccessPathCons).toStringImpl(needsSuffix)
        or
        exists(Content c2, Content c3, int len | tail_ = TAccessPathCons2(c2, c3, len) |
          result = head_ + ", " + c2 + ", " + c3 + ", ... (" and len > 2 and needsSuffix = true
          or
          result = head_ + ", " + c2 + ", " + c3 + "]" and len = 2 and needsSuffix = false
        )
        or
        exists(Content c2, int len | tail_ = TAccessPathCons1(c2, len) |
          result = head_ + ", " + c2 + ", ... (" and len > 1 and needsSuffix = true
          or
          result = head_ + ", " + c2 + "]" and len = 1 and needsSuffix = false
        )
      }

      override string toString() {
        result = "[" + this.toStringImpl(true) + this.length().toString() + ")]"
        or
        result = "[" + this.toStringImpl(false)
      }
    }

    private class AccessPathCons2 extends AccessPath, TAccessPathCons2 {
      private Content head1;
      private Content head2;
      private int len;

      AccessPathCons2() { this = TAccessPathCons2(head1, head2, len) }

      override Content getHead() { result = head1 }

      override predicate isCons(Content head, AccessPath tail) {
        head = head1 and
        Stage5::consCand(head1, tail.getApprox()) and
        tail.getHead() = head2 and
        tail.length() = len - 1
      }

      override AccessPathFrontHead getFront() { result = TFrontHead(head1) }

      override AccessPathApproxCons getApprox() {
        result = TConsCons(head1, head2, len) or
        result = TCons1(head1, len)
      }

      override int length() { result = len }

      override string toString() {
        if len = 2
        then result = "[" + head1.toString() + ", " + head2.toString() + "]"
        else
          result =
            "[" + head1.toString() + ", " + head2.toString() + ", ... (" + len.toString() + ")]"
      }
    }

    private class AccessPathCons1 extends AccessPath, TAccessPathCons1 {
      private Content head_;
      private int len;

      AccessPathCons1() { this = TAccessPathCons1(head_, len) }

      override Content getHead() { result = head_ }

      override predicate isCons(Content head, AccessPath tail) {
        head = head_ and
        Stage5::consCand(head_, tail.getApprox()) and
        tail.length() = len - 1
      }

      override AccessPathFrontHead getFront() { result = TFrontHead(head_) }

      override AccessPathApproxCons getApprox() { result = TCons1(head_, len) }

      override int length() { result = len }

      override string toString() {
        if len = 1
        then result = "[" + head_.toString() + "]"
        else result = "[" + head_.toString() + ", ... (" + len.toString() + ")]"
      }
    }

    private module S6Graph = Stage6::Graph;

    private module S6 = S6Graph::Public;

    import S6

    /**
     * Holds if data can flow from `source` to `sink`.
     */
    predicate flow(Node source, Node sink) {
      exists(PathNode source0, PathNode sink0 |
        flowPath(source0, sink0) and source0.getNode() = source and sink0.getNode() = sink
      )
    }

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowTo(Node sink) { exists(PathNode n | n.isSink() and n.getNode() = sink) }

    /**
     * Holds if data can flow from some source to `sink`.
     */
    predicate flowToExpr(Expr sink) { flowTo(exprNode(sink)) }

    /**
     * INTERNAL: Only for debugging.
     *
     * Calculates per-stage metrics for data flow.
     */
    predicate stageStats = Debug::stageStats/10;

    private module Stage1alias = Stage1;

    private module Stage2alias = Stage2;

    private module Stage3alias = Stage3;

    private module Stage4alias = Stage4;

    private module Stage5alias = Stage5;

    /**
     * INTERNAL: Subject to change without notice.
     *
     * Contains references to individual pruning stages.
     */
    module Stages {
      module Stage1 = Stage1alias;

      module Stage2 = Stage2alias;

      module Stage3 = Stage3alias;

      module Stage4 = Stage4alias;

      module Stage5 = Stage5alias;
    }

    /**
     * INTERNAL: Only for debugging.
     *
     * Contains references to individual pruning stages and stage statistics.
     */
    module Debug {
      import Stages

      predicate stageStats1(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stage = "1 Fwd" and
        n = 10 and
        Stage1::stats(true, nodes, fields, conscand, states, tuples, calledges) and
        tfnodes = -1 and
        tftuples = -1
        or
        stage = "1 Rev" and
        n = 15 and
        Stage1::stats(false, nodes, fields, conscand, states, tuples, calledges) and
        tfnodes = -1 and
        tftuples = -1
      }

      predicate stageStats2(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats1(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "2 Fwd" and
        n = 20 and
        Stage2::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "2 Rev" and
        n = 25 and
        Stage2::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats3(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats2(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "3 Fwd" and
        n = 30 and
        Stage3::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "3 Rev" and
        n = 35 and
        Stage3::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats4(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats3(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "4 Fwd" and
        n = 40 and
        Stage4::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "4 Rev" and
        n = 45 and
        Stage4::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats5(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats4(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "5 Fwd" and
        n = 50 and
        Stage5::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "5 Rev" and
        n = 55 and
        Stage5::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }

      predicate stageStats(
        int n, string stage, int nodes, int fields, int conscand, int states, int tuples,
        int calledges, int tfnodes, int tftuples
      ) {
        stageStats5(n, stage, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "6 Fwd" and
        n = 60 and
        Stage6::stats(true, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
        or
        stage = "6 Rev" and
        n = 65 and
        Stage6::stats(false, nodes, fields, conscand, states, tuples, calledges, tfnodes, tftuples)
      }
    }
  }
}
