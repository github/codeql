var obj = { a: source("a"), b: source("b1") };
sink(obj["a"]); // NOT OK

const { Map, fromJS, List, OrderedMap, Record, merge, Stack, Set, OrderedSet } = require('immutable');

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

const l1 = List([source(), "foobar"]);
l1.forEach(x => sink(x)); // NOT OK

l1.map(x => "safe").forEach(x => sink(x)); // OK

List(["safe"]).map(x => source()).forEach(x => sink(x)); // NOT OK

List([source()]).map(x => x).filter(x => true).toList().forEach(x => sink(x)); // NOT OK

List(["safe"]).push(source()).forEach(x => sink(x)); // NOT OK


const map4 = OrderedMap({}).set("f", source());
sink(map4.get("f")); // NOT OK

const map5 = Record({a: source(), b: null, c: null})({b: source()});
sink(map5.get("a")); // NOT OK
sink(map5.get("b")); // NOT OK
sink(map5.get("c")); // OK

const map6 = merge(Map({}), Record({a: source()})());
sink(map6.get("a")); // NOT OK

const map7 = map6.merge(Map({b: source()}));
sink(map7.get("b")); // NOT OK

Stack.of(source(), "foobar").forEach(x => sink(x)); // NOT OK

List.of(source()).filter(x => true).toList().forEach(x => sink(x)); // NOT OK

Set.of(source()).filter(x => true).toList().forEach(x => sink(x)); // NOT OK

Set([source()]).filter(x => true).toList().forEach(x => sink(x)); // NOT OK

OrderedSet([source()]).filter(x => true).toList().forEach(x => sink(x)); // NOT OK