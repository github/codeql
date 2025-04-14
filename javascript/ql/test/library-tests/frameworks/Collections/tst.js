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
  map.set("key", source);
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
	sink(e); // NOT OK
  }

  for (const e of new Set(set)) {
	sink(e); // NOT OK 
  }

  for (const e of Array.from(set)) {
    sink(e); // NOT OK
  }

  sink(map.get("key")); // NOT OK.
  sink(map.get("nonExistingKey")); // OK. 

  // unknown write, known read
  var map2 = new Map();
  map2.set(unknown(), source); 
  sink(map2.get("foo")); // NOT OK (for data-flow).

  // unknown write, unknown read
  var map3 = new Map();
  map3.set(unknown(), source); 
  sink(map3.get(unknown())); // NOT OK (for data-flow).

  // known write, unknown read
  var map4 = new Map();
  map4.set("foo", source); 
  sink(map3.get(unknown())); // NOT OK (for data-flow).
})();
