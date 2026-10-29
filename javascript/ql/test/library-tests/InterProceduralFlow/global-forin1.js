var sink0 = p;
var source = [ "tainted" ];
for (var p in source) {
  var sink1 = p; // not picked up at the moment; we only propagate through
                 // for-in for locals
}
var sink2 = p; // ditto

