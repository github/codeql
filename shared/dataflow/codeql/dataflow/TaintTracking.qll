/**
 * Provides classes for performing local (intra-procedural) and
 * global (inter-procedural) taint-tracking analyses.
 */

import DataFlow
import DataFlowImpl
import DataFlowParameter
import TaintTrackingParameter

module TaintFlowMake<
  DataFlowParameter DataFlowLang, TaintTrackingParameter<DataFlowLang> TaintTrackingLang>
{
  private import DataFlowLang
  private import TaintTrackingLang
  private import DataFlowMake<DataFlowLang>
  private import MakeImpl<DataFlowLang>

  private module AddTaintDefaults<FullStateConfigSig Config> implements FullStateConfigSig {
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
  module Global<ConfigSig Config> implements GlobalFlowSig {
    private module Config0 implements FullStateConfigSig {
      import DefaultState<Config>
      import Config
    }

    private module C implements FullStateConfigSig {
      import AddTaintDefaults<Config0>
    }

    import Impl<C>
  }

  /** DEPRECATED: Use `Global` instead. */
  deprecated module Make<ConfigSig Config> implements GlobalFlowSig {
    import Global<Config>
  }

  /**
   * Constructs a global taint tracking computation using flow state.
   */
  module GlobalWithState<StateConfigSig Config> implements GlobalFlowSig {
    private module Config0 implements FullStateConfigSig {
      import Config
    }

    private module C implements FullStateConfigSig {
      import AddTaintDefaults<Config0>
    }

    import Impl<C>
  }

  /** DEPRECATED: Use `GlobalWithState` instead. */
  deprecated module MakeWithState<StateConfigSig Config> implements GlobalFlowSig {
    import GlobalWithState<Config>
  }
}
