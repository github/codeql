private import DominanceInternal

predicate blockImmediatelyDominates(Graph::Block dominator, Graph::Block block) =
  idominance(Graph::isEntryBlock/1, Graph::blockSuccessor/2)(_, dominator, block)

predicate blockStrictlyDominates(Graph::Block dominator, Graph::Block block) {
  blockImmediatelyDominates+(dominator, block)
}

predicate blockDominates(Graph::Block dominator, Graph::Block block) {
  blockStrictlyDominates(dominator, block) or dominator = block
}

pragma[noinline]
Graph::Block getDominanceFrontier(Graph::Block dominator) {
  exists(Graph::Block pred |
    Graph::blockSuccessor(pred, result) and
    blockDominates(dominator, pred) and
    not blockStrictlyDominates(dominator, result)
  )
}
