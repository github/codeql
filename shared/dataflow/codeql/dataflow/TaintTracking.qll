/**
 * Provides modules for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

private import DataFlow as DF
private import internal.DataFlowImpl
private import codeql.util.Location

/**
 * Provides language-specific taint-tracking parameters.
 */
signature module InputSig<LocationSig Location, DF::InputSig<Location> Lang> {
  /**
   * Holds if `node` should be a sanitizer in all global taint flow configurations
   * but not in local taint.
   */
  predicate defaultTaintSanitizer(Lang::Node node);

  /**
   * Holds if the additional step from `src` to `sink` should be included in all
   * global taint flow configurations.
   */
  predicate defaultAdditionalTaintStep(Lang::Node src, Lang::Node sink, string model);

  /**
   * Holds if taint flow configurations should allow implicit reads of `c` at sinks
   * and inputs to additional taint steps.
   */
  bindingset[node]
  predicate defaultImplicitTaintRead(Lang::Node node, Lang::ContentSet c);

  /**
   * Holds if the additional step from `src` to `sink` should be considered in
   * speculative taint flow exploration.
   */
  predicate speculativeTaintStep(Lang::Node src, Lang::Node sink);
}

/**
 * Construct the modules for taint-tracking analyses.
 */
module TaintFlowMake<
  LocationSig Location, DF::InputSig<Location> DataFlowLang,
  InputSig<Location, DataFlowLang> TaintTrackingLang>
{
  private import TaintTrackingLang
  private import DF::DataFlowMake<Location, DataFlowLang> as DataFlow
  private import MakeImpl<Location, DataFlowLang> as DataFlowInternal

  private module AddTaintDefaults<DataFlowInternal::FullStateConfigSig Config> implements
    DataFlowInternal::FullStateConfigSig
  {
    import Config

    predicate isBarrier(DataFlowLang::Node node) {
      Config::isBarrier(node) or defaultTaintSanitizer(node)
    }

    predicate isAdditionalFlowStep(DataFlowLang::Node node1, DataFlowLang::Node node2, string model) {
      Config::isAdditionalFlowStep(node1, node2, model) or
      defaultAdditionalTaintStep(node1, node2, model)
    }

    predicate allowImplicitRead(DataFlowLang::Node node, DataFlowLang::ContentSet c) {
      Config::allowImplicitRead(node, c)
      or
      (
        Config::isSink(node) or
        Config::isSink(node, _) or
        Config::isAdditionalFlowStep(node, _, _) or
        Config::isAdditionalFlowStep(node, _, _, _, _)
      ) and
      defaultImplicitTaintRead(node, c)
    }
  }

  /**
   * Constructs a global taint tracking computation.
   */
  module Global<DataFlow::ConfigSig Config> implements DataFlow::GlobalFlowSig {
    private module Config0 implements DataFlowInternal::FullStateConfigSig {
      import DataFlowInternal::DefaultState<Config>
      import Config

      predicate isAdditionalFlowStep(
        DataFlowLang::Node node1, DataFlowLang::Node node2, string model
      ) {
        Config::isAdditionalFlowStep(node1, node2) and model = "Config"
      }
    }

    private module C implements DataFlowInternal::FullStateConfigSig {
      import AddTaintDefaults<Config0>
    }

    import DataFlowInternal::Impl<C>
  }

  /**
   * Constructs a global taint tracking computation using flow state.
   */
  module GlobalWithState<DataFlow::StateConfigSig Config> implements DataFlow::GlobalFlowSig {
    private module Config0 implements DataFlowInternal::FullStateConfigSig {
      import Config

      predicate isAdditionalFlowStep(
        DataFlowLang::Node node1, DataFlowLang::Node node2, string model
      ) {
        Config::isAdditionalFlowStep(node1, node2) and model = "Config"
      }

      predicate isAdditionalFlowStep(
        DataFlowLang::Node node1, FlowState state1, DataFlowLang::Node node2, FlowState state2,
        string model
      ) {
        Config::isAdditionalFlowStep(node1, state1, node2, state2) and model = "Config"
      }
    }

    private module C implements DataFlowInternal::FullStateConfigSig {
      import AddTaintDefaults<Config0>
    }

    import DataFlowInternal::Impl<C>
  }

  signature int speculationLimitSig();

  private module AddSpeculativeTaintSteps<
    DataFlowInternal::FullStateConfigSig Config, speculationLimitSig/0 speculationLimit> implements
    DataFlowInternal::FullStateConfigSig
  {
    import Config

    private predicate relevantState(Config::FlowState state) {
      Config::isSource(_, state)
      or
      exists(Config::FlowState state0 |
        relevantState(state0) and Config::isAdditionalFlowStep(_, state0, _, state, _)
      )
    }

    private newtype TFlowState =
      TMkFlowState(Config::FlowState state, int spec) {
        relevantState(state) and spec = [0 .. speculationLimit()]
      }

    class FlowState extends TFlowState {
      private Config::FlowState state;
      private int spec;

      FlowState() { this = TMkFlowState(state, spec) }

      string toString() { result = "FlowState" }

      Config::FlowState getState() { result = state }

      int getSpec() { result = spec }
    }

    predicate isSource(DataFlowLang::Node source, FlowState state) {
      Config::isSource(source, state.getState()) and state.getSpec() = 0
    }

    predicate isSink(DataFlowLang::Node sink, FlowState state) {
      Config::isSink(sink, state.getState())
    }

    predicate isBarrier(DataFlowLang::Node node, FlowState state) {
      Config::isBarrier(node, state.getState())
    }

    predicate isBarrierIn(DataFlowLang::Node node, FlowState state) {
      Config::isBarrierIn(node, state.getState())
    }

    predicate isBarrierOut(DataFlowLang::Node node, FlowState state) {
      Config::isBarrierOut(node, state.getState())
    }

    predicate isAdditionalFlowStep(
      DataFlowLang::Node node1, FlowState state1, DataFlowLang::Node node2, FlowState state2,
      string model
    ) {
      Config::isAdditionalFlowStep(node1, state1.getState(), node2, state2.getState(), model) and
      state1.getSpec() = state2.getSpec()
      or
      speculativeTaintStep(node1, node2) and
      not defaultAdditionalTaintStep(node1, node2, _) and
      not Config::isAdditionalFlowStep(node1, _, node2, _, _) and
      not Config::isAdditionalFlowStep(node1, node2, _) and
      model = "Speculative" and
      state1.getSpec() + 1 = state2.getSpec() and
      state1.getState() = state2.getState()
    }
  }

  /**
   * Constructs a global taint tracking computation that also allows a given
   * maximum number of speculative taint steps.
   */
  module SpeculativeGlobal<DataFlow::ConfigSig Config, speculationLimitSig/0 speculationLimit>
    implements DataFlow::GlobalFlowSig
  {
    private module Config0 implements DataFlowInternal::FullStateConfigSig {
      import DataFlowInternal::DefaultState<Config>
      import Config

      predicate isAdditionalFlowStep(
        DataFlowLang::Node node1, DataFlowLang::Node node2, string model
      ) {
        Config::isAdditionalFlowStep(node1, node2) and model = "Config"
      }
    }

    private module C implements DataFlowInternal::FullStateConfigSig {
      import AddTaintDefaults<AddSpeculativeTaintSteps<Config0, speculationLimit/0>>
    }

    import DataFlowInternal::Impl<C>
  }

  /**
   * Constructs a global taint tracking computation using flow state that also
   * allows a given maximum number of speculative taint steps.
   */
  module SpeculativeGlobalWithState<
    DataFlow::StateConfigSig Config, speculationLimitSig/0 speculationLimit> implements
    DataFlow::GlobalFlowSig
  {
    private module Config0 implements DataFlowInternal::FullStateConfigSig {
      import Config

      predicate isAdditionalFlowStep(
        DataFlowLang::Node node1, DataFlowLang::Node node2, string model
      ) {
        Config::isAdditionalFlowStep(node1, node2) and model = "Config"
      }

      predicate isAdditionalFlowStep(
        DataFlowLang::Node node1, FlowState state1, DataFlowLang::Node node2, FlowState state2,
        string model
      ) {
        Config::isAdditionalFlowStep(node1, state1, node2, state2) and model = "Config"
      }
    }

    private module C implements DataFlowInternal::FullStateConfigSig {
      import AddTaintDefaults<AddSpeculativeTaintSteps<Config0, speculationLimit/0>>
    }

    import DataFlowInternal::Impl<C>
  }
}
