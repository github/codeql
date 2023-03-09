/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import TaintTrackingParameter::Public
private import TaintTrackingParameter::Private

private module AddTaintDefaults<DataFlowInternal::FullStateConfigSig Config> implements
DataFlowInternal::FullStateConfigSig {
  import Config

  predicate isBarrier(DataFlow::Node node) {
    Config::isBarrier(node) or defaultTaintSanitizer(node)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    Config::isAdditionalFlowStep(node1, node2) or
    defaultAdditionalTaintStep(node1, node2)
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    Config::allowImplicitRead(node, c)
    or
    (
      Config::isSink(node, _) or
      Config::isAdditionalFlowStep(node, _) or
      Config::isAdditionalFlowStep(node, _, _, _)
    ) and
    defaultImplicitTaintRead(node, c)
  }
}

/**
 * Constructs a standard taint tracking computation.
 */
module Make<DataFlow::ConfigSig Config> implements DataFlow::DataFlowSig {
  private module Config0 implements DataFlowInternal::FullStateConfigSig {
    import DataFlowInternal::DefaultState<Config>
    import Config
  }

  private module C implements DataFlowInternal::FullStateConfigSig {
    import AddTaintDefaults<Config0>
  }

  import DataFlowInternal::Impl<C>
}

/**
 * Constructs a taint tracking computation using flow state.
 */
module MakeWithState<DataFlow::StateConfigSig Config> implements DataFlow::DataFlowSig {
  private module Config0 implements DataFlowInternal::FullStateConfigSig {
    import Config
  }

  private module C implements DataFlowInternal::FullStateConfigSig {
    import AddTaintDefaults<Config0>
  }

  import DataFlowInternal::Impl<C>
}
