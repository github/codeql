(function() {
  var source = source();
  var set = new Set();
  set.add(source);

  for (const e of set) {
	sink(e); // NOT OK.
  }

  set.forEach(e => {
    sink(e);
  })

  var map = new Map();
  map.set("key", source); map.set(unknownKey(), source);
  map.forEach(v => {
    sink(v);
  });

  for (const [key, value] of map) {
    sink(value); // NOT OK.
    sink(key); // OK
  }

  for (const value of map.values()) {
    sink(value); // NOT OK.
  }

  for (const e of set.values()) {
	sink(e); // NOT OK 
  }

  for (const e of set.keys()) {
	sink(e); // NOT OK 
  }

  for (const e of new Set(set.keys())) {
	sink(e); // NOT OK 
  }

  for (const e of new Set([source])) {
	sink(e); // NOT OK (not caught by type-tracking, as it doesn't include array steps).
  }

  for (const e of new Set(set)) {
	sink(e); // NOT OK 
  }

  for (const e of Array.from(set)) {
    sink(e); // NOT OK  (not caught by type-tracking, as it doesn't include array steps). 
  }

  sink(map.get("key")); // NOT OK.
  sink(map.get("nonExistingKey")); // OK. 
  sink(map.get(unknownKey())); // NOT OK (for data-flow). OK for type-tracking.
})();
