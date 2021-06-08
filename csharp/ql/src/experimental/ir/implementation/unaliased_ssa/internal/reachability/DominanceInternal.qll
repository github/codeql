private import ReachableBlock as Reachability

private module ReachabilityGraph = Reachability::Graph;

module Graph {
  import Reachability::Graph

  class Block = Reachability::ReachableBlock;
}
