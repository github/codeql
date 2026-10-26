import go

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node nd) {
    exists(ValueEntity v, Write w |
      v.getName().matches("source%") and
      w.writes(v, nd)
    )
  }

  predicate isSink(DataFlow::Node nd) {
    exists(ValueEntity v, Write w |
      v.getName().matches("sink%") and
      w.writes(v, nd)
    )
  }
}

module Flow = DataFlow::Global<Config>;

from DataFlow::Node source, DataFlow::Node sink
where Flow::flow(source, sink)
select source, sink
