var obj = { a: source("a"), b: source("b1") };
sink(obj["a"]); // NOT OK

const { Map, fromJS } = require('immutable');

const map1 = Map(obj);

sink(map1.get("b")); // NOT OK

const map2 = map1.set('c', "safe");
sink(map1.get("a")); // NOT OK
sink(map2.get("a")); // NOT OK
sink(map2.get("b")); // OK - but still flagged [INCONSISTENCY]

const map3 = map2.set("d", source("d"));
sink(map1.get("d")); // OK
sink(map3.get("d")); // NOT OK


sink(map3.toJS()["a"]); // NOT OK

sink(fromJS({"e": source("e")}).get("e")); // NOT OK