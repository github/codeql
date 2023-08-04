/**
 * Provides modules for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

private import DataFlow
private import DataFlowImpl
private import DataFlowParameter
import TaintTrackingParameter

/**
 * Construct the modules for taint-tracking analyses.
 */
module TaintFlowMake<
  DataFlowParameter DataFlowLang, TaintTrackingParameter<DataFlowLang> TaintTrackingLang>
{
  private import TaintTrackingLang
  private import DataFlowMake<DataFlowLang> as DataFlow
  private import MakeImpl<DataFlowLang> as DataFlowInternal

  private module AddTaintDefaults<DataFlowInternal::FullStateConfigSig Config> implements
    DataFlowInternal::FullStateConfigSig
  {
    import Config

    predicate isBarrier(DataFlowLang::Node node) {
      Config::isBarrier(node) or defaultTaintSanitizer(node)
    }

    predicate isAdditionalFlowStep(DataFlowLang::Node node1, DataFlowLang::Node node2) {
      Config::isAdditionalFlowStep(node1, node2) or
      defaultAdditionalTaintStep(node1, node2)
    }

    predicate allowImplicitRead(DataFlowLang::Node node, DataFlowLang::ContentSet c) {
      Config::allowImplicitRead(node, c)
      or
      (
        Config::isSink(node) or
        Config::isSink(node, _) or
        Config::isAdditionalFlowStep(node, _) or
        Config::isAdditionalFlowStep(node, _, _, _)
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
    }

    private module C implements DataFlowInternal::FullStateConfigSig {
      import AddTaintDefaults<Config0>
    }

    import DataFlowInternal::Impl<C>
  }

  /** DEPRECATED: Use `Global` instead. */
  deprecated module Make<DataFlow::ConfigSig Config> implements DataFlow::GlobalFlowSig {
    import Global<Config>
  }

  /**
   * Constructs a global taint tracking computation using flow state.
   */
  module GlobalWithState<DataFlow::StateConfigSig Config> implements DataFlow::GlobalFlowSig {
    private module Config0 implements DataFlowInternal::FullStateConfigSig {
      import Config
    }

    private module C implements DataFlowInternal::FullStateConfigSig {
      import AddTaintDefaults<Config0>
    }

    import DataFlowInternal::Impl<C>
  }

  /** DEPRECATED: Use `GlobalWithState` instead. */
  deprecated module MakeWithState<DataFlow::StateConfigSig Config> implements
    DataFlow::GlobalFlowSig
  {
    import GlobalWithState<Config>
  }
}
