private import codeql.util.Location

/** Provides language-specific control flow parameters. */
signature module InputSig<LocationSig Location> {
  /**
   * A node in the control flow graph.
   */
  class Node {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the location of this node. */
    Location getLocation();
  }

  class CallNode extends Node;

  class Callable;

  predicate edge(Node n1, Node n2);

  predicate callTarget(CallNode call, Callable target);

  predicate flowEntry(Callable c, Node entry);

  predicate flowExit(Callable c, Node exitNode);

  Callable getEnclosingCallable(Node n);

  predicate hiddenNode(Node n);

  class Split {
    string toString();

    Location getLocation();

    predicate entry(Node n1, Node n2);

    predicate exit(Node n1, Node n2);

    predicate blocked(Node n1, Node n2);
  }
}

private module Configs<LocationSig Location, InputSig<Location> Lang> {
  private import Lang

  /** An input configuration for control flow. */
  signature module ConfigSig {
    /** Holds if `source` is a relevant control flow source. */
    predicate isSource(Node src);

    /** Holds if `sink` is a relevant control flow sink. */
    predicate isSink(Node sink);

    /** Holds if control flow should not proceed along the edge `n1 -> n2`. */
    default predicate isBarrierEdge(Node n1, Node n2) { none() }

    /**
     * Holds if control flow through `node` is prohibited. This completely
     * removes `node` from the control flow graph.
     */
    default predicate isBarrier(Node n) { none() }
  }

  /** An input configuration for control flow using a label. */
  signature module LabelConfigSig {
    class Label;

    /**
     * Holds if `source` is a relevant control flow source with the given
     * initial `l`.
     */
    predicate isSource(Node src, Label l);

    /**
     * Holds if `sink` is a relevant control flow sink accepting `l`.
     */
    predicate isSink(Node sink, Label l);

    /**
     * Holds if control flow should not proceed along the edge `n1 -> n2` when
     * the label is `l`.
     */
    default predicate isBarrierEdge(Node n1, Node n2, Label l) { none() }

    /**
     * Holds if control flow through `node` is prohibited when the label
     * is `l`.
     */
    default predicate isBarrier(Node n, Label l) { none() }
  }
}

module ControlFlowMake<LocationSig Location, InputSig<Location> Lang> {
  private import Lang
  private import internal.ControlFlowImpl::MakeImpl<Location, Lang>
  import Configs<Location, Lang>

  /**
   * The output of a global control flow computation.
   */
  signature module GlobalFlowSig {
    /**
     * A `Node` that is reachable from a source, and which can reach a sink.
     */
    class PathNode;

    /**
     * Holds if control can flow from `source` to `sink`.
     *
     * The corresponding paths are generated from the end-points and the graph
     * included in the module `PathGraph`.
     */
    predicate flowPath(PathNode source, PathNode sink);
  }

  /**
   * Constructs a global control flow computation.
   */
  module Global<ConfigSig Config> implements GlobalFlowSig {
    private module C implements FullConfigSig {
      import DefaultLabel<Config>
      import Config
    }

    import Impl<C>
  }

  /**
   * Constructs a global control flow computation using a flow label.
   */
  module GlobalWithLabel<LabelConfigSig Config> implements GlobalFlowSig {
    private module C implements FullConfigSig {
      import Config
    }

    import Impl<C>
  }
}
