import python
private import semmle.python.dataflow.new.internal.DataFlowPrivate

query int implicit_use_count() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = count(x.getAnImplicitUse()))
}

query ControlFlowNode implicit_use() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = x.getAnImplicitUse())
}

query int source_use_count() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = count(x.getASourceUse()))
}

query ControlFlowNode source_use() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = x.getASourceUse())
}

query int use_use_edge_count() {
  exists(SsaSourceVariable x | x.getName() = "x" |
    result =
      count(NameNode use1, NameNode use2 |
        use1 = x.getAUse() and
        use2 = x.getAUse() and
        LocalFlow::useToNextUse(use1, use2)
      )
  )
}

query predicate use_use_edge(NameNode use1, NameNode use2) {
  exists(SsaSourceVariable x | x.getName() = "x" |
    use1 = x.getAUse() and
    use2 = x.getAUse() and
    LocalFlow::useToNextUse(use1, use2)
  )
}
