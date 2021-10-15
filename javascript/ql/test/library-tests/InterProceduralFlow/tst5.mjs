function source(x) {
  return x;
}

function sink(x) {
  return x;
}

function inc(x) {
  return x+1;
}

var flow = source(0);  // source
flow = inc(flow);
flow = source(flow);   // source
flow = sink(flow);     // sink for line 15, but not for line 13 (wrong parity)
flow = inc(flow);
sink(flow);            // sink for line 13, but not for line 15 (wrong parity)
