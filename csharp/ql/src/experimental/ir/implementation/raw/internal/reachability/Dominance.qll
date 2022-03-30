private import DominanceInternal

predicate blockImmediatelyDominates(Graph::Block dominator, Graph::Block block) =
  idominance(Graph::isEntryBlock/1, Graph::blockSuccessor/2)(_, dominator, block)

predicate blockStrictlyDominates(Graph::Block dominator, Graph::Block block) {
  blockImmediatelyDominates+(dominator, block)
}

predicate blockDominates(Graph::Block dominator, Graph::Block block) {
  blockStrictlyDominates(dominator, block) or dominator = block
}

Graph::Block getDominanceFrontier(Graph::Block dominator) {
  Graph::blockSuccessor(dominator, result) and
  not blockImmediatelyDominates(dominator, result)
  or
  exists(Graph::Block prev | result = getDominanceFrontier(prev) |
    blockImmediatelyDominates(dominator, prev) and
    not blockImmediatelyDominates(dominator, result)
  )
}
